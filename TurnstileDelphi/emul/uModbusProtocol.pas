unit uModbusProtocol;

interface

uses
  Windows, System.SysUtils, uProtocol, uCommonDevice, uModbus, uTurnDef,
  Web.Win.Sockets;

type
  TCommonModbusDeviceEmul = class(TCommonModbusDevice)
  private
    FTCP: TTcpServer;
  public
    function ReadData(var data: AnsiString): TModbusError;
    function WriteData(var data: AnsiString): TModbusError;
    function ReadDataTCP(var data: AnsiString): TModbusError;
    function WriteDataTCP(var data: AnsiString): TModbusError;

    property TCP: TTcpServer read FTCP write FTCP;

    procedure Accept(Sender: TObject; ClientSocket: TCustomIpClient);
  end;

  TModbusProtocol = class(TProtocol)
  private
    FDev: TCommonModbusDeviceEmul;
    FIsTCP: boolean;
  protected
   function Deserialize(Data: AnsiString): AnsiString; override;

   procedure Execute; override;
  public
    constructor Create(Port: byte); overload;
    constructor Create(Host: ansistring; Port: word); overload;
    destructor Destroy;
  end;

implementation

{ TModbusProtocol }

constructor TModbusProtocol.Create(Port: byte);
begin
  inherited Create;

  FIsTCP := false;

  FDev := TCommonModbusDeviceEmul.Create;
  FDev.Open(Port, 115200);
  if not FDev.Connect then
  begin
    FDev.Free;
    FCommunicatorState := csNotConnected;
  end
  else
  begin
    FCommunicatorState := csConnected;
  end;
  resume;
end;

constructor TModbusProtocol.Create(Host: ansistring; Port: word);
begin
  inherited Create;

  FIsTCP := true;

  FDev := TCommonModbusDeviceEmul.Create;
  FDev.TCP := TTCPServer.Create(nil);
  FDev.TCP.LocalHost := Host;
  FDev.TCP.LocalPort := IntToStr(Port);
  FDev.TCP.OnAccept := FDev.Accept;
  FDev.TCP.BlockMode := bmThreadBlocking;
  FDev.TCP.Open;
  if not FDev.TCP.Active then
  begin
    FDev.TCP.Free;
    FCommunicatorState := csNotConnected;
  end
  else
  begin
    FCommunicatorState := csConnected;
  end;
  resume;
end;

function TModbusProtocol.Deserialize(Data: AnsiString): AnsiString;
var
  addr: byte; //адрес турникета
  datain: word;
  func: byte;
  reg: word; //адрес регистра
  s: ansistring;
begin
  WriteLog('<= ' + data);
  addr := ord(data[1]);
  func := ord(data[2]);
  s := AnsiChar(addr);
  reg := ord(data[3]) shl 8 + ord(data[4]);
  case func of
    $2B: begin
           s := s + #$2B + #$0E;
           if ord(data[5]) = $00 then
             s := s + #$00 + #$01 + #$FF + #$01 + #$03 + #$00 + #$07 + 'Lot LTD';
           if ord(data[5]) = $01 then
             s := s + #$01 + #$01 + #$FF + #$02 + #$03 + #$01 + #$07 + 'virtual';
           if ord(data[5]) = $02 then
             s := s + #$02 + #$01 + #$FF + #$03 + #$03 + #$02 + #$04 + 'ver1';
           if ord(data[5]) = $03 then
             s := s + #$03 + #$01 + #$00 + #$00 + #$03 + #$03 + #$03 + 'url';
         end;
    $03: begin
           s := s + #$03;
           //Состояние входа
           if reg = $40 then
             s := s + #$02 + AnsiChar(hi(Turnstiles.ByAddr(addr).EnterState)) + AnsiChar(lo(Turnstiles.ByAddr(addr).EnterState));
           //Состояние выхода
           if reg = $41 then
             s := s + #$02 + AnsiChar(hi(Turnstiles.ByAddr(addr).ExitState)) + AnsiChar(lo(Turnstiles.ByAddr(addr).ExitState));

           //Количество проходов в направлении вход младшие 16 бит
           if reg = $44 then
             s := s + #$02 + AnsiChar(LongRec(Turnstiles.ByAddr(addr).EnterCount).Bytes[1]) + AnsiChar(LongRec(Turnstiles.ByAddr(addr).EnterCount).Bytes[0]);
           //Количество проходов в направлении вход старшие 16 бит
           if reg = $45 then
             s := s + #$02 + AnsiChar(LongRec(Turnstiles.ByAddr(addr).EnterCount).Bytes[3]) + AnsiChar(LongRec(Turnstiles.ByAddr(addr).EnterCount).Bytes[2]);
           //Количество проходов в направлении выход младшие 16 бит
           if reg = $46 then
             s := s + #$02 + AnsiChar(LongRec(Turnstiles.ByAddr(addr).ExitCount).Bytes[1]) + AnsiChar(LongRec(Turnstiles.ByAddr(addr).ExitCount).Bytes[0]);
           //Количество проходов в направлении выход старшие 16 бит
           if reg = $47 then
             s := s + #$02 + AnsiChar(LongRec(Turnstiles.ByAddr(addr).ExitCount).Bytes[3]) + AnsiChar(LongRec(Turnstiles.ByAddr(addr).ExitCount).Bytes[2]);

           //Старший байт - флаг новизны данных сканера/считывателя в направлении выход
           //0x0 – Новых данных нет
           //0x1 – Новые данные
           //Младший байт - количество данных в буфере принятых с выходного сканера
           if reg = $100 then
             if Turnstiles.ByAddr(addr).EnterCardNum <> '' then
               s := s + #$02 + #$01 + AnsiChar(Length(Turnstiles.ByAddr(addr).EnterCardNum))
             else
               s := s + #$02 + #$00 + #$00;
           if reg = $101 then
           begin
             s := s + AnsiChar(Length(Turnstiles.ByAddr(addr).EnterCardNum)) + Turnstiles.ByAddr(addr).EnterCardNum;
             Turnstiles.ByAddr(addr).EnterCardNum := '';
           end;
           //Старший байт - флаг новизны данных сканера/считывателя в направлении выход
           //0x0 – Новых данных нет
           //0x1 – Новые данные
           //Младший байт - количество данных в буфере принятых с выходного сканера
           if reg = $200 then
             if Turnstiles.ByAddr(addr).ExitCardNum <> '' then
               s := s + #$02 + #$01 + AnsiChar(Length(Turnstiles.ByAddr(addr).ExitCardNum))
             else
               s := s + #$02 + #$00 + #$00;
           if reg = $201 then
           begin
             s := s + AnsiChar(Length(Turnstiles.ByAddr(addr).ExitCardNum)) + Turnstiles.ByAddr(addr).ExitCardNum;
             Turnstiles.ByAddr(addr).ExitCardNum := '';
           end;
           if (reg = $42) or (reg = $43) or (reg = $48) or (reg = $666) then
             s := s + #$01 + #$00;
         end;
    $10: begin
           s := s + #$10;
           //Установка входа
           if reg = $40 then
           begin
             datain := ord(data[8]) shl 8 + ord(data[9]);
             Turnstiles.ByAddr(addr).EnterState := datain;
             s := s + #$00 + #$40 + #$00 + #$01;
           end;
           //Установка выхода
           if reg = $41 then
           begin
             datain := ord(data[8]) shl 8 + ord(data[9]);
             Turnstiles.ByAddr(addr).ExitState := datain;
             s := s + #$00 + #$41 + #$00 + #$01;
           end;
         end;
  end;
  if length(s) > 2 then
  begin
    WriteLog('=> ' + s);
    if FIsTcp then
      FDev.WriteDataTCP(s)
    else
      FDev.WriteData(s);
  end;
