unit AgendaBDMG.DTO.Tarefa;

interface

uses
  System.Generics.Collections,
  GBSwagger.Model.Attributes,
  AgendaBDMG.Model.Tarefa;

type
  [SwagClass('Payload para criar uma nova tarefa')]
  TTarefaCreateDTO = class
  private
    FTitulo: string;
    FDescricao: string;
    FPrioridade: Integer;
  public
    [SwagProp('titulo', 'Titulo da tarefa', True)]
    property Titulo: string read FTitulo write FTitulo;
    [SwagProp('descricao', 'Descricao detalhada da tarefa')]
    property Descricao: string read FDescricao write FDescricao;
    [SwagProp('prioridade', 'Prioridade da tarefa (1 a 5)', True)]
    property Prioridade: Integer read FPrioridade write FPrioridade;
  end;

  [SwagClass('Payload para atualizar uma tarefa')]
  TTarefaUpdateDTO = class(TTarefaCreateDTO);

  [SwagClass('Payload para alterar o status da tarefa')]
  TTarefaStatusDTO = class
  private
    FStatus: string;
  public
    [SwagProp('status', 'Novo status da tarefa (PENDENTE, EM_ANDAMENTO, CONCLUIDA)', True)]
    property Status: string read FStatus write FStatus;
  end;

  [SwagClass('Objeto de resposta de uma Tarefa')]
  TTarefaResponseDTO = class
  private
    FId: Integer;
    FTitulo: string;
    FDescricao: string;
    FPrioridade: Integer;
    FStatus: string;
    FDataCriacao: string;
    FDataConclusao: string; // Nullable equivalent in string format
  public
    [SwagProp('id', 'ID da tarefa')]
    property Id: Integer read FId write FId;
    [SwagProp('titulo', 'Titulo da tarefa')]
    property Titulo: string read FTitulo write FTitulo;
    [SwagProp('descricao', 'Descricao da tarefa')]
    property Descricao: string read FDescricao write FDescricao;
    [SwagProp('prioridade', 'Nivel de prioridade')]
    property Prioridade: Integer read FPrioridade write FPrioridade;
    [SwagProp('status', 'Status atual da tarefa')]
    property Status: string read FStatus write FStatus;
    [SwagProp('dataCriacao', 'Data de criacao (ISO 8601)')]
    property DataCriacao: string read FDataCriacao write FDataCriacao;
    [SwagProp('dataConclusao', 'Data de conclusao (ISO 8601)')]
    property DataConclusao: string read FDataConclusao write FDataConclusao;
  end;

  [SwagClass('Dados de paginacao')]
  TPaginacaoDTO = class
  private
    FPaginaAtual: Integer;
    FItensPorPagina: Integer;
    FTotalItens: Integer;
    FTotalPaginas: Integer;
  public
    [SwagProp('paginaAtual', 'Pagina atual')]
    property PaginaAtual: Integer read FPaginaAtual write FPaginaAtual;
    [SwagProp('itensPorPagina', 'Itens por pagina')]
    property ItensPorPagina: Integer read FItensPorPagina write FItensPorPagina;
    [SwagProp('totalItens', 'Total de itens')]
    property TotalItens: Integer read FTotalItens write FTotalItens;
    [SwagProp('totalPaginas', 'Total de paginas')]
    property TotalPaginas: Integer read FTotalPaginas write FTotalPaginas;
  end;

  [SwagClass('Resposta de lista paginada de tarefas')]
  TListaTarefasResponseDTO = class
  private
    FDados: TObjectList<TTarefaResponseDTO>;
    FPaginacao: TPaginacaoDTO;
  public
    [SwagProp('dados', 'Lista de tarefas')]
    property Dados: TObjectList<TTarefaResponseDTO> read FDados write FDados;
    [SwagProp('paginacao', 'Informacoes de paginacao')]
    property Paginacao: TPaginacaoDTO read FPaginacao write FPaginacao;

    constructor Create;
    destructor Destroy; override;
  end;

  [SwagClass('Dashboard de estatisticas do sistema')]
  TEstatisticasDTO = class
  private
    FTotalTarefas: Integer;
    FMediaPrioridadePendentes: Double;
    FTarefasConcluidasUltimos7Dias: Integer;
  public
    [SwagProp('totalTarefas', 'Total geral de tarefas cadastradas')]
    property TotalTarefas: Integer read FTotalTarefas write FTotalTarefas;
    [SwagProp('mediaPrioridadePendentes', 'Media de prioridade das tarefas pendentes')]
    property MediaPrioridadePendentes: Double read FMediaPrioridadePendentes write FMediaPrioridadePendentes;
    [SwagProp('tarefasConcluidasUltimos7Dias', 'Total de tarefas concluidas nos ultimos 7 dias')]
    property TarefasConcluidasUltimos7Dias: Integer read FTarefasConcluidasUltimos7Dias write FTarefasConcluidasUltimos7Dias;
  end;

  [SwagClass('Resposta padronizada de erro')]
  TErroResponseDTO = class
  private
    FSucesso: Boolean;
    FMensagem: string;
    FDetalhes: string;
  public
    [SwagProp('sucesso', 'Indicador de sucesso (sempre false em erros)')]
    property Sucesso: Boolean read FSucesso write FSucesso;
    [SwagProp('mensagem', 'Mensagem amigavel do erro')]
    property Mensagem: string read FMensagem write FMensagem;
    [SwagProp('detalhes', 'Detalhes tecnicos ou de validacao')]
    property Detalhes: string read FDetalhes write FDetalhes;

    constructor Create(const AMensagem: string; const ADetalhes: string = '');
  end;

  [SwagClass('Resposta padronizada de sucesso')]
  TSucessoResponseDTO = class
  private
    FSucesso: Boolean;
    FMensagem: string;
  public
    [SwagProp('sucesso', 'Indicador de sucesso (true)')]
    property Sucesso: Boolean read FSucesso write FSucesso;
    [SwagProp('mensagem', 'Mensagem de sucesso')]
    property Mensagem: string read FMensagem write FMensagem;

    constructor Create(const AMensagem: string);
  end;

implementation

{ TListaTarefasResponseDTO }

constructor TListaTarefasResponseDTO.Create;
begin
  FDados := TObjectList<TTarefaResponseDTO>.Create(True);
  FPaginacao := TPaginacaoDTO.Create;
end;

destructor TListaTarefasResponseDTO.Destroy;
begin
  FDados.Free;
  if Assigned(FPaginacao) then
    FPaginacao.Free;
  inherited;
end;

{ TErroResponseDTO }

constructor TErroResponseDTO.Create(const AMensagem, ADetalhes: string);
begin
  FSucesso := False;
  FMensagem := AMensagem;
  FDetalhes := ADetalhes;
end;

{ TSucessoResponseDTO }

constructor TSucessoResponseDTO.Create(const AMensagem: string);
begin
  FSucesso := True;
  FMensagem := AMensagem;
end;

end.
