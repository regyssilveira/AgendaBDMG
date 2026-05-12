unit AgendaBDMG.Database.Connection;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Comp.Client, FireDAC.DApt,
  AgendaBDMG.Interfaces,
  AgendaBDMG.Utils.Config;

type
  TDatabaseConnection = class(TInterfacedObject, IDbConnection)
  private
    FConnection: TFDConnection;
    class procedure RegisterPool;
    procedure ConfigureConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection: TObject;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

implementation

{ TDatabaseConnection }

class procedure TDatabaseConnection.RegisterPool;
var
  LDef: IFDStanConnectionDef;
  LConfig: TServerConfig;
begin
  if not FDManager.IsConnectionDef('AgendaPool') then
  begin
    LConfig := TServerConfig.GetInstance;
    LDef := FDManager.ConnectionDefs.AddConnectionDef;
    LDef.Name := 'AgendaPool';
    LDef.Params.Add('DriverID=' + LConfig.DatabaseDriver);
    LDef.Params.Add('Server=' + LConfig.DatabaseServer);
    if LConfig.DatabasePort > 0 then
      LDef.Params.Add('Port=' + LConfig.DatabasePort.ToString);
    LDef.Params.Add('Database=' + LConfig.DatabaseName);
    LDef.Params.Add('User_Name=' + LConfig.DatabaseUsername);
    LDef.Params.Add('Password=' + LConfig.DatabasePassword);
    LDef.Params.Add('Pooled=True');
    LDef.Params.Add('POOL_MaximumItems=50');
  end;
end;

procedure TDatabaseConnection.ConfigureConnection;
begin
  RegisterPool;
  FConnection.ConnectionDefName := 'AgendaPool';
  FConnection.LoginPrompt := False;
end;

constructor TDatabaseConnection.Create;
begin
  FConnection := TFDConnection.Create(nil);
  ConfigureConnection;
  FConnection.Connected := True;
end;

destructor TDatabaseConnection.Destroy;
begin
  if FConnection.Connected then
    FConnection.Connected := False;
  FConnection.Free;
  inherited;
end;

function TDatabaseConnection.GetConnection: TObject;
begin
  Result := FConnection;
end;

procedure TDatabaseConnection.StartTransaction;
begin
  if not FConnection.InTransaction then
    FConnection.StartTransaction;
end;

procedure TDatabaseConnection.Commit;
begin
  if FConnection.InTransaction then
    FConnection.Commit;
end;

procedure TDatabaseConnection.Rollback;
begin
  if FConnection.InTransaction then
    FConnection.Rollback;
end;

end.
