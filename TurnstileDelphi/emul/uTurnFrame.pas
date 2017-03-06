unit uTurnFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ImgList, Vcl.Buttons;

type
  TfrTurn = class(TFrame)
    gb: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cbStateIn: TComboBox;
    cbStateOut: TComboBox;
    cbEmergency: TCheckBox;
    edCardExit: TEdit;
    Label1: TLabel;
    cbReader: TComboBox;
    btnIn: TButton;
    ImageList1: TImageList;
    btnOut: TButton;
    btnCardExit: TSpeedButton;
    Timer1: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    lEnterCount: TLabel;
    lExitCount: TLabel;
    Label4: TLabel;
    edCardEnter: TEdit;
    btnCardEnter: TSpeedButton;
    Timer2: TTimer;
    edLED1: TEdit;
    edLED2: TEdit;
    procedure edCardExitKeyPress(Sender: TObject; var Key: Char);
    procedure btnCardExitClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnInClick(Sender: TObject);
    procedure btnOutClick(Sender: TObject);
    procedure btnCardEnterClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  uMain, uTurnDef;

procedure TfrTurn.btnCardEnterClick(Sender: TObject);
begin
  if length(edCardEnter.Text) > 5 then
    with Turnstiles.ByAddr(self.Tag) do
     EnterCardNum := edCardEnter.Text;
end;

procedure TfrTurn.btnCardExitClick(Sender: TObject);
begin
  if length(edCardExit.Text) > 5 then
    with Turnstiles.ByAddr(self.Tag) do
      ExitCardNum := edCardExit.Text;
end;

procedure TfrTurn.btnInClick(Sender: TObject);
begin
  with Turnstiles.ByAddr(self.Tag) do
  begin
    if EnterState <> 0 then
    begin
      EnterCount := EnterCount + 1;
      lEnterCount.Caption := IntToStr(EnterCount);
      if EnterState  < $FFFF  then
        EnterState := EnterState - 1;
      if EnterState = 0 then
      begin
        Timer1.Enabled := false;
        btnIn.Enabled := false;
        btnIn.ImageIndex := 0;
      end;
    end;
  end;
end;

procedure TfrTurn.btnOutClick(Sender: TObject);
begin
  with Turnstiles.ByAddr(self.Tag) do
  begin
    if ExitState <> 0 then
    begin
      ExitCount := ExitCount + 1;
      lExitCount.Caption := IntToStr(ExitCount);
      if ExitState < $FFFF then
        ExitState := ExitState - 1;
      if ExitState = 0 then
      begin
        Timer2.Enabled := false;
        btnOut.Enabled := false;
        btnOut.ImageIndex := 0;
      end;
    end;
  end;
end;

procedure TfrTurn.edCardExitKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0'..'9', 'A'..'F', 'a'..'f', #8]) then
    Key := #0;
end;

procedure TfrTurn.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  btnIn.ImageIndex := 0;
  btnIn.Enabled := false;
  with Turnstiles.ByAddr(self.Tag) do
    EnterState := EnterState - 1;
end;

procedure TfrTurn.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := false;
  btnOut.ImageIndex := 0;
  btnOut.Enabled := false;
  with Turnstiles.ByAddr(self.Tag) do
    ExitState := ExitState - 1;
end;

end.
