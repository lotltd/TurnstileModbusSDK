unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, Vcl.Buttons,
  Vcl.ExtCtrls, IniFiles,
  uControllerThread;

type
  TfmMain = class(TForm)
    GroupBox1: TGroupBox;
    lbTurn: TListBox;
    PopupMenu1: TPopupMenu;
    btnTurnAdd: TMenuItem;
    btnTurnDel: TMenuItem;
    GroupBox2: TGroupBox;
    lbCode: TListBox;
    PopupMenu2: TPopupMenu;
    btnCodeAdd: TMenuItem;
    btnCodeDel: TMenuItem;
    btnStart: TBitBtn;
    Label1: TLabel;
    cbPort: TComboBox;
    procedure btnTurnAddClick(Sender: TObject);
    procedure btnTurnDelClick(Sender: TObject);
    procedure btnCodeAddClick(Sender: TObject);
    procedure btnCodeDelClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure JobError(AMessage: string);
  private
    FControllerThread: TControllerThread;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btnCodeAddClick(Sender: TObject);
var
  n: string;
begin
  if InputQuery('Добавление кода', 'Код', n) then
    lbCode.Items.Add(n);
end;

procedure TfmMain.btnCodeDelClick(Sender: TObject);
begin
  if lbCode.ItemIndex < 0 then
    exit;
  if MessageDlg('Вы действительно хотите удалить запись?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    lbCode.Items.Delete(lbCode.ItemIndex);
end;

procedure TfmMain.btnStartClick(Sender: TObject);
begin
  if lbTurn.Items.Count = 0 then
  begin
    MessageDlg('Список адресов пуст', mtError, [mbOk], 0);
    exit;
  end;
  if btnStart.Caption = 'Отключиться' then
  begin
    FControllerThread.Terminate;
    btnStart.Caption := 'Подключиться';
    btnTurnAdd.Enabled := true;
    btnTurnDel.Enabled := true;
    btnCodeAdd.Enabled := true;
    btnCodeDel.Enabled := true;
  end
  else
  begin
    FControllerThread := TControllerThread.Create(cbPort.ItemIndex + 1, lbTurn.Items, lbCode.Items);
    FControllerThread.OnJobError := JobError;
    btnStart.Caption := 'Отключиться';
    btnTurnAdd.Enabled := false;
    btnTurnDel.Enabled := false;
    btnCodeAdd.Enabled := false;
    btnCodeDel.Enabled := false;
  end;
end;

procedure TfmMain.btnTurnAddClick(Sender: TObject);
var
  n: string;
begin
  if InputQuery('Добавление турникета', 'Номер турникета', n) then
    lbTurn.Items.Add(n);
end;

procedure TfmMain.btnTurnDelClick(Sender: TObject);
begin
  if lbTurn.ItemIndex < 0 then
    exit;
  if MessageDlg('Вы действительно хотите удалить запись?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    lbTurn.Items.Delete(lbTurn.ItemIndex);
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini: TIniFile;
  i: integer;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.Exename) + 'Settings.ini');
  try
    ini.EraseSection('Turn');
    ini.EraseSection('Code');
    if lbTurn.Items.Count > 0 then
    begin
      for i := 0 to lbTurn.Items.Count - 1 do
        ini.WriteString('Turn', IntToStr(i), lbTurn.Items[i]);
    end;
    if lbCode.Items.Count > 0 then
    begin
      for i := 0 to lbCode.Items.Count - 1 do
        ini.WriteString('Code', IntToStr(i), lbCode.Items[i]);
    end;
  finally
    ini.Free;
  end;
end;

procedure TfmMain.FormShow(Sender: TObject);
var
  ini: TIniFile;
  sl: TStringList;
  i: integer;
  s: string;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.Exename) + 'Settings.ini');
  sl := TStringList.Create;
  try
    if ini.SectionExists('Turn') then
    begin
      ini.ReadSection('Turn', sl);
      if sl.Count > 0 then
        for i := 0 to sl.Count - 1 do
        begin
          s := ini.ReadString('Turn', sl[i], '0');
          lbTurn.Items.Add(s);
        end;
    end;
    if ini.SectionExists('Code') then
    begin
      ini.ReadSection('Code', sl);
      if sl.Count > 0 then
        for i := 0 to sl.Count - 1 do
        begin
          s := ini.ReadString('Code', sl[i], '0');
          lbCode.Items.Add(s);
        end;
    end;
  finally
    ini.Free;
    sl.Free;
  end;
end;

procedure TfmMain.JobError(AMessage: string);
begin
  MessageDlg(AMessage, mtError, [mbOk], 0);
  btnStart.OnClick(fmMain);
end;

end.
