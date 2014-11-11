unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  uController, uModbus;

type
  TForm1 = class(TForm)
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
    rgEnterPassState: TRadioGroup;
    rgExitPassState: TRadioGroup;
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
  private
    FController: TController;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnAfterPermissionPassTimeClick(Sender: TObject);
begin
  if FController = nil then exit;
  if FController.SetAfterPermissionPassTime(StrToInt(edAddr.Text), StrToInt(edAfterPermissionPassTime.Text)) = merNone then
    MessageDlg('Установлено', mtInformation, [mbOk], 0);
end;

procedure TForm1.btnAfterStartPassTimeClick(Sender: TObject);
begin
  if FController = nil then exit;
  if FController.SetAfterStartPassTime(StrToInt(edAddr.Text), StrToInt(edAfterStartPassTime.Text)) = merNone then
    MessageDlg('Установлено', mtInformation, [mbOk], 0);
end;

procedure TForm1.btnEngineTimeClick(Sender: TObject);
begin
  if FController = nil then exit;
  if FController.SetEngineTime(StrToInt(edAddr.Text), StrToInt(edEngineTime.Text)) = merNone then
    MessageDlg('Установлено', mtInformation, [mbOk], 0);
end;

procedure TForm1.btnEnterGreenClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetEnterGreen_t(StrToInt(edAddr.Text), StrToInt(edEnterGreen_t.Text));
  FController.SetEnterGreen_t2(StrToInt(edAddr.Text), StrToInt(edEnterGreen_t2.Text));
  FController.SetEnterGreen_time(StrToInt(edAddr.Text), StrToInt(edEnterGreen_time.Text));
end;

procedure TForm1.btnEnterPassClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetEnter(StrToInt(edAddr.Text), 1);
end;

procedure TForm1.btnEnterRedClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetEnterRed_t(StrToInt(edAddr.Text), StrToInt(edEnterRed_t.Text));
  FController.SetEnterRed_t2(StrToInt(edAddr.Text), StrToInt(edEnterRed_t2.Text));
  FController.SetEnterRed_time(StrToInt(edAddr.Text), StrToInt(edEnterRed_time.Text));
end;

procedure TForm1.btnExitGreenClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetExitGreen_t(StrToInt(edAddr.Text), StrToInt(edExitGreen_t.Text));
  FController.SetExitGreen_t2(StrToInt(edAddr.Text), StrToInt(edExitGreen_t2.Text));
  FController.SetExitGreen_time(StrToInt(edAddr.Text), StrToInt(edExitGreen_time.Text));
end;

procedure TForm1.btnExitPassClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetExit(StrToInt(edAddr.Text), 1);
end;

procedure TForm1.btnExitRedClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetExitRed_t(StrToInt(edAddr.Text), StrToInt(edExitRed_t.Text));
  FController.SetExitRed_t2(StrToInt(edAddr.Text), StrToInt(edExitRed_t2.Text));
  FController.SetExitRed_time(StrToInt(edAddr.Text), StrToInt(edExitRed_time.Text));
end;

procedure TForm1.btnSetSpeedClick(Sender: TObject);
begin
  if FController = nil then exit;
  if MessageDlg('Требуется перезагрузка контроллера', mtWarning, [mbOk, mbCancel], 0) = mrOk then
     FController.SetControllerSpeed(StrToInt(edAddr.Text), 115200);
end;

procedure TForm1.btnStartClick(Sender: TObject);
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
      btnStart.Caption := 'Отключиться';
      Timer1.Enabled := true;
    end;
  end;
end;

procedure TForm1.rgEnterClick(Sender: TObject);
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

procedure TForm1.rgExitClick(Sender: TObject);
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

procedure TForm1.rgPassStateClick(Sender: TObject);
begin
  if FController = nil then exit;
  FController.SetPassState(StrToInt(edAddr.Text), rgPassState.ItemIndex);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  n: word;
  ln: longword;
  IsNew: boolean;
  Card: Tar;
  i: byte;
  count: word;
begin
  if FController = nil then exit;
  FController.GetEnter(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgEnterState.ItemIndex := 0
  else if n = $FFFF then
    rgEnterState.ItemIndex := 1;
  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetExit(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgExitState.ItemIndex := 0
  else if n = $FFFF then
    rgExitState.ItemIndex := 1;
  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetExitState(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgExitPassState.ItemIndex := 0
  else
    rgExitPassState.ItemIndex := 1;
  Application.ProcessMessages;

  if FController = nil then exit;
  FController.GetEnterState(StrToInt(edAddr.Text), n);
  if n = 0 then
    rgEnterPassState.ItemIndex := 0
  else
    rgEnterPassState.ItemIndex := 1;
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

  edCard.Text := '';
  edCard2.Text := '';
  edCardASCII.Text := '';
  edCard2ASCII.Text := '';

  if FController = nil then exit;
  FController.GetEnterCard(StrToInt(edAddr.Text), IsNew, Card, count);
  if count > 0 then
  begin
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
  if count > 0 then
  begin
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
end;

end.
