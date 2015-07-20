program Demo;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fmMain},
  uController in '..\source\uController.pas',
  uModbus in '..\source\uModbus.pas',
  uCommonDevice in '..\source\uCommonDevice.pas',
  uControllerThread in 'uControllerThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
