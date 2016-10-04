program Modbus;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fmMain},
  uController in 'uController.pas',
  uModbus in 'uModbus.pas',
  uCommonDevice in 'uCommonDevice.pas',
  uControllerThread in 'uControllerThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
