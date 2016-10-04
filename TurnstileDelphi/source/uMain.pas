unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  uControllerThread, uModbus, Vcl.Mask, Vcl.CheckLst;

type
  TfmMain = class(TForm)
    GroupBox7: TGroupBox;
    GroupBox4: TGroupBox;
    edAddr: TEdit;
    UpDown1: TUpDown;
    gbCom: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cbPort: TComboBox;
    cbSpeed: TComboBox;
    btnSetSpeed: TBitBtn;
    GroupBox15: TGroupBox;
    Label25: TLabel;
    cbScannerSpeed: TComboBox;
    btnSepScannerSpeed: TBitBtn;
    gbTCP: TGroupBox;
    Label29: TLabel;
    Label30: TLabel;
    edHost: TMaskEdit;
    edTCPPort: TEdit;
    UpDown17: TUpDown;
    rgConnect: TRadioGroup;
    btnStart: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    btnAfterPermissionPassTime: TSpeedButton;
    btnAfterStartPassTime: TSpeedButton;
    Label16: TLabel;
    btnEngineTime: TSpeedButton;
    edAfterPermissionPassTime: TEdit;
    UpDown2: TUpDown;
    edAfterStartPassTime: TEdit;
    UpDown3: TUpDown;
    edEngineTime: TEdit;
    UpDown6: TUpDown;
    GroupBox6: TGroupBox;
    rgEnter: TRadioGroup;
    GroupBox11: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    btnEnterGreen: TSpeedButton;
    edEnterGreen_t: TEdit;
    UpDown4: TUpDown;
    edEnterGreen_t2: TEdit;
    UpDown5: TUpDown;
    edEnterGreen_time: TEdit;
    UpDown7: TUpDown;
    GroupBox12: TGroupBox;
    Label8: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    btnEnterRed: TSpeedButton;
    edEnterRed_t: TEdit;
    UpDown8: TUpDown;
    edEnterRed_t2: TEdit;
    UpDown9: TUpDown;
    edEnterRed_time: TEdit;
    UpDown10: TUpDown;
    btnEnterPass: TBitBtn;
    GroupBox8: TGroupBox;
    rgExit: TRadioGroup;
    GroupBox13: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    btnExitGreen: TSpeedButton;
    edExitGreen_t: TEdit;
    UpDown11: TUpDown;
    edExitGreen_t2: TEdit;
    UpDown12: TUpDown;
    edExitGreen_time: TEdit;
    UpDown13: TUpDown;
    GroupBox14: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    btnExitRed: TSpeedButton;
    edExitRed_t: TEdit;
    UpDown14: TUpDown;
    edExitRed_t2: TEdit;
    UpDown15: TUpDown;
    edExitRed_time: TEdit;
    UpDown16: TUpDown;
    btnExitPass: TBitBtn;
    rgPassState: TRadioGroup;
    cbDemo: TCheckBox;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    edEnterCount: TEdit;
    edExitCount: TEdit;
    GroupBox5: TGroupBox;
    Label9: TLabel;
    cbEngineBlockState: TCheckBox;
    edCard: TEdit;
    edCard2: TEdit;
    GroupBox9: TGroupBox;
    rgExitState: TRadioGroup;
    rgExitPassState: TRadioGroup;
    GroupBox10: TGroupBox;
    rgEnterState: TRadioGroup;
    rgEnterPassState: TRadioGroup;
    edCardASCII: TEdit;
    edCard2ASCII: TEdit;
    Label31: TLabel;
    edMessage: TEdit;
    btnSetMessage: TSpeedButton;
    GroupBox16: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    edCompany: TEdit;
    edProduct: TEdit;
    edVer: TEdit;
    clbBlink: TCheckListBox;
    Label32: TLabel;
    btnBlink: TSpeedButton;
    Label33: TLabel;
    edSetAddr: TEdit;
    UpDown18: TUpDown;
    btnSetAddress: TSpeedButton;
    btnGetTimers: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure rgEnterClick(Sender: TObject);
    procedure rgExitClick(Sender: TObject);
    procedure btnSetSpeedClick(Sender: TObject);
    procedure btnAfterPermissionPassTimeClick(Sender: TObject);
    procedure btnAfterStartPassTimeClick(Sender: TObject);
    procedure btnEngineTimeClick(Sender: TObject);
    procedure rgPassStateClick(Sender: TObject);
    procedure btnEnterGreenClick(Sender: TObject);
    procedure btnEnterRedClick(Sender: TObject);
    procedure btnExitGreenClick(Sender: TObject);
    procedure btnExitRedClick(Sender: TObject);
    procedure btnEnterPassClick(Sender: TObject);
    procedure btnExitPassClick(Sender: TObject);
    procedure btnSepScannerSpeedClick(Sender: TObject);
    procedure cbDemoClick(Sender: TObject);
    procedure rgConnectClick(Sender: TObject);
    procedure btnSetMessageClick(Sender: TObject);
    procedure btnBlinkClick(Sender: TObject);
    procedure btnSetAddressClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure btnGetTimersClick(Sender: TObject);
  private
    FControllerThread: TControllerThread;
    procedure JobError(Error: TModbusError);
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnAfterPermissionPassTimeClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  if FControllerThread.Controller.SetAfterPermissionPassTime(StrToInt(edAddr.Text), StrToInt(edAfterPermissionPassTime.Text)) = merNone then
    MessageDlg('Установлено', mtInformation, [mbOk], 0);
