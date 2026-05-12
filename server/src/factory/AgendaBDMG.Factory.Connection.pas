unit AgendaBDMG.Factory.Connection;

interface

uses
  AgendaBDMG.Interfaces,
  AgendaBDMG.Database.Connection;

type
  TFabricaConexao = class
  public
    class function CreateConnection: IDbConnection;
  end;

implementation

{ TFabricaConexao }

class function TFabricaConexao.CreateConnection: IDbConnection;
begin
  Result := TDatabaseConnection.Create;
end;

end.
