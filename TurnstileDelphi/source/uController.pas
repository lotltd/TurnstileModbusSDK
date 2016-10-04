unit uController;

interface

uses
  SysUtils, System.Math, uCommonDevice, uModbus, syncobjs;

type
  TAr = array[0..59] of byte;

  TController = class(TCommonModbusDevice)
  private
    function ReadData(Addr: byte; RegAddr: word; var Ans: word): TModbusError; overload;
    function ReadData(Addr: byte; RegAddr: word; var Ans: ansistring; Count: byte = 1): TModbusError; overload;
    function WriteState(Addr: byte; RegAddr: word; Value: array of word): TModbusError;
  public
    //Данные сканера входа
    function GetEnterCard(Addr: byte; var IsNew: boolean; var CardNum: TAr; var Count: word): TModbusError;
    //Данные сканера выхода
    function GetExitCard(Addr: byte; var IsNew: boolean; var CardNum: TAr; var Count: word): TModbusError;
    //Состояние входа
    //0	– проход закрыт;
    //(1-$FFFЕ) – количество разрешенных проходов
    //$FFFF – разрешен свободный проход
    function GetEnter(Addr: byte; var Value: word): TModbusError;
    //Состояние выхода
    //0	– проход закрыт;
    //(1-$FFFЕ) – количество разрешенных проходов
    //$FFFF – разрешен свободный проход
    function GetExit(Addr: byte; var Value: word): TModbusError;
    //0 - нормальный режим
    //1 - режим Блокировки
    //2 - режим Антипаники
    function GetPassState(Addr: byte; var Value: word): TModbusError;
    //Ошибки:
    //0 – Ошибок нет
    //не 0 – Наличие ошибок в системе
    function GetErrorState(Addr: byte; var Value: word): TModbusError;
    //Количество проходов в направлении вход
    function GetEnterCount(Addr: byte; var Value: longword): TModbusError;
    //Количество проходов в направлении выход
    function GetExitCount(Addr: byte; var Value: longword): TModbusError;
    //Состояние входа
    //0 - Проход в направлении вход свободен
    //Не 0 – позиция(наличие) объекта с направления вход
    function GetEnterState(Addr: byte; var Value: word): TModbusError;
    //Состояние выхода
    //0 - Проход в направлении выход свободен
    //Не 0 – позиция(наличие) объекта с направления выход
    function GetExitState(Addr: byte; var Value: word): TModbusError;
    //Время необходимое для прохода после разрешения, секунд
    function GetAfterPermissionPassTime(Addr: byte; var Value: word): TModbusError;
    //Время необходимое после начала прохода, секунд
    function GetAfterStartPassTime(Addr: byte; var Value: word): TModbusError;
    //Таймаут работы двигателя, секунд
    function GetEngineTime(Addr: byte; var Value: word): TModbusError;

    //Разрешение накопления проходов
    //0 – Накопление проходов запрещено
    //1 - Накопление проходов разрешено
    function SetAccumulPas(Addr: byte; State: byte): TModbusError;
    //0 - Установить нормальный режим
    //1 - Установить режим Блокировки
    //2 - Установить режим Антипаники
    function SetPassState(Addr: byte; State: byte): TModbusError;
    //скорость обмена между контроллером турникета и контроллером верхнего уровня  деленная на 100
    function SetControllerSpeed(Addr: byte; Value: longword): TModbusError;
    //скорость обмена между контроллером турникета и сканером деленная на 100
    function SetScannerSpeed(Addr: byte; Value: word): TModbusError;
    //0	– проход закрыт;
    //(1-$FFFЕ) – количество разрешенных проходов
    //$FFFF – разрешен свободный проход
    function SetEnter(Addr: byte; State: word): TModbusError;
    //0	– проход закрыт;
    //(1-$FFFЕ) – количество разрешенных проходов
    //$FFFF – разрешен свободный проход
    function SetExit(Addr: byte; State: word): TModbusError;
    //Время необходимое для прохода после разрешения, секунд
    function SetAfterPermissionPassTime(Addr: byte; State: byte): TModbusError;
    //Время необходимое после начала прохода, секунд
    function SetAfterStartPassTime(Addr: byte; State: byte): TModbusError;
    //Таймаут работы двигателя, секунд
    function SetEngineTime(Addr: byte; State: byte): TModbusError;

    //Зеленый Вход: длительность включения сигнала, в 100 мс интервалах (t)
    //длительность выключения сигнала, в 100 мс интервалах (T)
    //Общая длительность цикла индикации, в 100 мс интервалах (time)
    //Значение 0xFFFF – Соответствуют бесконечному времени.
    function SetEnterGreen(Addr: byte; OnTime, OffTime, LengthTime: word): TModbusError;
    //Красный Вход: длительность включения сигнала, в 100 мс интервалах (t)
    //длительность выключения сигнала, в 100 мс интервалах (T)
    //Общая длительность цикла индикации, в 100 мс интервалах (time)
    //Значение 0xFFFF – Соответствуют бесконечному времени.
    function SetEnterRed(Addr: byte; OnTime, OffTime, LengthTime: word): TModbusError;
    //Зеленый Выход: длительность включения сигнала, в 100 мс интервалах (t)
    //длительность выключения сигнала, в 100 мс интервалах (T)
    //Общая длительность цикла индикации, в 100 мс интервалах (time)
    //Значение 0xFFFF – Соответствуют бесконечному времени.
    function SetExitGreen(Addr: byte; OnTime, OffTime, LengthTime: word): TModbusError;
    //Красный Выход: длительность включения сигнала, в 100 мс интервалах (t)
    //длительность выключения сигнала, в 100 мс интервалах (T)
    //Общая длительность цикла индикации, в 100 мс интервалах (time)
    //Значение 0xFFFF – Соответствуют бесконечному времени.
    function SetExitRed(Addr: byte; OnTime, OffTime, LengthTime: word): TModbusError;

    function GetDemo(Addr: byte; var State: word): TModbusError;
    function SetDemo(Addr: byte; State: byte): TModbusError;

    //ЖКИ индикатор-----------------------------------------------------
    //Вывод 32 символа сообщения
    function SetMessage(Addr: byte; AMessage: ansistring): TModbusError;
    //Мигание символами сообщения
    function SetBlink(Addr: byte; value: longword): TModbusError;
    function SetAddress(Addr: byte; NewAddr: byte): TModbusError;
  end;

