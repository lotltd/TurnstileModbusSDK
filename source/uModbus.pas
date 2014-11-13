unit uModbus;

{$IFDEF VER220}
  {$DEFINE UNDER_DELPHI_XE}
{$ENDIF}
{$IFDEF VER230}
  {$DEFINE UNDER_DELPHI_XE}
{$ENDIF}

interface
uses
 SysUtils, cport, WinSock, Sockets{$IFDEF UNDER_DELPHI_XE}, CPortTypes{$ENDIF};

type
  TModbusError = (
    merNone,
    merCantOpenPort,     // com port
    merTimeout,
    merAddressError,     // переданный и полученный адрес не совпадают
    merFuncError,        // переданный и полученный код функции не совпадают
    merCRCError,
    merWrongToLength,    // <253
    merWrongFromLength,  // from controller
    merModbusRecError,   // ошибка от контроллера, переданная им по модбасу
    merWrongDataLenFrom, // неправильная длина данных, полученная от контроллера
    merWrongDataLenTo,   // неправильная длина данных, переданная контроллеру
    merMBFunctionCode,   //-\
    merMBDataAddress,    //-|- ошибки, которые возвращает modbus
    merMBDataValue,      //-|
    merMBFuncExecute,    //-/
    merMFLenError,       // ошибки при приеме пакетов и преобразовании данных в модуле MiFARE
    merLast,
    merUndef = 255);

const
  StrModbusError: array [merNone .. merLast] of string = (
    'нет',
    'Не удалось открыть СОМ порт',
    'Таймаут связи с устройством',
    'Переданный и полученный адрес не совпадают',
    'Переданный и полученный код функции не совпадают',
    'Ошибка CRC пакета от устройства',
    'Слишком большой пакет для передачи устройству',
    'Несоответствие длины пакета и констант в пакете от устройства',
    'Ошибка модбаса',
    'Неправильная длина данных, полученная от устройства',
    'Неправильная длина данных, при попытке передачи на устройство',
    'Ошибка модбас (1) неправильная функция',
    'Ошибка модбас (2) неправильный адрес',
    'Ошибка модбас (3) неправильные данные в функции',
    'Ошибка модбас (4) исполнения функции',
    'Ошибка при приеме пакетов или преобразовании данных в модуле MiFARE',
    'нет'
    );

type
  TAddrQtyRec = packed record
   Addr: Word;
   Qty: Word;
  end;

  TAddrDataRec = packed record
   Addr: Word;
   Qty: Word;
  end;

  TRegDataRec = packed record
   Addr: Word;
   Qty: Word;
   data: array[1..250] of byte;
  end;

  TResultRec = packed record
   Qty: byte;
   data: array[1..250] of byte;
  end;

  TModbusIdentification = packed record
   Company,
   Product,
   Version,
   VendorURL: string;
  end;

  TModbus = class
  private
    FModbusTCP: boolean;
    FPort: TComPort;
    FSocket: TTcpClient;

    function SendTCP(TxSleep: cardinal; datain: AnsiString; var dataout: AnsiString): TModbusError;
    function SendRTU(TxSleep: cardinal; datain: AnsiString; var dataout: AnsiString): TModbusError;
  public
    constructor Create(Port: Integer; Speed: integer); overload;
    constructor Create(Host: string; Port: integer);   overload;
    destructor Destroy; reintroduce;

    function Send(ATxSleep: cardinal; Address, Func: byte; data: AnsiString; var dataout: AnsiString): TModbusError;

    function ReadCoilStatus(Address: byte; param: TAddrQtyRec; var output: TResultRec): TModbusError;      // 1
    function ReadDiscreteInputs(Address: byte; param: TAddrQtyRec; var output: TResultRec): TModbusError;  // 2
    function ReadHoldingRegisters(Address: byte; param: TAddrQtyRec; var output: TResultRec): TModbusError;// 3
    function ForceSingleCoil(Address: byte; OutputAddr: Word; state: boolean): TModbusError;               // 5
    function PresetSingleRegister(Address: byte; param: TAddrDataRec): TModbusError;                       // 6
    function WriteMultipleRegisters(Address: byte; input: TRegDataRec): TModbusError;                      //16

    //  modbus function
    function CallFunction(Address: byte; code, subcode: byte; data: AnsiString; var dataout: AnsiString): TModbusError;

    //  search device
    function FindFirst: byte;
    function FindNext(FromID: byte): byte;

    // Work with TCP
    function TCPConnect: boolean;

    function Connected: boolean;
  end;

