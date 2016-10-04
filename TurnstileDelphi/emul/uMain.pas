unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls, uTurnFrame,
  uTurnDef, uProtocol, Vcl.Menus, uModbusProtocol, System.Math, Web.Win.Sockets;

type
  TfmMain = class(TForm)
    pnlMenu: TPanel;
    btnNew: TSpeedButton;
    btnNewTurn: TSpeedButton;
    btnGo: TSpeedButton;
    Label1: TLabel;
    edCom: TEdit;
    UpDown1: TUpDown;
    Splitter1: TSplitter;
    PopupMenu1: TPopupMenu;
    btnLogClear: TMenuItem;
    cbLog: TCheckBox;
    ScrollBox1: TScrollBox;
    FlowPanel1: TFlowPanel;
    Panel1: TPanel;
    mLog: TMemo;
    Splitter2: TSplitter;
    PopupMenu2: TPopupMenu;
    btnAddCode: TMenuItem;
    btnDelCode: TMenuItem;
    GroupBox1: TGroupBox;
    lbCode: TListBox;
    btnGenerator: TBitBtn;
    meGeneratorLog: TMemo;
    Timer1: TTimer;
    TcpServer1: TTcpServer;
    procedure btnCloseClick(Sender: TObject);
    procedure btnNewTurnClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnLogClearClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnAddCodeClick(Sender: TObject);
    procedure btnDelCodeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnGeneratorClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fComm: TProtocol;
    FFrArr: array of TFrame;
    FIsGo: boolean;
    procedure ChangeTurnState(addr: cardinal);
    function ByNumber(addr: byte): TFrame;
    procedure WriteLog(AMessage: ansistring);
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnAddCodeClick(Sender: TObject);
var
  s: string;
begin
  if InputQuery('Добавление кода', '', s) then
    lbCode.Items.Add(s);
end;

procedure TfmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.btnDelCodeClick(Sender: TObject);
begin
  if lbCode.ItemIndex < 0 then
    exit;
  if MessageDlg('Удалить код?', mtWarning, [mbYes, mbNo], 0) = mrYes then
    lbCode.Items.Delete(lbCode.ItemIndex);
end;

procedure TfmMain.btnGeneratorClick(Sender: TObject);
begin
  if (btnGenerator.Caption = 'Старт') and FIsGo and btnGenerator.Enabled then
  begin
    if lbCode.Items.Count < 1 then
    begin
      MessageDlg('Пустой список кодов', mtError, [mbOk], 0);
      exit;
    end;
    btnGenerator.Caption := 'Стоп';
    lbCode.Enabled := false;
    Timer1.Enabled := true;
    Randomize;
  end
  else
  begin
    btnGenerator.Caption := 'Старт';
    lbCode.Enabled := true;
    Timer1.Enabled := false;
  end;
  btnGenerator.Enabled := FIsGo;
end;

procedure TfmMain.btnGoClick(Sender: TObject);
var
  i: byte;
begin
  if FIsGo then
  begin
    fComm.Terminate;
    FIsGo := false;
    btnGo.Caption := 'Старт';
    if Length(FFrArr) > 0 then
      for i := 0 to Length(FFrArr) - 1 do
      begin
        TfrTurn(FFrArr[i]).Timer1.Enabled := false;
        TfrTurn(FFrArr[i]).Timer2.Enabled := false;
      end;
    FIsGo := false;
  end
  else
  begin
    if Length(FFrArr) = 0 then
    begin
      MessageDLg('Нет турникетов', mtError, [mbOk], 0);
      btnGo.Caption := 'Старт';
      FIsGo := false;
      exit;
    end;
    fComm := TModbusProtocol.Create(StrToInt(edCom.Text));
//    fComm := TModbusProtocol.Create('127.0.0.1', 502);
    fComm.OnWriteLog := WriteLog;
    if fComm.CommunicatorState = csConnected then
    begin
      btnGo.Caption := 'Стоп';
      FIsGo := true;
    end
    else
    begin
      fComm.Terminate;
      btnGo.Caption := 'Старт';
      FIsGo := false;
    end;
  end;
  btnGenerator.OnClick(Sender);
end;

procedure TfmMain.btnLogClearClick(Sender: TObject);
begin
  mLog.Lines.Clear;
end;

procedure TfmMain.btnNewClick(Sender: TObject);
var
  i: word;
begin
  if Turnstiles <> nil then
  begin
    Turnstiles.Free;
    if Length(FFrArr) > 0 then
      for i := 0 to Length(FFrArr) - 1 do
        FFrArr[i].Free;
    SetLength(FFrArr, 0);
  end;
  Turnstiles := TTurnstiles.Create;
  btnNewTurn.Enabled := true;
  btnGo.Enabled := false;
end;

procedure TfmMain.btnNewTurnClick(Sender: TObject);
var
  addr: string;
  i: byte;
