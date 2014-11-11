unit uController;

interface

uses
  SysUtils, uCommonDevice, uModbus;

type
  TAr = array[0..59] of byte;

  TController = class(TCommonModbusDevice)
  private
    function ReadData(Addr: byte; RegAddr: word; var Ans: word): TModbusError; overload;
    function ReadData(Addr: byte; RegAddr: word; var Ans: ansistring): TModbusError; overload;
    function WriteState(Addr: byte; RegAddr: word; Value: word; Value2: word = 0): TModbusError;
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
    function SetEnterGreen_t(Addr: byte; Value: word): TModbusError;
    //Зеленый Вход: длительность выключения сигнала, в 100 мс интервалах (T)
    function SetEnterGreen_t2(Addr: byte; Value: word): TModbusError;
    //Зеленый Вход: Общая длительность цикла индикации, в 100 мс интервалах (time)
    //Значение 0xFFFF – Соответствуют бесконечному времени.
    function SetEnterGreen_time(Addr: byte; Value: word): TModbusError;
    //Красный Вход: длительность включения сигнала, в 100 мс интервалах (t)
    function SetEnterRed_t(Addr: byte; Value: word): TModbusError;
    //Красный Вход: длительность выключения сигнала, в 100 мс интервалах (T)
    function SetEnterRed_t2(Addr: byte; Value: word): TModbusError;
    //Красный Вход: Общая длительность цикла индикации, в 100 мс интервалах (time)
    //Значение 0xFFFF – Соответствуют бесконечному времени.
    function SetEnterRed_time(Addr: byte; Value: word): TModbusError;

    //Зеленый Выход: длительность включения сигнала, в 100 мс интервалах (t)
    function SetExitGreen_t(Addr: byte; Value: word): TModbusError;
    //Зеленый Выход: длительность выключения сигнала, в 100 мс интервалах (T)
    function SetExitGreen_t2(Addr: byte; Value: word): TModbusError;
    //Зеленый Выход: Общая длительность цикла индикации, в 100 мс интервалах (time)
    //Значение 0xFFFF – Соответствуют бесконечному времени.
    function SetExitGreen_time(Addr: byte; Value: word): TModbusError;
    //Красный Выход: длительность включения сигнала, в 100 мс интервалах (t)
    function SetExitRed_t(Addr: byte; Value: word): TModbusError;
    //Красный Выход: длительность выключения сигнала, в 100 мс интервалах (T)
    function SetExitRed_t2(Addr: byte; Value: word): TModbusError;
    //Красный Выход: Общая длительность цикла индикации, в 100 мс интервалах (time)
    //Значение 0xFFFF – Соответствуют бесконечному времени.
    function SetExitRed_time(Addr: byte; Value: word): TModbusError;
  end;

implementation

