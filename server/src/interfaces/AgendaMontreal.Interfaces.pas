unit AgendaMontreal.Interfaces;

interface

uses
  System.Generics.Collections,
  AgendaMontreal.Model.Tarefa,
  AgendaMontreal.DTO.Tarefa;

type
  IDbConnection = interface
    ['{8A5D6B10-1F2A-4C2E-89A0-31E5606F9192}']
    function GetConnection: TObject; // Retorna TFDConnection abstrato
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

  ITarefaRepository = interface
    ['{5A0F22A0-B6B1-4A5D-B5C5-2C5E7A2E9F8E}']
    function Listar(APagina, ALimite: Integer; const AStatus: string; APrioridade: Integer; const AOrdem: string; out ATotal: Integer): TList<TTarefa>;
    function ObterPorId(AId: Integer): TTarefa;
    procedure Criar(ATarefa: TTarefa);
    procedure Atualizar(ATarefa: TTarefa);
    procedure Remover(AId: Integer);
    function ObterEstatisticas(out ATotal, ATarefasConcluidas: Integer; out AMediaPrioridade: Double): Boolean;
  end;

  ITarefaService = interface
    ['{C6B38E11-9A3D-4A29-87D9-9F8C6D1A2B5E}']
    function Listar(APagina, ALimite: Integer; const AStatus: string; APrioridade: Integer; const AOrdem: string): TListaTarefasResponseDTO;
    function ObterPorId(AId: Integer): TTarefaResponseDTO;
    function Criar(ADTO: TTarefaCreateDTO): TTarefaResponseDTO;
    function Atualizar(AId: Integer; ADTO: TTarefaUpdateDTO): TTarefaResponseDTO;
    function AtualizarStatus(AId: Integer; ADTO: TTarefaStatusDTO): TTarefaResponseDTO;
    procedure Remover(AId: Integer);
    function ObterEstatisticas: TEstatisticasDTO;
  end;

implementation

end.
