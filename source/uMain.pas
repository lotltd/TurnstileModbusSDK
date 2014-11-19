unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  uController, uModbus;

type
  TfmMain = class(TForm)
    edEnterCount: TEdit;
    edExitCount: TEdit;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Timer1: TTimer;
    GroupBox5: TGroupBox;
    Label9: TLabel;
    cbEngineBlockState: TCheckBox;
    GroupBox7: TGroupBox;
    GroupBox4: TGroupBox;
    edAddr: TEdit;
    UpDown1: TUpDown;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cbPort: TComboBox;
    cbSpeed: TComboBox;
    btnStart: TBitBtn;
    Label10: TLabel;
    edCard: TEdit;
    edCard2: TEdit;
    Label11: TLabel;
    btnSetSpeed: TBitBtn;
    Label12: TLabel;
    Label13: TLabel;
    edAfterPermissionPassTime: TEdit;
    UpDown2: TUpDown;
    edAfterStartPassTime: TEdit;
    UpDown3: TUpDown;
    btnAfterPermissionPassTime: TSpeedButton;
    btnAfterStartPassTime: TSpeedButton;
    Label16: TLabel;
    edEngineTime: TEdit;
    UpDown6: TUpDown;
    btnEngineTime: TSpeedButton;
    GroupBox6: TGroupBox;
    rgEnter: TRadioGroup;
    GroupBox8: TGroupBox;
    rgExit: TRadioGroup;
    GroupBox9: TGroupBox;
    rgExitState: TRadioGroup;
    GroupBox10: TGroupBox;
    rgEnterState: TRadioGroup;
    rgExitPassState: TRadioGroup;
    rgEnterPassState: TRadioGroup;
    rgPassState: TRadioGroup;
    GroupBox11: TGroupBox;
    Label3: TLabel;
    edEnterGreen_t: TEdit;
    UpDown4: TUpDown;
    Label4: TLabel;
    edEnterGreen_t2: TEdit;
    UpDown5: TUpDown;
    Label7: TLabel;
    edEnterGreen_time: TEdit;
    UpDown7: TUpDown;
    GroupBox12: TGroupBox;
    Label8: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edEnterRed_t: TEdit;
    UpDown8: TUpDown;
    edEnterRed_t2: TEdit;
    UpDown9: TUpDown;
    edEnterRed_time: TEdit;
    UpDown10: TUpDown;
    btnEnterGreen: TSpeedButton;
    btnEnterRed: TSpeedButton;
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
    btnEnterPass: TBitBtn;
    btnExitPass: TBitBtn;
    edCardASCII: TEdit;
    Label23: TLabel;
    edCard2ASCII: TEdit;
    Label24: TLabel;
    GroupBox15: TGroupBox;
    Label25: TLabel;
    cbScannerSpeed: TComboBox;
    btnSepScannerSpeed: TBitBtn;
    GroupBox16: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    edCompany: TEdit;
    edProduct: TEdit;
    edVer: TEdit;
    procedure btnStartClick(Sender: TObject);
    procedure rgEnterClick(Sender: TObject);
    procedure rgExitClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
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
    procedure edCompanyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edProductMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FController: TController;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnAfterPermissionPassTimeClick(Sender: TObject);
begin
  if FController = nil then exit;
  if FController.SetAfterPermissionPassTime(StrToInt(edAddr.Text), StrToInt(edAfterPermissionPassTime.Text)) = merNone then
    MessageDlg('Установлено', mtInformation, [mbOk], 0);
end;

procedure TfmMain.btnAfterStartPassTimeClick(Sender: TObject);
begin
  if FController = nil then exit;
  if FController.SetAfterStartPassTime(StrToInt(edAddr.Text), StrToInt(edAfterStartPassTime.Text)) = merNone then
    MessageDlg('Установлено', mtInformation, [mbOk], 0);
end;