begin
  addr := IntToStr(Length(ffrarr) + 1);
  if InputQuery('Введите номер турникета', '', addr) then
  begin
    if (StrToInt64Def(addr, 0) <> 0) and (not Turnstiles.IsAddrExists(StrToInt64Def(addr, 0))) then
    begin
      SetLength(ffrarr, Length(ffrarr) + 1);
      i := Length(ffrarr) - 1;
      ffrarr[i] := TfrTurn.Create(fmMain);
      ffrarr[i].Name := 'fr' + addr;
      ffrarr[i].Parent := FlowPanel1;
      (ffrarr[i] as TfrTurn).gb.Caption := addr;
      (ffrarr[i] as TfrTurn).Tag := StrToInt64Def(addr, 0);
      Turnstiles.AddTurn(StrToInt64(addr)).OnChangeState := ChangeTurnState;
      btnGo.Enabled := true;
    end
    else
    begin
      MessageDlg('Неправильный номер турникета', mtError, [mbOk], 0);
      Exit;
    end;
  end;
end;

function TfmMain.ByNumber(addr: byte): TFrame;
var
  i: byte;
begin
  result := nil;
  if Length(FFrArr) = 0 then
    exit;
  for i := 0 to Length(FFrArr) - 1 do
    if (ffrarr[i] as TfrTurn).Tag = addr then
      result := ffrarr[i];
end;

procedure TfmMain.ChangeTurnState(addr: cardinal);
var
  turn: TTurnDef;
  fr: TFrame;
begin
  turn := Turnstiles.ByAddr(addr);
  fr := ByNumber(addr);
  with (fr as TfrTurn) do
  begin
    if turn.EnterState <> 0 then
    begin
      btnIn.Enabled := true;
      btnIn.ImageIndex := 1;
    end
    else
    begin
      btnIn.Enabled := false;
      btnIn.ImageIndex := 0;
    end;
    if turn.ExitState <> 0 then
    begin
      btnOut.Enabled := true;
      btnOut.ImageIndex := 1;
    end
    else
    begin
      btnOut.Enabled := false;
      btnOut.ImageIndex := 0;
    end;

    if (turn.EnterState > 0) and (turn.EnterState < $FFFE) then
      Timer1.Enabled := true;
    if (turn.ExitState > 0) and (turn.ExitState < $FFFE) then
      Timer2.Enabled := true;
  end;

  if turn.EnterState = 0 then
    (fr as TfrTurn).cbStateIn.ItemIndex := 0
  else if turn.EnterState = $FFFF then
    (fr as TfrTurn).cbStateIn.ItemIndex := 2
  else
    (fr as TfrTurn).cbStateIn.ItemIndex := 1;

  if turn.ExitState = 0 then
    (fr as TfrTurn).cbStateOut.ItemIndex := 0
  else if turn.ExitState = $FFFF then
    (fr as TfrTurn).cbStateOut.ItemIndex := 2
  else
    (fr as TfrTurn).cbStateOut.ItemIndex := 1;

  (fr as TfrTurn).cbEmergency.Checked := turn.Emergency;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  lbCode.Items.SaveToFile(ExtractFilePath(Application.Exename) + 'Codes.txt');
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FIsGo := false;
end;

procedure TfmMain.FormResize(Sender: TObject);
var
  i, h: integer;
begin
  h := 0;
  for i := 0 to FlowPanel1.ControlCount - 1 do
    h := Max(FlowPanel1.Controls[i].BoundsRect.Bottom, h);
  ScrollBox1.VertScrollBar.Range := h;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  try
    lbCode.Items.LoadFromFile(ExtractFilePath(Application.Exename) + 'Codes.txt');
  except
  end;
end;

procedure TfmMain.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  if not FIsGo then
  begin
    Timer1.Enabled := false;
    exit;
  end;
  i := Random(Length(FFrArr));
  if Random(100) < 50 then
  begin
    TfrTurn(FFrArr[i]).edCardExit.Text := lbCode.Items[Random(lbCode.Items.Count)];
    TfrTurn(FFrArr[i]).btnCardExit.OnClick(Sender);
    meGeneratorLog.Lines.Add(IntToStr(TfrTurn(FFrArr[i]).Tag) + ' Выход: ' + TfrTurn(FFrArr[i]).edCardExit.Text);
  end
  else
  begin
    TfrTurn(FFrArr[i]).edCardEnter.Text := lbCode.Items[Random(lbCode.Items.Count)];
    TfrTurn(FFrArr[i]).btnCardEnter.OnClick(Sender);
    meGeneratorLog.Lines.Add(IntToStr(TfrTurn(FFrArr[i]).Tag) + ' Вход: ' + TfrTurn(FFrArr[i]).edCardExit.Text);
  end;
end;

procedure TfmMain.WriteLog(AMessage: ansistring);
begin
  if cbLog.Checked then
    mLog.Lines.Add(AMessage);
end;

end.