implementation

uses Math, windows;

{ TModbus }

function ArrByteToString(data: array of byte; Qty: integer = -1): ansistring;
var
 len: integer;
begin
  Result := '';
  if Qty < 0 then
    len := length(data)
  else
    len := Qty;

  if len > 250 then exit;

  SetLength(Result, len);
  move(data[0], Result[1], len);
end;

function TModbus.CallFunction(Address, code, subcode: byte;
  data: AnsiString; var dataout: AnsiString): TModbusError;
begin
  Result := Send(100, Address, code, ansichar(subcode) + data, dataout);
end;

constructor TModbus.Create(Port, Speed: integer);
begin
  inherited Create;

  FModbusTCP := false;
  FPort := TComPort.Create(Nil);
  FPort.Port := 'COM' + IntToStr(Port);

  case speed of
    115200: FPort.BaudRate := br115200;
    9600: FPort.BaudRate := br9600;
    2400: FPort.BaudRate := br2400;
    1200: FPort.BaudRate := br1200;
  else
    FPort.BaudRate := br115200;
  end;
  try
    FPort.Open;
  except
  end;
end;

function TModbus.Connected: boolean;
begin
  if not FModbusTCP then
    Result := FPort.Connected
  else
    Result := TCPConnect;
end;

constructor TModbus.Create(Host: string; Port: integer);
begin
  inherited Create;

  FModbusTCP := true;
  FSocket := TTcpClient.Create(nil);
  FSocket.RemoteHost := Host;
  FSocket.RemotePort := IntToStr(Port);
  FSocket.BlockMode := bmBlocking;
end;

destructor TModbus.Destroy;
begin
  if FModbusTCP then
  begin
    FSocket.Close;
    FSocket.Destroy;
  end
  else
  begin
    FPort.Close;
    FPort.Destroy;
  end;

  inherited;
end;

function crc16string(msg: ansistring): ansistring;
var
  crc: word;
  n,
  i: integer;
  b:byte;
begin
  crc := $FFFF;
  for i := 1 to length (msg) do
  begin
    b := byte(msg[i]);
    crc := crc xor b;
    for n := 1 to 8 do
    begin
      if (crc and 1) <> 0 then
        crc := (crc shr 1) xor $A001
      else crc := crc shr 1;
    end;
  end;

  result := ansichar(crc and $ff) + ansichar(crc shr 8);
end;

function TModbus.FindFirst: byte;
var
  i: integer;
  err: TModbusError;
  param: TAddrQtyRec;
  output: TResultRec;
begin
  Result := 0;
  param.Addr := 0;
  param.Qty := 1;
  for i := 1 to 250 do
  begin
    err := ReadHoldingRegisters(i, param, output);
    if not (err in [merCantOpenPort, merTimeout, merWrongDataLenTo]) then
    begin
      Result := i;
     exit;
    end;
  end;
end;

function TModbus.FindNext(FromID: byte): byte;
var
  i: integer;
  err: TModbusError;
  param: TAddrQtyRec;
  output: TResultRec;
begin
  Result := 0;
  param.Addr := 0;
  param.Qty := 1;
  for i := FromID + 1 to 250 do
  begin
    err := ReadHoldingRegisters(i, param, output);
    if not (err in [merCantOpenPort, merTimeout, merWrongDataLenTo]) then
    begin
     Result := i;
     exit;
    end;
  end;
end;

function TModbus.ForceSingleCoil(Address: byte; OutputAddr: Word; state: boolean): TModbusError;
begin
  Result := merNone
end;

function TModbus.PresetSingleRegister(Address: byte; param: TAddrDataRec): TModbusError;
begin
  Result := merNone
end;

function TModbus.ReadCoilStatus(Address: byte; param: TAddrQtyRec;
  var output: TResultRec): TModbusError;
