unit AgendaBDMG.Factory.Repository;

interface

uses
  AgendaBDMG.Interfaces,
  AgendaBDMG.Repository.Tarefa;

type
  TFabricaRepository = class
  public
    class function Tarefa(AConnection: IDbConnection): ITarefaRepository;
  end;

implementation

{ TFabricaRepository }

class function TFabricaRepository.Tarefa(AConnection: IDbConnection): ITarefaRepository;
begin
  Result := TTarefaRepository.Create(AConnection);
end;

end.