function TController.GetErrorState(Addr: byte; var Value: word): TModbusError;
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
begin
  FillChar(CardNum, SizeOf(CardNum), #0);
  result := ReadData(addr, $100, count);
  if count <> 0 then
  begin
    IsNew := Boolean(hi(count));
    count := lo(count);
    result := ReadData(addr, $101, s);
    move(s[1], CardNum[0], count);
  end
end;

function TController.GetEnterCount(Addr: byte; var Value: longword): TModbusError;
var
  n: word;
begin
//  ReadData(addr, $44, n);
//  value := n;
//  result := ReadData(1, $45, n);
//  value := value shl 16 + n;
  ReadData(addr, $45, n);
  value := n;
  result := ReadData(1, $44, n);
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
begin
  FillChar(CardNum, SizeOf(CardNum), #0);
  result := ReadData(addr, $200, count);
  if count <> 0 then
  begin
    IsNew := Boolean(hi(count));
    count := lo(count);
    result := ReadData(addr, $201, s);
    move(s[1], CardNum[0], count);
  end
end;

function TController.GetExitCount(Addr: byte; var Value: longword): TModbusError;
var
  n: word;
begin
//  ReadData(addr, $46, n);
//  value := n;
//  result := ReadData(addr, $47, n);
//  value := value shl 16 + n;
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

function TController.ReadData(Addr: byte; RegAddr: word;
  var Ans: ansistring): TModbusError;
var
  param: TAddrQtyRec;
  output: TResultRec;
begin
  ans := '';
  param.Addr := RegAddr;
  param.Qty := 16;

  Result := FModbus.ReadHoldingRegisters(Addr, param, output);

  if Result = merNone then
  begin
    if output.Qty <> 0 then
    begin
      SetLength(ans, output.Qty);
      move(output.data[1], ans[1], output.Qty);
    end;
  end
  else
    ans := '';
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
  //    ans := output.data[2] shl 8 + output.data[1];
      ans := output.data[1] shl 8 + output.data[2];
  end
  else
    ans := 0;
end;

function TController.SetControllerSpeed(Addr: byte; Value: longword): TModbusError;
var
  speed, speed2: longint;
begin
  speed := trunc(value / 100);
  speed2 := not speed;
  result := WriteState(addr, $4310 , speed, speed2);
end;

function TController.SetEngineTime(Addr, State: byte): TModbusError;
begin
  result := WriteState(addr, $48, state);
end;

function TController.SetEnter(Addr: byte; State: word): TModbusError;
begin
  result := WriteState(addr, $40, state);
end;

function TController.SetEnterGreen_t(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1000, value);
end;

function TController.SetEnterGreen_t2(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1001, value);
end;

function TController.SetEnterGreen_time(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1002, value);
end;

function TController.SetEnterRed_t(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1003, value);
end;

function TController.SetEnterRed_t2(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1004, value);
end;

function TController.SetEnterRed_time(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1005, value);
end;

function TController.SetExit(Addr:byte; State: word): TModbusError;
begin
  result := WriteState(addr, $41, state);
end;

function TController.SetExitGreen_t(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1006, value);
end;

function TController.SetExitGreen_t2(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1007, value);
end;

function TController.SetExitGreen_time(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1008, value);
end;

function TController.SetExitRed_t(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $1009, value);
end;

function TController.SetExitRed_t2(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $100A, value);
end;

function TController.SetExitRed_time(Addr: byte; Value: word): TModbusError;
begin
  result := WriteState(addr, $100B, value);
end;

function TController.SetAccumulPas(Addr, State: byte): TModbusError;
begin
  result := WriteState(addr, $3010, state);
end;

function TController.SetAfterPermissionPassTime(Addr,
  State: byte): TModbusError;
begin
  result := WriteState(addr, $3011, state);
end;

function TController.SetAfterStartPassTime(Addr, State: byte): TModbusError;
begin
  result := WriteState(addr, $3012, state);
end;

function TController.SetPassState(Addr, State: byte): TModbusError;
begin
  result := WriteState(addr, $3000, state);
end;

function TController.SetScannerSpeed(Addr: byte; Value: word): TModbusError;
var
  speed: word;
begin
  speed := trunc(value / 100);
  result := WriteState(addr, $4350, speed);
end;

function TController.WriteState(Addr: byte; RegAddr: word; Value: word; Value2: word = 0): TModbusError;
var
  arec: TRegDataRec;
begin
  arec.Addr := RegAddr;
//  arec.Qty := 1;
//  arec.data[1] := 0;
//  arec.data[2] := value
  if Value2 = 0 then
  begin
    arec.Qty := 1;
    arec.data[1] := hi(value);
    arec.data[2] := lo(value);
  end
  else
  begin
    arec.Qty := 2;
    arec.data[1] := hi(value);
    arec.data[2] := lo(value);
    arec.data[3] := hi(value2);
    arec.data[4] := lo(value2);
  end;

  Result := FModbus.WriteMultipleRegisters(Addr, arec);
end;

end.