end;

destructor TModbusProtocol.Destroy;
begin
  if FCommunicatorState = csConnected then
  begin
    FDev.Close;
    if Fdev.TCP.Active then
      FDev.TCP.Close;
    FDev.Free;
  end;
end;

procedure TModbusProtocol.Execute;
var
  data: ansistring;
begin
  inherited;

  while (not Terminated) and (FCommunicatorState = csConnected) do
  begin
    data := '';
    if not FIsTCP then
      FDev.ReadData(data)
    else
      FDev.ReadDataTCP(data);
    if Length(data) > 0 then
      Deserialize(data);
    sleep(5);
  end;
end;

{ TCommonModbusDeviceEmul }

procedure TCommonModbusDeviceEmul.Accept(Sender: TObject;
  ClientSocket: TCustomIpClient);
begin
  Sender := nil;
end;

function TCommonModbusDeviceEmul.ReadData(var data: AnsiString): TModbusError;
var
  s: AnsiString;
  cnt: integer;
  i: integer;
  tmp: cardinal;
  TxSleep: integer;
begin
  TxSleep := 40;
  Result := merNone;

  if not FModbus.Port.Connected then
  begin
    Result := merCantOpenPort;
    exit;
  end;

  TxSleep := GetTickCount + TxSleep;
  while (GetTickCount < TxSleep) do
  begin
    cnt := FModbus.Port.InputCount;
    if cnt <> 0 then
    begin
      tmp := GetTickCount;
      if TxSleep > tmp then
        sleep(TxSleep - tmp);
      break;
    end;
  end;

//  sleep(TxSleep);
  data := '';
//  cnt := FPort.InputCount;
  if cnt <> 0 then
    FModbus.Port.ReadStr(data, cnt)
  else
    Result := merTimeout;

  // похоже выгребли не все
  i := 5;
  while ((data = '') or (crc16string(data) <> #0#0)) and (i > 0) do
  begin
    sleep(20);

    FModbus.Port.ReadStr(s, FModbus.Port.InputCount);
    data := data + s;
    if s <> '' then
      Result := merNone;

    i := i - 1;
  end;

  if Result <> merNone then exit;
  if crc16string(data) <> #0#0 then
  begin
    Result := merCRCError;
    exit;
  end;
end;

function TCommonModbusDeviceEmul.ReadDataTCP(
  var data: AnsiString): TModbusError;
var
  s: AnsiString;
  cnt: integer;
  i: integer;
  tmp: cardinal;
begin
  Result := merNone;

  if not FTCP.Active then
  begin
    Result := merCantOpenPort;
    exit;
  end;

  data := FTCP.Receiveln;

  if crc16string(data) <> #0#0 then
  begin
    Result := merCRCError;
    exit;
  end;
end;

function TCommonModbusDeviceEmul.WriteData(
  var data: AnsiString): TModbusError;
var
  s: AnsiString;
begin
  Result := merNone;
  s := data + crc16string(data);

  if not FModbus.Port.Connected then
  begin
    Result := merCantOpenPort;
    exit;
  end;

  //flush
  FModbus.Port.ReadStr(data, FModbus.Port.InputCount);
  //write

  FModbus.Port.WriteStr(s);
end;

function TCommonModbusDeviceEmul.WriteDataTCP(
  var data: AnsiString): TModbusError;
var
  s: AnsiString;
begin
  Result := merNone;
  s := data + crc16string(data);

  if not FTCP.Active then
  begin
    Result := merCantOpenPort;
    exit;
  end;

  FTCP.Sendln(data);
end;

end.
