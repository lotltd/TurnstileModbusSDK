unit uTurnDef;

interface

uses
  System.Classes;

type
  TTurnStateChange = procedure(AAddr: cardinal) of object;

  TTurnDef = class
  private
    FAddr: cardinal;

    FEnterState: word;
    FExitState: word;

    FReader: byte;

    FEnterCardNum: AnsiString;
    FExitCardNum: AnsiString;
    FEmergency: boolean;

    FEnterCount: longword;
    FExitCount: longword;

    FOnChangeState: TTurnStateChange;
    procedure DoChangeState;
    procedure SetEnterState(AValue: word);
    procedure SetExitState(AValue: word);
  public
    constructor Create(AAddr: word);
    destructor Destroy; override;

    property Addr: cardinal read FAddr write FAddr;
    property Emergency: boolean read FEmergency write FEmergency;

    property EnterCardNum: AnsiString read FEnterCardNum write FEnterCardNum;
    property ExitCardNum: AnsiString read FExitCardNum write FExitCardNum;

    property EnterState: word read FEnterState write SetEnterState;
    property ExitState: word read FExitState write SetExitState;

    property EnterCount: longword read FEnterCount write FEnterCount;
    property ExitCount: longword read FExitCount write FExitCount;

    property Reader: byte read FReader write FReader;

    property OnChangeState: TTurnStateChange read FOnChangeState write FOnChangeState;
  end;

  TTurnstiles = class
  private
    FTurnList: array of TTurnDef;
  public
    constructor Create;
    destructor Destroy; override;

    function AddTurn(ANumber: Cardinal): TTurnDef;
    function ByAddr(AAddr: cardinal): TTurnDef;
    function IsAddrExists(AAddr: Cardinal): boolean;
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

procedure TTurnDef.SetEnterState(AValue: word);
begin
  FEnterState := AValue;
  DoChangeState;
end;

procedure TTurnDef.SetExitState(AValue: word);
begin
  FExitState := AValue;
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