end;

procedure TfmMain.btnAfterStartPassTimeClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  if FControllerThread.Controller.SetAfterStartPassTime(StrToInt(edAddr.Text), StrToInt(edAfterStartPassTime.Text)) = merNone then
    MessageDlg('Установлено', mtInformation, [mbOk], 0);
end;

procedure TfmMain.btnBlinkClick(Sender: TObject);
var
  i: byte;
  t: longword;
begin
  if FControllerThread = nil then exit;
  t := 0;
  for i := 0 to clbBlink.Count - 1 do
    if clbBlink.Checked[i] then
      t := t or (1 shl i);
  FControllerThread.Controller.SetBlink(StrToInt(edAddr.Text), t);
end;

procedure TfmMain.btnEngineTimeClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  if FControllerThread.Controller.SetEngineTime(StrToInt(edAddr.Text), StrToInt(edEngineTime.Text)) = merNone then
    MessageDlg('Установлено', mtInformation, [mbOk], 0);
end;

procedure TfmMain.btnEnterGreenClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  FControllerThread.Controller.SetEnterGreen(StrToInt(edAddr.Text), StrToInt(edEnterGreen_t.Text),
    StrToInt(edEnterGreen_t2.Text), StrToInt(edEnterGreen_time.Text));
end;

procedure TfmMain.btnEnterPassClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  FControllerThread.Controller.SetEnter(StrToInt(edAddr.Text), 1);
end;

procedure TfmMain.btnEnterRedClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  FControllerThread.Controller.SetEnterRed(StrToInt(edAddr.Text), StrToInt(edEnterRed_t.Text),
    StrToInt(edEnterRed_t2.Text), StrToInt(edEnterRed_time.Text));
end;

procedure TfmMain.btnExitGreenClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  FControllerThread.Controller.SetExitGreen(StrToInt(edAddr.Text), StrToInt(edExitGreen_t.Text),
    StrToInt(edExitGreen_t2.Text), StrToInt(edExitGreen_time.Text));
end;

procedure TfmMain.btnExitPassClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  FControllerThread.Controller.SetExit(StrToInt(edAddr.Text), 1);
end;

procedure TfmMain.btnExitRedClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  FControllerThread.Controller.SetExitRed(StrToInt(edAddr.Text), StrToInt(edExitRed_t.Text),
    StrToInt(edExitRed_t2.Text), StrToInt(edExitRed_time.Text));
end;

procedure TfmMain.btnSepScannerSpeedClick(Sender: TObject);
var
  Error: TModbusError;
begin
  error := merNone;
  if FControllerThread = nil then exit;
  FControllerThread.Controller.SetTimeOut(60);
  error := FControllerThread.Controller.SetScannerSpeed(StrToInt(edAddr.Text), StrToInt(cbScannerSpeed.Text));
  FControllerThread.Controller.SetTimeOut(30);
  if error = merNone then
    MessageDlg('Требуется перезагрузка контроллера', mtWarning, [mbOk], 0);
end;

procedure TfmMain.btnSetAddressClick(Sender: TObject);
var
  Error: TModbusError;
begin
  if FControllerThread = nil then exit;
  error := FControllerThread.Controller.SetAddress(StrToInt(edAddr.Text), StrToIntDef(edSetAddr.Text, 1));
  if error = merNone then
    MessageDlg('Требуется перезагрузка контроллера', mtWarning, [mbOk], 0);
end;

procedure TfmMain.btnSetMessageClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  FControllerThread.Controller.SetMessage(StrToInt(edAddr.Text), edMessage.Text);
end;

procedure TfmMain.btnSetSpeedClick(Sender: TObject);
var
  Error: TModbusError;
