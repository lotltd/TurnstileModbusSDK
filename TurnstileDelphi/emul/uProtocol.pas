unit uProtocol;

interface

uses
  System.Classes;

type
  TCommunicatorState = (csStopped, csNotConnected, csConnecting, csConnected, csStop);

  TChangeCommunicatorState = procedure(AState: TCommunicatorState) of object;
  TWriteLog = procedure(AMessage: ansistring) of object;

  TProtocol = class(TThread)
  private
    FOnChangeState: TChangeCommunicatorState;
    FOnWriteLog: TWriteLog;

    procedure ChangeState(AValue: TCommunicatorState);
    procedure DoChangeState;
    procedure DoWriteLog;
  protected
    FBuf: Ansistring;
    FCommunicatorState: TCommunicatorState;
    FLogMessage: ansistring;

    function Deserialize(Data: AnsiString): AnsiString; virtual; abstract;

    procedure Execute; override; abstract;

    procedure WriteLog(AMessage: ansistring);
  public
    constructor Create; virtual;

    property CommunicatorState: TCommunicatorState read FCommunicatorState write ChangeState;

    property OnChangeState: TChangeCommunicatorState read FOnChangeState;
    property OnWriteLog: TWriteLog read FOnWriteLog write FOnWriteLog;
  end;

function BinToHex(aStr: AnsiString): AnsiString;

implementation

uses
  uMain;

function BinToHex(aStr: AnsiString): AnsiString;
const
  aHexChars: AnsiString = '0123456789ABCDEF';
var
  i: integer;
begin
  Result := '';
  for I := 1 to Length(aStr) do
    Result := Result + aHexChars[1 + (Byte(aStr[i]) div 16)] + aHexChars[1 + (Byte(aStr[i]) mod 16)] + ' ';
end;

{ TCommunication }

procedure TProtocol.ChangeState(AValue: TCommunicatorState);
begin
  FCommunicatorState := AValue;
  DoChangeState;
end;

constructor TProtocol.Create;
begin
  inherited Create(true);

  Priority := tpNormal;
  FreeOnTerminate := true;

  FCommunicatorState := csNotConnected;
end;

procedure TProtocol.DoChangeState;
begin
  if Assigned(FOnChangeState) then
    FOnChangeState(FCommunicatorState);
end;

procedure TProtocol.DoWriteLog;
begin
  if Assigned(FOnWriteLog) then
    FOnWriteLog(FLogMessage);
end;

procedure TProtocol.WriteLog(AMessage: ansistring);
var
  s: ansistring;
begin
  s := AMessage;
  s := copy(s, 1, pos(' ', s)) + BinToHex(copy(s, pos(' ', s) + 1, length(s)));
  FLogMessage := s;
  DoWriteLog;
end;

end.
