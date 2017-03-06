unit uTurnDef;

interface

uses
  System.Classes, System.SysUtils;

type
  TTurnStateChange = procedure(AAddr: cardinal) of object;

  TTurnDef = class
  private
    FAddr: cardinal;

    FEnterState: word;
    FExitState: word;

    FReader: byte;

    FEnterCardNum: AnsiString;
    FIsEnterNew: boolean;
    FExitCardNum: AnsiString;
    FIsExitNew: boolean;
    FEmergency: boolean;

    FEnterCount: longword;
    FExitCount: longword;

    FOnChangeState: TTurnStateChange;

    FIndicator: AnsiString;

    procedure DoChangeState;
    procedure SetEnterState(AValue: word);
    procedure SetExitState(AValue: word);

    function GetEnterCardNum: AnsiString;
    function GetExitCardNum: AnsiString;
    procedure SetEnterCardNum(value: AnsiString);
    procedure SetExitCardNum(value: AnsiString);

    function GetCardNumHex(value: AnsiString): AnsiString;
    procedure SetIndicator(value: AnsiString);
  public
    constructor Create(AAddr: word);
    destructor Destroy; override;

    property Addr: cardinal read FAddr write FAddr;
    property Emergency: boolean read FEmergency write FEmergency;

    property EnterCardNum: AnsiString read GetEnterCardNum write SetEnterCardNum;
    property ExitCardNum: AnsiString read GetExitCardNum write SetExitCardNum;

    property IsEnterNew: boolean read FIsEnterNew;
    property IsExitNew: boolean read FIsExitNew;

    property EnterState: word read FEnterState write SetEnterState;
    property ExitState: word read FExitState write SetExitState;

    property EnterCount: longword read FEnterCount write FEnterCount;
    property ExitCount: longword read FExitCount write FExitCount;

    property Reader: byte read FReader write FReader;

    property Indicator: AnsiString read FIndicator write SetIndicator;

    property OnChangeState: TTurnStateChange read FOnChangeState write FOnChangeState;
  end;

  TTurnstiles = class
  private
    FTurnList: array of TTurnDef;
    function GetCount: word;
  public
    constructor Create;
    destructor Destroy; override;

    function AddTurn(ANumber: Cardinal): TTurnDef;
    function ByAddr(AAddr: cardinal): TTurnDef;
    function IsAddrExists(AAddr: Cardinal): boolean;

    property Count: word read GetCount;
  end;

var
  Turnstiles: TTurnstiles;


implementation

{ TTurnDef }

constructor TTurnDef.Create(AAddr: word);
begin
  FAddr := AAddr;

  FEnterCount := 0;
  FExitCount := 0;

  FEnterState := 0;
  FExitState := 0;

  FIsEnterNew := false;
  FIsExitNew := false;
  FEnterCardNum := '0';
  FExitCardNum := '0';
end;

destructor TTurnDef.Destroy;
begin
  inherited;
end;

procedure TTurnDef.DoChangeState;
begin
  if Assigned(FOnChangeState) then
    FOnChangeState(Addr);
end;

function TTurnDef.GetCardNumHex(value: AnsiString): AnsiString;
var
  i: integer;
  s: char;
begin
  result := '';
  i:= 1;
  if length(value) < 2 then
    exit;
  while i <= Length(value) do
  begin
    result := result + AnsiChar(StrToInt('$' + Copy(value, i, 2)));
    i := i + 2;
  end;
end;

function TTurnDef.GetEnterCardNum: AnsiString;
begin
  result := GetCardNumHex(FEnterCardNum);
  FIsEnterNew := false;
end;

function TTurnDef.GetExitCardNum: AnsiString;
begin
  result := FExitCardNum;
  FIsExitNew := false;
end;

procedure TTurnDef.SetEnterCardNum(value: AnsiString);
begin
  FEnterCardNum := value;
  FIsEnterNew := true;
end;

procedure TTurnDef.SetEnterState(AValue: word);
begin
  FEnterState := AValue;
  DoChangeState;
end;

procedure TTurnDef.SetExitCardNum(value: AnsiString);
begin
  FExitCardNum := value;
  FIsExitNew := true;
end;

procedure TTurnDef.SetExitState(AValue: word);
begin
  FExitState := AValue;
  DoChangeState;
end;

procedure TTurnDef.SetIndicator(value: AnsiString);
var
  i: byte;
begin
  FIndicator := '';
  for i := 1 to length(value) do
    FIndicator := FIndicator + AnsiChar(value[i]);
  DoChangeState;
end;

{ TTurnstiles }

function TTurnstiles.ByAddr(AAddr: cardinal): TTurnDef;
var
  i: byte;
begin
  result := nil;
  if Length(FTurnList) = 0 then
    exit;
  for i := 0 to Length(FTurnList) - 1 do
    if FTurnList[i].Addr = AAddr then
      result := FTurnList[i];
end;

constructor TTurnstiles.Create;
begin
  inherited;

  SetLength(FTurnList, 0);
end;

destructor TTurnstiles.Destroy;
var
  i: byte;
begin
  if Length(FTurnList) > 0 then
    for i := 0 to Length(FTurnList) - 1 do
      FTurnList[i].Free;
  SetLength(FTurnList, 0);

  inherited;
end;

function TTurnstiles.GetCount: word;
begin
  result := Length(FTurnList);
end;

function TTurnstiles.IsAddrExists(AAddr: Cardinal): boolean;
var
  i: byte;
begin
  result := false;
  if Length(FTurnList) = 0 then
    exit;
  for i := 0 to Length(FTurnList) - 1 do
    if FTurnList[i].Addr = AAddr then
      result := true;
end;

function TTurnstiles.AddTurn(ANumber: cardinal): TTurnDef;
begin
  SetLength(FTurnList, Length(FTurnList) + 1);
  FTurnList[Length(FTurnList) - 1] := TTurnDef.Create(Anumber);
  result := FTurnList[Length(FTurnList) - 1];
end;

initialization

  Turnstiles := nil;

end.