implementation

function TController.GetErrorState(Addr: byte; var Value: word): TModbusError;
begin
  result := ReadData(addr, $48, value);
end;

function TController.GetAfterPermissionPassTime(Addr: byte;
  var Value: word): TModbusError;
begin
  result := ReadData(addr, $3011, value);
end;

function TController.GetAfterStartPassTime(Addr: byte; var Value: word): TModbusError;
begin
  result := ReadData(addr, $3012, value);
end;

function TController.GetDemo(Addr:byte; var State: word): TModbusError;
begin
  result := ReadData(addr, $666, state);
end;

function TController.GetEngineTime(Addr: byte; var Value: word): TModbusError;
begin
  result := ReadData(addr, $48, value);
end;

function TController.GetEnter(Addr: byte; var Value: word): TModbusError;
begin
  result := ReadData(addr, $40, value);
end;

function TController.GetEnterCard(Addr: byte; var IsNew: boolean;
  var CardNum: TAr; var Count: word): TModbusError;
var
  s: ansistring;
  OldRM: TRoundingMode;
begin
  OldRM := GetRoundMode;
  try
    FillChar(CardNum, SizeOf(CardNum), #0);
    result := ReadData(addr, $100, count);
    IsNew := Boolean(hi(count));
    count := lo(count);

    if (count <> 0) and IsNew then
    begin
      SetRoundMode(rmUp);
      result := ReadData(addr, $101, s, round(count / 2));
      if result = merNone then
      begin
        if (count = 15)  and (Byte(s[14]) = $0D) and (Byte(s[15]) = $0A) then
          count := count - 2; // -$0D$0A
        move(s[1], CardNum[0], count);
      end;
    end
  finally
    SetRoundMode(OldRM);
  end;
end;

function TController.GetEnterCount(Addr: byte; var Value: longword): TModbusError;
var
  n: word;
begin
  ReadData(addr, $45, n);
  value := n;
  result := ReadData(addr, $44, n);
  value := value shl 16 + n;
end;

function TController.GetEnterState(Addr: byte; var Value: word): TModbusError;
begin
  result := ReadData(addr, $42, value);
end;

function TController.GetExit(Addr: byte; var Value: word): TModbusError;
begin
  result := ReadData(addr, $41, value);
end;

function TController.GetExitCard(Addr: byte; var IsNew: boolean;
  var CardNum: TAr; var Count: word): TModbusError;
var
  s: ansistring;
  OldRM: TRoundingMode;
begin
  OldRM := GetRoundMode;
  try
    FillChar(CardNum, SizeOf(CardNum), #0);
    result := ReadData(addr, $200, count);
    IsNew := Boolean(hi(count));
    count := lo(count);

    if (count <> 0) and IsNew then
    begin
      SetRoundMode(rmUp);
      result := ReadData(addr, $201, s, round(count / 2));
      if result = merNone then
      begin
        if (count = 15)  and (Byte(s[14]) = $0D) and (Byte(s[15]) = $0A) then
          count := count - 2; // -$0D$0A
        move(s[1], CardNum[0], count);
      end;
    end
  finally
    SetRoundMode(OldRM);
  end;
end;

function TController.GetExitCount(Addr: byte; var Value: longword): TModbusError;
var
  n: word;
begin
  ReadData(addr, $47, n);
  value := n;
  result := ReadData(addr, $46, n);
  value := value shl 16 + n;
end;

function TController.GetExitState(Addr: byte; var Value: word): TModbusError;
begin
  result := ReadData(addr, $43, value);
end;

function TController.GetPassState(Addr: byte; var Value: word): TModbusError;
begin
  result := ReadData(addr, $3000, value);
end;

function TController.ReadData(Addr: byte; RegAddr: word; var Ans: ansistring; Count: byte = 1): TModbusError;
var
  param: TAddrQtyRec;
  output: TResultRec;
begin
  ans := '';
  param.Addr := RegAddr;
  param.Qty := Count;

  Result := FModbus.ReadHoldingRegisters(Addr, param, output);

  if Result = merNone then
  begin
    if output.Qty <> 0 then
    begin
      SetLength(ans, output.Qty);
      move(output.data[1], ans[1], output.Qty);
    end;
  end;
end;

function TController.ReadData(Addr: byte; RegAddr: word; var Ans: word): TModbusError;
var
  param: TAddrQtyRec;
  output: TResultRec;
begin
  ans := 0;
  param.Addr := RegAddr;
  param.Qty := 1;
  FillChar(output.data, SizeOf(output.data), #0);

  Result := FModbus.ReadHoldingRegisters(Addr, param, output);

  if Result = merNone then
  begin
    if output.Qty <> 0 then
      ans := output.data[1] shl 8 + output.data[2];
  end;
end;

function TController.SetControllerSpeed(Addr: byte; Value: longword): TModbusError;
var
  speed, speed2: longint;
begin
  speed := trunc(value / 100);
  speed2 := not speed;
//  result := WriteState(addr, $4310 , [speed, speed2]); //Турникет

  result := WriteState(addr, $4310 , [speed]);  //Индикатор
  result := WriteState(addr, $4312 , [speed2]);
end;

function TController.SetDemo(Addr, State: byte): TModbusError;
begin
  result := WriteState(addr, $666, [state]);
end;

function TController.SetEngineTime(Addr, State: byte): TModbusError;
begin
  result := WriteState(addr, $48, [state]);
end;

function TController.SetEnter(Addr: byte; State: word): TModbusError;
begin
  result := WriteState(addr, $40, [state]);
end;

function TController.SetEnterGreen(Addr: byte; OnTime, OffTime,
  LengthTime: word): TModbusError;
begin
  result := WriteState(addr, $1000, [OnTime, OffTime, LengthTime]);
end;

function TController.SetEnterRed(Addr: byte; OnTime, OffTime,
  LengthTime: word): TModbusError;
begin
  result := WriteState(addr, $1003, [OnTime, OffTime, LengthTime]);
end;

function TController.SetExit(Addr:byte; State: word): TModbusError;
begin
  result := WriteState(addr, $41, [state]);
end;

function TController.SetExitGreen(Addr: byte; OnTime, OffTime,
  LengthTime: word): TModbusError;
begin
  result := WriteState(addr, $1008, [OnTime, OffTime, LengthTime]);
end;

function TController.SetExitRed(Addr: byte; OnTime, OffTime,
  LengthTime: word): TModbusError;
begin
  result := WriteState(addr, $1009, [OnTime, OffTime, LengthTime]);
end;

function TController.SetMessage(Addr: byte; AMessage: ansistring): TModbusError;
var
  t: array[0..15] of word;
  i, j: byte;
begin
  FillChar(t, SizeOf(t), #0);
  i := 1;
  j := 0;
  while i <= length(AMessage) do
  begin
    t[j]:= ord(AMessage[i]);
    t[j] := t[j] shl 8 + ord(AMessage[i + 1]);
    i := i + 2;
    inc(j);
  end;
//  move(AMessage[1], t[0], length(AMessage));
  result := WriteState(addr, $40, t);
end;

function TController.SetAccumulPas(Addr, State: byte): TModbusError;
begin
  result := WriteState(addr, $3010, [state]);
end;

function TController.SetAddress(Addr, NewAddr: byte): TModbusError;
var
  t: word;
begin
  t := NewAddr;
  result := WriteState(addr, $4320, [t]);
  t := not t;
  result := WriteState(addr, $4322, [t]);
end;

function TController.SetAfterPermissionPassTime(Addr,
  State: byte): TModbusError;
begin
  result := WriteState(addr, $3011, [state]);
end;

function TController.SetAfterStartPassTime(Addr, State: byte): TModbusError;
begin
  result := WriteState(addr, $3012, [state]);
end;

function TController.SetBlink(Addr: byte; value: longword): TModbusError;
begin
  result := WriteState(addr, $50, [LongRec(value).Words[0], LongRec(value).Words[1]]);
end;

function TController.SetPassState(Addr, State: byte): TModbusError;
begin
  result := WriteState(addr, $3000, [state]);
end;

function TController.SetScannerSpeed(Addr: byte; Value: word): TModbusError;
var
  speed: word;
begin
  speed := trunc(value / 100);
  result := WriteState(addr, $4350, [speed]);
end;

function TController.WriteState(Addr: byte; RegAddr: word;
  Value: array of word): TModbusError;
var
  arec: TRegDataRec;
  i, j: byte;
begin
  arec.Addr := RegAddr;

  arec.Qty := length(value);
  j := 1;
  for i := 0 to length(value) - 1 do
  begin
    arec.data[j] := hi(value[i]);
    arec.data[j + 1] := lo(value[i]);
    j := j + 2;
  end;

  Result := FModbus.WriteMultipleRegisters(Addr, arec);
end;

end.