begin
  if FControllerThread = nil then exit;
  error := FControllerThread.Controller.SetControllerSpeed(StrToInt(edAddr.Text), StrToInt(cbSpeed.Text));
  if error = merNone then
    MessageDlg('Требуется перезагрузка контроллера', mtWarning, [mbOk], 0);
end;

procedure TfmMain.btnStartClick(Sender: TObject);
var
  Error: TModbusError;
  net1, net2, host1, host2: integer;
begin
  if FControllerThread <> nil then
  begin
    FControllerThread.Terminate;
    btnStart.Caption := 'Подключиться';
    FControllerThread := nil;
  end
  else
  begin
    if rgConnect.ItemIndex = 0 then
      FControllerThread := TControllerThread.Create(cbPort.ItemIndex + 1, StrToInt(cbSpeed.Text), StrToInt(edAddr.Text))
    else
    begin
      net1 := StrToInt(TrimRight(Copy(edHost.Text, 0, 3)));
      net2 := StrToInt(TrimRight(Copy(edHost.Text, 5, 3)));
      host1 := StrToInt(TrimRight(Copy(edHost.Text, 9, 3)));
      host2 := StrToInt(TrimRight(Copy(edHost.Text, 13, 3)));
      FControllerThread := TControllerThread.Create(IntToStr(net1) + '.' + IntToStr(net2) + '.' +
        IntToStr(host1) + '.' + IntToStr(host2), StrToInt(edTCPPort.Text), StrToInt(edAddr.Text));
    end;
    FControllerThread.DeviceType := PageControl1.ActivePageIndex;
    FControllerThread.OnJobError := JobError;
    FControllerThread.Start;
    btnStart.Caption := 'Отключиться';
  end;
end;

procedure TfmMain.btnGetTimersClick(Sender: TObject);
var
  value: word;
begin
  if FControllerThread = nil then exit;
  FControllerThread.Controller.GetAfterPermissionPassTime(StrToInt(edAddr.Text), value);
  edAfterPermissionPassTime.Text := IntToStr(value);
  FControllerThread.Controller.GetAfterStartPassTime(StrToInt(edAddr.Text), value);
  edAfterStartPassTime.Text := IntToStr(value);
  FControllerThread.Controller.GetEngineTime(StrToInt(edAddr.Text), value);
  edEngineTime.Text := IntToStr(value);
end;

procedure TfmMain.cbDemoClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  if cbDemo.Checked then
    FControllerThread.Controller.SetDemo(StrToInt(edAddr.Text), 1)
  else
    FControllerThread.Controller.SetDemo(StrToInt(edAddr.Text), 0);
end;

procedure TfmMain.JobError(Error: TModbusError);
begin
  if (error <> merNone) and (error <> merMBDataAddress) then
  begin
    MessageDlg(StrModbusError[error], mtError, [mbOk], 0);
    btnStart.OnClick(self);
  end;
end;

procedure TfmMain.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  if btnStart.Caption = 'Отключиться' then
    AllowChange := false;
end;

procedure TfmMain.rgConnectClick(Sender: TObject);
begin
  gbCom.Enabled := rgConnect.ItemIndex = 0;
  gbTcp.Enabled := rgConnect.ItemIndex = 1;
end;

procedure TfmMain.rgEnterClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  case rgEnter.ItemIndex of
    0: FControllerThread.Controller.SetEnter(StrToInt(edAddr.Text), 0);
//    1:
//      begin
//        FController.SetAccumulPas(StrToInt(edAddr.Text), 1);
//        FController.SetEnter(StrToInt(edAddr.Text), StrToIntDef(edEnterPassCount.Text, 1));
//      end;
    1: FControllerThread.Controller.SetEnter(StrToInt(edAddr.Text), $FFFF);
  end;
end;

procedure TfmMain.rgExitClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  case rgExit.ItemIndex of
    0: FControllerThread.Controller.SetExit(StrToInt(edAddr.Text), 0);
//    1:
//      begin
//        FController.SetAccumulPas(StrToInt(edAddr.Text), 1);
//        FController.SetEnter(StrToInt(edAddr.Text), StrToIntDef(edEnterPassCount.Text, 1));
//      end;
    1: FControllerThread.Controller.SetExit(StrToInt(edAddr.Text), $FFFF);
  end;
end;

procedure TfmMain.rgPassStateClick(Sender: TObject);
begin
  if FControllerThread = nil then exit;
  FControllerThread.Controller.SetPassState(StrToInt(edAddr.Text), rgPassState.ItemIndex);
end;

end.