var
 vin,
 vout: AnsiString;
begin
  output.Qty := 0;
  vin := '    ';
  move(param, vin[1], 4);
  Result := Send(20 + param.Qty div 12, Address, 1, vin, vout);

  if Result = merNone then
  begin
   if (length(vout) < 2) or (ord(vout[1]) + 1 <> length(vout))  then
   begin
    Result := merWrongDataLenFrom;
    exit;
   end;

   output.Qty := Ord(vout[1]);
   move(vout[2], output.data[1], output.Qty);
  end;
end;

function TModbus.ReadDiscreteInputs(Address: byte; param: TAddrQtyRec;
  var output: TResultRec): TModbusError;
begin
  Result := merNone
end;

function TModbus.ReadHoldingRegisters(Address: byte; param: TAddrQtyRec;
  var output: TResultRec): TModbusError;
var
  vin,
  vout: AnsiString;
begin
  Result := merWrongDataLenTo;
  if param.Qty > 128 then exit;
  vin := AnsiChar(Hi(param.Addr)) + AnsiChar(Lo(param.Addr)) +
    AnsiChar(Hi(param.Qty)) + AnsiChar(Lo(param.Qty));

  Result := Send(40 + param.Qty div 2, Address, 03, vin, vout);
  if Result <> merNone then exit;
  if length(vout) <> ord(vout[3]) + 5 then
  begin
    Result := merWrongDataLenFrom;
    exit;
  end;

  output.Qty := ord(vout[3]);
// SetLength(output.data, output.Qty);
  move(vout[4], output.data[1], output.Qty);
end;

function TModbus.Send(ATxSleep: cardinal; Address, Func: byte; data: AnsiString; var dataout: AnsiString): TModbusError;
var
  s: ansistring;
begin
  Result := merUndef;
  dataout := '';

  if Length(data) >= 253 then
  begin
    Result := merWrongToLength;
    exit;
  end;

  s := AnsiChar(Address) + AnsiChar(Func) + data;

  // send
  try
    if FModbusTCP then
      Result := SendTCP(ATxSleep, s, dataout)
    else
      Result := SendRTU(ATxSleep, s, dataout);

    if Result <> merNone then exit;
  except
    sleep(10);
  end;

  // process
  if Length(dataout) = 0 then
  begin
    Result := merTimeout;
    exit;
  end;

  if (Length(dataout) < 4) or (Length(dataout) > 250) then
  begin
    dataout := '';
    Result := merWrongFromLength;
    exit;
  end;

  if dataout[1] <> AnsiChar(Address) then
  begin
    Result := merAddressError;
    exit;
  end;
  if dataout[2] <> AnsiChar(Func) then
  begin
    Result := merFuncError;
    if (ord(dataout[2]) xor $80) = Func then
    begin
      case ord(dataout[3]) of
        01: Result := merMBFunctionCode;
        02: Result := merMBDataAddress;
        03: Result := merMBDataValue;
        04: Result := merMBFuncExecute;
        else
      end;
    end;
    exit;
  end;
end;

function TModbus.SendRTU(TxSleep: cardinal; datain: AnsiString; var dataout: AnsiString): TModbusError;
var
  s: AnsiString;
  cnt: integer;
  i, j: integer;
  tmp: cardinal;
begin
  Result := merNone;
  s := datain + crc16string(datain);

  if not FPort.Connected then
  begin
    Result := merCantOpenPort;
    exit;
  end;

  //flush
  FPort.ReadStr(dataout, FPort.InputCount);
  //write

  FPort.WriteStr(s);

  TxSleep := GetTickCount + TxSleep;
  while (GetTickCount < TxSleep) do
  begin
    cnt := FPort.InputCount;
    if cnt <> 0 then
    begin
      tmp := GetTickCount;
      if TxSleep > tmp then
        sleep(TxSleep - tmp);
      break;
    end;
  end;

//  sleep(TxSleep);
  dataout := '';
