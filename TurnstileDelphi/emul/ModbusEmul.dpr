program ModbusEmul;

uses
  Forms,
  uMain in 'uMain.pas' {fmMain},
  uTurnDef in 'uTurnDef.pas',
  uProtocol in 'uProtocol.pas',
  uTurnFrame in 'uTurnFrame.pas' {frTurn: TFrame},
  uModbusProtocol in 'uModbusProtocol.pas',
  uCommonDevice in '..\..\source\uCommonDevice.pas',
  uModbus in '..\..\source\uModbus.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
