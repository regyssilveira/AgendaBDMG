unit AgendaBDMG.Factory.Service;

interface

uses
  AgendaBDMG.Interfaces,
  AgendaBDMG.Service.Tarefa,
  AgendaBDMG.Factory.Connection,
  AgendaBDMG.Factory.Repository;

type
  TFabricaService = class
  public
    class function Tarefa: ITarefaService;
  end;

implementation

{ TFabricaService }

class function TFabricaService.Tarefa: ITarefaService;
var
  LConnection: IDbConnection;
  LRepository: ITarefaRepository;
begin
  LConnection := TFabricaConexao.CreateConnection;
  LRepository := TFabricaRepository.Tarefa(LConnection);
  Result := TTarefaService.Create(LRepository);
end;

end.