//  cnt := FPort.InputCount;
  if cnt <> 0 then
    FPort.ReadStr(dataout, cnt)
  else
    Result := merTimeout;

  // похоже выгребли не все
  i := 5;
  while ((dataout = '') or (crc16string(dataout) <> #0#0)) and (i > 0) do
  begin
    sleep(20);

    FPort.ReadStr(s, FPort.InputCount);
    dataout := dataout + s;
    if s <> '' then
      Result := merNone;

    i := i - 1;
  end;

  if Result <> merNone then exit;
  if crc16string(dataout) <> #0#0 then
  begin
    Result := merCRCError;
    exit;
  end;
end;

function TModbus.SendTCP(TxSleep: cardinal; datain: AnsiString; var dataout: AnsiString): TModbusError;
var
  cnt: integer;
  s: AnsiString;
  buf: array [0 .. 1024] of AnsiChar;
  len: word;
begin
  Result := merNone;
  len := length(datain);
  s := AnsiString(#0#1) + AnsiString(#0#0) + AnsiChar(hi(len)) + AnsiChar(lo(len)) + datain;

  if not FSocket.Connected then
   try
     FSocket.Close;
     if not TCPConnect then
      begin
       Result := merCantOpenPort;
       exit;
      end;
   except
    Result := merCantOpenPort;
    exit;
   end;

  //flush
  if FSocket.WaitForData(1) then
   begin
    cnt := FSocket.PeekBuf(buf[0], length(buf));
    if cnt > 0 then FSocket.ReceiveBuf(buf[0], cnt);
   end;

  //write
  cnt := FSocket.SendBuf(s[1], length(s));

  // try to resend if socket closed
  if cnt = -1 then
   begin
    FSocket.Close;
    if TCPConnect then
      cnt := FSocket.SendBuf(s[1], length(s));
   end;

  if cnt <> length(s) then
   begin
    Result := merCantOpenPort;
    FSocket.Close;
    exit;
   end;

  dataout := '';

  if FSocket.WaitForData(TxSleep) then
   begin
    cnt := FSocket.PeekBuf(buf[0], length(buf));
    if cnt > 0 then
     begin
      FSocket.ReceiveBuf(buf[0], cnt);
      SetLength(dataout, cnt);
      move(buf[0], dataout[1], cnt);
     end
    else
      Result := merTimeout;
   end;

  // похоже выгребли не все
  if dataout = '' then
   if FSocket.WaitForData(200) then
    begin
     cnt := FSocket.PeekBuf(buf[0], length(buf));
     if cnt > 0 then
      begin
       FSocket.ReceiveBuf(buf[0], cnt);
       SetLength(s, cnt);
       move(buf[0], s[1], cnt);
      end;

     if s <> '' then Result := merNone;
     dataout := dataout + s;
    end;

  if length(dataout) = 0 then
   begin
    Result := merTimeout;
    exit;
   end;

  if length(dataout) < 9 then
   begin
    dataout := '';
    Result := merWrongFromLength;
    exit;
   end;

  if ord(dataout[5]) * 256 + ord(dataout[6]) <> length(dataout) - 6 then
   begin
    dataout := '';
    Result := merWrongFromLength;
    exit;
   end;

  dataout := Copy(dataout, 7, length(dataout));
  dataout := dataout + crc16String(dataout);
end;

function TModbus.TCPConnect: boolean;
begin
  Result := false;
  if not FModbusTCP then
  begin
    Result := true;
    exit;
  end;
  try
    Result := FSocket.Connect
  except
  end;
end;

function TModbus.WriteMultipleRegisters(Address: byte;
  input: TRegDataRec): TModbusError;
var
  vin: AnsiString;
  output: ansistring;
begin
  Result := merWrongDataLenTo;
  if input.Qty > 128 then exit;
  vin := AnsiChar(Hi(input.Addr)) + AnsiChar(Lo(input.Addr)) +
    AnsiChar(Hi(input.Qty)) + AnsiChar(Lo(input.Qty)) +
    AnsiChar(input.Qty * 2) +
    ArrByteToString(input.data, input.Qty * 2);

  Result := Send(40 + input.Qty, Address, 16, vin, output);

  if Result <> merNone then exit;
  if ord(output[5]) * $FF + ord(output[6]) <> input.Qty then
  begin
    Result := merWrongDataLenFrom;
    exit;
  end;
end;

end.

