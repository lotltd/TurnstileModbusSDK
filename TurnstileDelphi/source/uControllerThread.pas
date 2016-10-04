unit uControllerThread;

interface

uses
  System.Classes, System.SysUtils, uController, uModbus;

type
  TJobError = procedure(Error: TModbusError) of object;

  TControllerThread = class(TThread)
  private
    FController: TController;
    FAddr: byte;
    FPort: byte;
    FSpeed: integer;
    FHost: string;

    FError: TModbusError;
    FOnJobError: TJobError;
    FDeviceType: byte; //0-турникет 1-ЖКИ индикатор

    procedure DoJobError;
    procedure JobError(Error: TModbusError);
  protected
    procedure Execute; override;
  public
    constructor Create(Port: byte; Speed: integer; Addr: byte); overload;
    constructor Create(Host: string; Port: integer; Addr: byte); overload;
    destructor Destroy; override;

    property OnJobError: TJobError read FOnJobError write FOnJobError;
    property Controller: TController read FController;
    property DeviceType: byte write FDeviceType;
  end;

implementation

uses
  uMain;

{ ProtocolThread }

constructor TControllerThread.Create(Port: byte; Speed: integer; Addr: byte);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  Priority := tpNormal;

  FAddr := Addr;
  FPort := port;
  FSpeed := speed;
end;

constructor TControllerThread.Create(Host: string; Port: integer;
  Addr: byte);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  Priority := tpNormal;

  FAddr := Addr;
  FPort := port;
  FHost := host;
end;

destructor TControllerThread.Destroy;
begin
  if FController <> nil then
  begin
    FController.Close;
    FController := nil;
    try
 //     FController.Free;
    finally
      FController := nil;
    end;
  end;

  inherited;
end;

procedure TControllerThread.DoJobError;
begin
  if Assigned(FOnJobError) then
    FOnJobError(FError);
end;

procedure TControllerThread.Execute;
var
  t: byte;
  n: word;
  ln: longword;
  IsNew: boolean;
  Card: Tar;
  i: byte;
  count: word;
  s, s1: ansistring;
begin
  FController := TController.Create;
  if FHost = '' then
    FError := FController.Open(FPort, FSpeed, FAddr)
  else
    FError := FController.Open(FHost, FPort, FAddr);
  if FError <> merNone then
  begin
    FController.Free;
    JobError(FError);
    Terminate;
  end
  else
    Synchronize(
      procedure
      begin
        fmMain.edCompany.Text := FController.DeviceInfo.Company;
        fmMain.edProduct.Text := FController.DeviceInfo.Product;
        fmMain.edVer.Text := FController.DeviceInfo.Version;
      end
      );

  while not Terminated do
  begin
    if FDeviceType = 0 then
    begin
      FError := FController.GetEnter(FAddr, n);
      if n = 0 then
        t := 0
      else if n = $FFFF then
        t := 2
      else
        t := 1;
      Synchronize(
        procedure
        begin
          fmMain.rgEnterState.ItemIndex := t;
        end
        );
      JobError(FError);

      if Terminated then exit;
      FError := FController.GetExit(FAddr, n);
      if n = 0 then
        t := 0
      else if n = $FFFF then
        t := 2
      else
        t := 1;
      Synchronize(
        procedure
        begin
          fmMain.rgExitState.ItemIndex := t;
        end
        );
      JobError(FError);

      if Terminated then exit;
      FError := FController.GetEnterState(FAddr, n);
      if n = 0 then
        t := 0
      else
        t := 1;
      Synchronize(
        procedure
        begin
          fmMain.rgEnterPassState.ItemIndex := t;
        end
        );
      JobError(FError);

      if Terminated then exit;
      FError := FController.GetExitState(FAddr, n);
      if n = 0 then
        t := 0
      else
        t := 1;
      Synchronize(
        procedure
        begin
          fmMain.rgExitPassState.ItemIndex := t;
        end
        );
      JobError(FError);

      if Terminated then exit;
      FError := FController.GetEnterCount(FAddr, ln);
      Synchronize(
        procedure
        begin
          fmMain.edEnterCount.Text := IntToStr(ln);
        end
        );
      JobError(FError);

      if Terminated then exit;
      FError := FController.GetExitCount(FAddr, ln);
      Synchronize(
        procedure
        begin
          fmMain.edExitCount.Text := IntToStr(ln);
        end
        );
      JobError(FError);

      if Terminated then exit;
      FError := FController.GetErrorState(FAddr, n);
      Synchronize(
        procedure
        begin
          fmMain.cbEngineBlockState.Checked := Boolean(n);
        end
        );
      JobError(FError);

      if Terminated then exit;
      FError := FController.GetEnterCard(FAddr, IsNew, Card, count);
      if IsNew then
      begin
        s := '';
        s1 := '';
        for i := 0 to count - 1 do
        begin
          try
            s := s + chr(Card[i]) + ' ';
            s1 := s1 + '$' + IntToHex(Card[i], 2) + ' ';
          except
          end;
        end;
        Synchronize(
          procedure
          begin
            fmMain.edCard.Text := trim(s1);
            fmMain.edCardASCII.Text := s;
          end
          );
      end;
      JobError(FError);

      if Terminated then exit;
      FError := FController.GetExitCard(FAddr, IsNew, Card, count);
      if IsNew then
      begin
        s := '';
        s1 := '';
        for i := 0 to count - 1 do
        begin
          try
            s := s + chr(Card[i]) + ' ';
            s1 := s1 + '$' + IntToHex(Card[i], 2) + ' ';
          except
          end;
        end;
        Synchronize(
          procedure
          begin
            fmMain.edCard2.Text := trim(s1);
            fmMain.edCard2ASCII.Text := s;
          end
          );
      end;
      JobError(FError);

      if Terminated then exit;
      FError := FController.GetDemo(FAddr, n);
        Synchronize(
          procedure
          begin
            if n = 1 then
              fmMain.Caption := 'Modbus demo on'
            else
              fmMain.Caption := 'Modbus demo off';
          end
          );
      JobError(FError);
    end;

    sleep(900);
  end;
end;

procedure TControllerThread.JobError(Error: TModbusError);
begin
  DoJobError;
end;

end.