procedure TfmMain.btnEngineTimeClick(Sender: TObject);
begin
  if FController = nil then exit;
  if FController.SetEngineTime(StrToInt(edAddr.Text), StrToInt(edEngineTime.Text)) = merNone then
    MessageDlg('Установлено', mtInformation, [mbOk], 0);
end;

procedure TfmMain.btnEnterGreenClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetEnterGreen(StrToInt(edAddr.Text), StrToInt(edEnterGreen_t.Text),
    StrToInt(edEnterGreen_t2.Text), StrToInt(edEnterGreen_time.Text))
end;

procedure TfmMain.btnEnterPassClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetEnter(StrToInt(edAddr.Text), 1);
end;

procedure TfmMain.btnEnterRedClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetEnterRed(StrToInt(edAddr.Text), StrToInt(edEnterRed_t.Text),
    StrToInt(edEnterRed_t2.Text), StrToInt(edEnterRed_time.Text))
end;

procedure TfmMain.btnExitGreenClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetExitGreen(StrToInt(edAddr.Text), StrToInt(edExitGreen_t.Text),
    StrToInt(edExitGreen_t2.Text), StrToInt(edExitGreen_time.Text))
end;

procedure TfmMain.btnExitPassClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetExit(StrToInt(edAddr.Text), 1);
end;

procedure TfmMain.btnExitRedClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetExitRed(StrToInt(edAddr.Text), StrToInt(edExitRed_t.Text),
    StrToInt(edExitRed_t2.Text), StrToInt(edExitRed_time.Text))
end;

procedure TfmMain.btnSepScannerSpeedClick(Sender: TObject);
var
  Error: TModbusError;
begin
  if FController = nil then exit;
  error := FController.SetScannerSpeed(StrToInt(edAddr.Text), StrToInt(cbScannerSpeed.Text));
  if error = merNone then
    MessageDlg('Требуется перезагрузка контроллера', mtWarning, [mbOk], 0)
  else
    MessageDlg(StrModbusError[error], mtError, [mbOk], 0);
end;

procedure TfmMain.btnSetSpeedClick(Sender: TObject);
var
  Error: TModbusError;
begin
  if FController = nil then exit;
  error :=  FController.SetControllerSpeed(StrToInt(edAddr.Text), StrToInt(cbSpeed.Text));
  if error = merNone then
    MessageDlg('Требуется перезагрузка контроллера', mtWarning, [mbOk], 0)
  else
    MessageDlg(StrModbusError[error], mtError, [mbOk], 0);
end;

procedure TfmMain.btnStartClick(Sender: TObject);
var
  Error: TModbusError;
begin
  if FController <> nil then
  begin
    Timer1.Enabled := false;
    FController.Close;
    btnStart.Caption := 'Подключиться';
    FController := nil;
  end
  else
  begin
    FController := TController.Create;
    error := FController.Open(cbPort.ItemIndex + 1, StrToInt(cbSpeed.Text), StrToInt(edAddr.Text));
    if error <> merNone then
    begin
      FController := nil;
      MessageDlg(StrModbusError[error], mtError, [mbOk], 0);
    end
    else
    begin
      edCompany.Text := FController.DeviceInfo.Company;
      edProduct.Text := FController.DeviceInfo.Product;
      edVer.Text := FController.DeviceInfo.Version;
      btnStart.Caption := 'Отключиться';
      Timer1.Enabled := true;
    end;
  end;
end;

procedure TfmMain.edCompanyMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FController = nil then exit;
  if Button = mbRight then
    FController.SetDemo(StrToInt(edAddr.Text), 0);
end;

procedure TfmMain.edProductMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FController = nil then exit;
  if Button = mbRight then
    FController.SetDemo(StrToInt(edAddr.Text), 1);
end;

procedure TfmMain.rgEnterClick(Sender: TObject);
var
  n: word;
begin
  if FController = nil then exit;
  case rgEnter.ItemIndex of
    0: FController.SetEnter(StrToInt(edAddr.Text), 0);
