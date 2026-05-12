unit AgendaMontreal.DTO.Tarefa;

interface

uses
  System.Generics.Collections,
  AgendaMontreal.Model.Tarefa;

type
  TTarefaCreateDTO = class
  private
    FTitulo: string;
    FDescricao: string;
    FPrioridade: Integer;
  public
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
    property Prioridade: Integer read FPrioridade write FPrioridade;
  end;

  TTarefaUpdateDTO = class(TTarefaCreateDTO);

  TTarefaStatusDTO = class
  private
    FStatus: string;
  public
    property Status: string read FStatus write FStatus;
  end;

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
    property Id: Integer read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
    property Prioridade: Integer read FPrioridade write FPrioridade;
    property Status: string read FStatus write FStatus;
    property DataCriacao: string read FDataCriacao write FDataCriacao;
    property DataConclusao: string read FDataConclusao write FDataConclusao;
  end;

  TPaginacaoDTO = class
  private
    FPaginaAtual: Integer;
    FItensPorPagina: Integer;
    FTotalItens: Integer;
    FTotalPaginas: Integer;
  public
    property PaginaAtual: Integer read FPaginaAtual write FPaginaAtual;
    property ItensPorPagina: Integer read FItensPorPagina write FItensPorPagina;
    property TotalItens: Integer read FTotalItens write FTotalItens;
    property TotalPaginas: Integer read FTotalPaginas write FTotalPaginas;
  end;

  TListaTarefasResponseDTO = class
  private
    FDados: TObjectList<TTarefaResponseDTO>;
    FPaginacao: TPaginacaoDTO;
  public
    property Dados: TObjectList<TTarefaResponseDTO> read FDados write FDados;
    property Paginacao: TPaginacaoDTO read FPaginacao write FPaginacao;

    constructor Create;
    destructor Destroy; override;
  end;

  TEstatisticasDTO = class
  private
    FTotalTarefas: Integer;
    FMediaPrioridadePendentes: Double;
    FTarefasConcluidasUltimos7Dias: Integer;
  public
    property TotalTarefas: Integer read FTotalTarefas write FTotalTarefas;
    property MediaPrioridadePendentes: Double read FMediaPrioridadePendentes write FMediaPrioridadePendentes;
    property TarefasConcluidasUltimos7Dias: Integer read FTarefasConcluidasUltimos7Dias write FTarefasConcluidasUltimos7Dias;
  end;

  TErroResponseDTO = class
  private
    FSucesso: Boolean;
    FMensagem: string;
    FDetalhes: string;
  public
    property Sucesso: Boolean read FSucesso write FSucesso;
    property Mensagem: string read FMensagem write FMensagem;
    property Detalhes: string read FDetalhes write FDetalhes;

    constructor Create(const AMensagem: string; const ADetalhes: string = '');
  end;

  TSucessoResponseDTO = class
  private
    FSucesso: Boolean;
    FMensagem: string;
  public
    property Sucesso: Boolean read FSucesso write FSucesso;
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
