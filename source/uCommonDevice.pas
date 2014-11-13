unit uCommonDevice;

interface

uses
 SysUtils, uModbus;

type

  TCommonModbusDevice = class
  protected
    FModbus: TModBus;
    FIdent: TModbusIdentification;
  public
    constructor Create;
    destructor Destroy; override;

    function Open(Port, Speed, Adr: integer): TModbusError; overload;
    function Open(Port, Speed: integer): boolean; overload;
    function Open(Host: string; Port: integer): boolean; overload;
    function Close: boolean;

    function ReadDeviceIdentification(Addr: byte; var Ident: TModbusIdentification): TModbusError;
    function FindFirst: byte;
    function FindNext(FromID: byte): byte;

    function Connect: boolean;

    property DeviceInfo: TModbusIdentification read FIdent;
  end;

implementation

function TCommonModbusDevice.ReadDeviceIdentification(Addr: byte;
  var Ident: TModbusIdentification): TModbusError;
var
  s,
  dataout: ansistring;
  k: integer;
begin
  Ident.Company := '';
  Ident.Product := '';
  Ident.Version := '';

  for k := 0 to 3 do
  begin
    Result := FModbus.CallFunction(Addr, 43, 14, #$01 + ansichar(k), dataout);
    if Result <> merNone then exit;

    s := Copy(dataout, 11, ord(dataout[10]));
    if Pos(#$0, s) > 0 then
      s := Copy(s, 1, Pos(#$0, s) - 1);

    case k of
      0: Ident.Company := s;
      1: Ident.Product := s;
      2: Ident.Version := s;
      3: Ident.VendorURL := s;
      else
    end;

    if dataout[6] <> #$FF then break; // больше нечего тащить
  end;
end;

function TCommonModbusDevice.Close: boolean;
begin
  Result := false;
  try
    FModbus.Destroy;
    Result := true;
  except
  end;
  FModbus := nil;
end;

function TCommonModbusDevice.Connect: boolean;
begin
  if FModbus = nil then
  begin
    Result := false;
    exit;
  end;

  Result := FModbus.Connected;
end;

constructor TCommonModbusDevice.Create;
begin
  FModbus := nil;

  inherited;
end;

destructor TCommonModbusDevice.Destroy;
begin
  inherited;

  try
    FModbus.Free;
  except
  end;
end;

function TCommonModbusDevice.FindFirst: byte;
begin
  Result := FModbus.FindFirst;
end;

function TCommonModbusDevice.FindNext(FromID: byte): byte;
begin
  Result := FModbus.FindNext(FromID);
end;

function TCommonModbusDevice.Open(Port, Speed: integer): boolean;
begin
  Result := false;
  try
    FModbus := TModbus.Create(Port, Speed);
    if FModbus.Connected then
      Result := true;
  except
    FModbus := nil;
  end;
end;

function TCommonModbusDevice.Open(Port, Speed, Adr: integer): TModbusError;
begin
  FIdent.Company := '';
  FIdent.Product := '';
  FIdent.Version := '';

  FModbus := TModbus.Create(Port, Speed);
  try
    result := ReadDeviceIdentification(Adr, FIdent);
    if result <> merNone then
      FModbus.Destroy;
  except
    FModbus.Destroy;
  end;
end;

function TCommonModbusDevice.Open(Host: string; Port: integer): boolean;
begin
  Result := false;
  FIdent.Company := '';
  FIdent.Product := '';
  FIdent.Version := '';

  try
    FModbus := TModbus.Create(Host, Port);
    Result := ReadDeviceIdentification(200, FIdent) in [merNone, merTimeout];
  except
    FModbus := nil;
  end;
end;

end.
