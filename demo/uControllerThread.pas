unit uControllerThread;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, DateUtils,
  uController, uModbus, IniFiles;
  //, uLogger;

type
  TJobError = procedure(AMessage: string) of object;

  TControllerThread = class(TThread)
  private
    FController: TController;
    FTurnList: TStringList;
    FCodeList: TStringList;
    FUseCodeList: TStringList;

    FJobError: string;
    FOnJobError: TJobError;

    procedure DoJobError;
    procedure JobError(AMessage: string);
  protected
    procedure Execute; override;
  public
    constructor Create(Port: byte; TurnList, CodeList: TStrings);
    destructor Destroy; override;

    property OnJobError: TJobError read FOnJobError write FOnJobError;
  end;

implementation

{ TControllerThread }

constructor TControllerThread.Create(Port: byte; TurnList, CodeList: TStrings);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  Priority := tpNormal;

  FTurnList := TStringList.Create;
  FCodeList := TStringList.Create;
  FUseCodeList := TStringList.Create;

  FTurnList.Assign(TurnList);
  FCodeList.Assign(CodeList);

  FController := TController.Create;
  try
    if not FController.Open(Port, 115200)  then
      FJobError := 'Немогу подключиться к COM' + IntToStr(Port);
  except
  end;

  resume;
end;

destructor TControllerThread.Destroy;
begin
  FController.Close;
  FController := nil;

  FTurnList.Free;
  FCodeList.Free;
  FUseCodeList.Free;

  inherited;
end;

procedure TControllerThread.DoJobError;
begin
  if Assigned(FOnJobError) then
    FOnJobError(FJobError);
end;

procedure TControllerThread.Execute;
var
  i, l: integer;
  IsNew: boolean;
  Card: Tar;
  count: word;
  code: string;
  n: word;
  index: integer;
  ini: TIniFile;
  s, s1: string;
  er: TModbusError;
begin
  if FController = nil then Terminate;

  if FJobError <> '' then
    JobError(FJobError);

  try
    while not Terminated do
    begin
      for i := 0 to FTurnList.Count - 1 do
      begin
        try
          if FController = nil then exit;
          FController.GetEnterCard(StrToInt(FTurnList[i]), IsNew, Card, count);
          if (count > 0) and (IsNew) then
          begin
            FController.GetEnter(StrToInt(FTurnList[i]), n);
            if n = 0 then
            begin
              code := '';
              for l := 0 to count - 1 do
              begin
                try
                  code := code + chr(Card[l]);
                except
                end;
              end;
              code := trim(code);

              index := FCodeList.IndexOf(code);
              if (index <> -1) and (FCodeList.Count > 0) then
              begin
                try
                  er := FController.SetEnter(StrToInt(FTurnList[i]), 1);
                except
                end;
                try
                  FUseCodeList.Add(code + ';' + FTurnList[i] + ' ' + TimeToStr(time));
                except
                end;
                try
                  FCodeList.Delete(index);
                except
                end;
              end
              else
                FController.SetEnterRed(StrToInt(FTurnList[i]), 1, 1, 4);
            end;
          end;
        except
        end;

        try
          if FController = nil then exit;
          FController.GetExitCard(StrToInt(FTurnList[i]), IsNew, Card, count);
          if (count > 0) and (IsNew) then
          begin
            FController.GetExit(StrToInt(FTurnList[i]), n);
            if n = 0 then
            begin
              er := FController.SetExit(StrToInt(FTurnList[i]), 1);
              code := '';
              for l := 0 to count - 1 do
              begin
                try
                  code := code + chr(Card[l]);
                except
                end;
              end;
              code := trim(code);

              index := FCodeList.IndexOf(code);
              if (index <> -1) and (FCodeList.Count > 0) then
              begin
                try
                  er := FController.SetExit(StrToInt(FTurnList[i]), 1);
                except
                end;
                try
                  FUseCodeList.Add(code + ';' + FTurnList[i] + ' ' + TimeToStr(time));
                except
                end;
                try
                  FCodeList.Delete(index);
                except
                end;
              end
              else
                FController.SetExitRed(StrToInt(FTurnList[i]), 1, 1, 4);
            end;
          end;
        except
        end;
        sleep(30);
      end;
    end;
    if Terminated then
    begin
      ini := TIniFile.Create(ExtractFilePath(Application.Exename) + 'UsedCode.ini');
      try
        for i := 0 to FUseCodeList.Count - 1 do
        begin
          s := FUseCodeList[i];
          s1 := copy(s, 1, pos(';', s) - 1);
          delete(s, 1, pos(';', s));
          ini.WriteString('code', s1, s);
        end;
      finally
        ini.Free;
      end;
    end;
  except
  end;
end;

procedure TControllerThread.JobError(AMessage: string);
begin
  DoJobError;
end;

end.
