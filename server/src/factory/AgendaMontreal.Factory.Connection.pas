unit AgendaMontreal.Factory.Connection;

interface

uses
  AgendaMontreal.Interfaces,
  AgendaMontreal.Database.Connection;

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