//    1:
//      begin
//        FController.SetAccumulPas(StrToInt(edAddr.Text), 1);
//        FController.SetEnter(StrToInt(edAddr.Text), StrToIntDef(edEnterPassCount.Text, 1));
//      end;
    1: FController.SetEnter(StrToInt(edAddr.Text), $FFFF);
  end;

  FController.GetEnterState(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgEnterState.ItemIndex := 0
  else if n = $FFFF then
    rgEnterState.ItemIndex := 1;
end;

procedure TfmMain.rgExitClick(Sender: TObject);
var
  n: word;
begin
  if FController = nil then exit;
  case rgExit.ItemIndex of
    0: FController.SetExit(StrToInt(edAddr.Text), 0);
//    1:
//      begin
//        FController.SetAccumulPas(StrToInt(edAddr.Text), 1);
//        FController.SetEnter(StrToInt(edAddr.Text), StrToIntDef(edEnterPassCount.Text, 1));
//      end;
    1: FController.SetExit(StrToInt(edAddr.Text), $FFFF);
  end;

  FController.GetExit(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgExitState.ItemIndex := 0
  else if n = $FFFF then
    rgExitState.ItemIndex := 1;
end;

procedure TfmMain.rgPassStateClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetPassState(StrToInt(edAddr.Text), rgPassState.ItemIndex);
end;

procedure TfmMain.Timer1Timer(Sender: TObject);
var
  n: word;
  ln: longword;
  IsNew: boolean;
  Card: Tar;
  i: byte;
  count: word;
  error: TModbusError;
begin
  if FController = nil then exit;
  error := FController.GetEnter(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgEnterState.ItemIndex := 0
  else if n = $FFFF then
    rgEnterState.ItemIndex := 2
  else
    rgEnterState.ItemIndex := 1;

  if error <> merNone then
   btnStart.OnClick(Sender);

  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetExit(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgExitState.ItemIndex := 0
  else if n = $FFFF then
    rgExitState.ItemIndex := 2
  else
    rgExitState.ItemIndex := 1;
  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetEnterState(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgEnterPassState.ItemIndex := 0
  else
    rgEnterPassState.ItemIndex := 1;
  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetExitState(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgExitPassState.ItemIndex := 0
  else
    rgExitPassState.ItemIndex := 1;
  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetEnterCount(StrToInt(edAddr.Text), ln);
  edEnterCount.Text := IntToStr(ln);
  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetExitCount(StrToInt(edAddr.Text), ln);
  edExitCount.Text := IntToStr(ln);
  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetErrorState(StrToInt(edAddr.Text), n);
  cbEngineBlockState.Checked := Boolean(n);
  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetEnterCard(StrToInt(edAddr.Text), IsNew, Card, count);
  if IsNew then
  begin
    edCard.Text := '';
    edCardASCII.Text := '';
    for i := 0 to count - 1 do
    begin
      try
        edCardASCII.Text := edCardASCII.Text + chr(Card[i]) + ' ';
        edCard.Text := edCard.Text + '$' + IntToHex(Card[i], 2) + ' ';
      except
      end;
    end;
    edCard.Text := trim(edCard.Text);
  end;

  if FController = nil then exit;
  FController.GetExitCard(StrToInt(edAddr.Text), IsNew, Card, count);
  if IsNew then
  begin
    edCard2.Text := '';
    edCard2ASCII.Text := '';
    for i := 0 to count - 1 do
    begin
      try
        edCard2ASCII.Text := edCard2ASCII.Text + chr(Card[i]) + ' ';
        edCard2.Text := edCard2.Text + '$' + IntToHex(Card[i], 2) + ' ';
      except
      end;
    end;
    edCard2.Text := trim(edCard2.Text);
  end;

  if FController = nil then exit;
  FController.GetDemo(StrToInt(edAddr.Text), n);
  if n = 0 then
    fmMain.Caption := 'Modbus demo'
  else
    fmMain.Caption := 'Modbus demo *';

  Application.ProcessMessages;

end;

end.
