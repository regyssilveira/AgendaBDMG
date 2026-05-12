unit AgendaBDMG.Database.Connection;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Comp.Client,
  AgendaBDMG.Interfaces,
  AgendaBDMG.Utils.Config;

type
  TDatabaseConnection = class(TInterfacedObject, IDbConnection)
  private
    FConnection: TFDConnection;
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

procedure TDatabaseConnection.ConfigureConnection;
var
  LConfig: TServerConfig;
begin
  LConfig := TServerConfig.GetInstance;
  
  FConnection.Params.Clear;
  FConnection.Params.Add('DriverID=' + LConfig.DatabaseDriver);
  FConnection.Params.Add('Server=' + LConfig.DatabaseServer);
  if LConfig.DatabasePort > 0 then
    FConnection.Params.Add('Port=' + LConfig.DatabasePort.ToString);
  FConnection.Params.Add('Database=' + LConfig.DatabaseName);
  FConnection.Params.Add('User_Name=' + LConfig.DatabaseUsername);
  FConnection.Params.Add('Password=' + LConfig.DatabasePassword);
  
  // Connection Pooling
  FConnection.Params.Add('Pooled=True');
  FConnection.Params.Add('POOL_MaximumItems=50');
  
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
