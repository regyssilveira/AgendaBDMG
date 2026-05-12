unit AgendaBDMG.Service.Tarefa;

interface

uses
  System.SysUtils, System.Generics.Collections,
  AgendaBDMG.Model.Tarefa,
  AgendaBDMG.DTO.Tarefa,
  AgendaBDMG.Interfaces;

type
  TTarefaService = class(TInterfacedObject, ITarefaService)
  private
    FRepository: ITarefaRepository;
    function MapToResponseDTO(ATarefa: TTarefa): TTarefaResponseDTO;
    procedure ValidarRegrasBasicas(const ATitulo, ADescricao: string; APrioridade: Integer);
    function BuscarTarefaExistente(AId: Integer): TTarefa;
    procedure PreencherDadosTarefa(ATarefa: TTarefa; ADTO: TTarefaCreateDTO);
  public
    constructor Create(ARepository: ITarefaRepository);
    
    function Listar(APagina, ALimite: Integer; const AStatus: string; APrioridade: Integer; const AOrdem: string): TListaTarefasResponseDTO;
    function ObterPorId(AId: Integer): TTarefaResponseDTO;
    function Criar(ADTO: TTarefaCreateDTO): TTarefaResponseDTO;
    function Atualizar(AId: Integer; ADTO: TTarefaUpdateDTO): TTarefaResponseDTO;
    function AtualizarStatus(AId: Integer; ADTO: TTarefaStatusDTO): TTarefaResponseDTO;
    procedure Remover(AId: Integer);
    function ObterEstatisticas: TEstatisticasDTO;
  end;

implementation

uses
  Horse.Exception, Horse.Commons,
  AgendaBDMG.Utils.Json, Math;

{ TTarefaService }

constructor TTarefaService.Create(ARepository: ITarefaRepository);
begin
  FRepository := ARepository;
end;

procedure TTarefaService.ValidarRegrasBasicas(const ATitulo, ADescricao: string; APrioridade: Integer);
begin
  if Trim(ATitulo) = '' then
    raise EHorseException.New.Error('O título da tarefa é obrigatório.').Status(THTTPStatus.BadRequest);
    
  if Length(ATitulo) > 150 then
    raise EHorseException.New.Error('O título da tarefa não pode exceder 150 caracteres.').Status(THTTPStatus.BadRequest);
    
  if Length(ADescricao) > 1000 then
    raise EHorseException.New.Error('A descrição não pode exceder 1000 caracteres.').Status(THTTPStatus.BadRequest);
    
  if (APrioridade < 1) or (APrioridade > 5) then
    raise EHorseException.New.Error('A prioridade deve estar entre 1 e 5.').Status(THTTPStatus.BadRequest);
end;

function TTarefaService.BuscarTarefaExistente(AId: Integer): TTarefa;
begin
  Result := FRepository.ObterPorId(AId);
  if not Assigned(Result) then
    raise EHorseException.New.Error('Tarefa não encontrada').Status(THTTPStatus.NotFound);
end;

procedure TTarefaService.PreencherDadosTarefa(ATarefa: TTarefa; ADTO: TTarefaCreateDTO);
begin
  ATarefa.Titulo := ADTO.Titulo;
  ATarefa.Descricao := ADTO.Descricao;
  ATarefa.Prioridade := ADTO.Prioridade;
end;

function TTarefaService.MapToResponseDTO(ATarefa: TTarefa): TTarefaResponseDTO;
begin
  Result := TTarefaResponseDTO.Create;
  Result.Id := ATarefa.Id;
  Result.Titulo := ATarefa.Titulo;
  Result.Descricao := ATarefa.Descricao;
  Result.Prioridade := ATarefa.Prioridade;
  Result.Status := ATarefa.Status.ToString;
  Result.DataCriacao := TJsonUtils.DateTimeToISO8601(ATarefa.DataCriacao);
  Result.DataConclusao := TJsonUtils.DateTimeToISO8601(ATarefa.DataConclusao); // Retorna vazio se 0
end;

function TTarefaService.Listar(APagina, ALimite: Integer; const AStatus: string; APrioridade: Integer; const AOrdem: string): TListaTarefasResponseDTO;
var
  LListaTarefas: TList<TTarefa>;
  LTarefa: TTarefa;
  LTotalItens: Integer;
begin
  // Validacoes Paginacao
  if APagina < 1 then APagina := 1;
  if ALimite < 1 then ALimite := 20;
  if ALimite > 100 then ALimite := 100;
  
  LListaTarefas := FRepository.Listar(APagina, ALimite, AStatus, APrioridade, AOrdem, LTotalItens);
  try
    Result := TListaTarefasResponseDTO.Create;
    
    for LTarefa in LListaTarefas do
      Result.Dados.Add(MapToResponseDTO(LTarefa));
      
    Result.Paginacao.PaginaAtual := APagina;
    Result.Paginacao.ItensPorPagina := ALimite;
    Result.Paginacao.TotalItens := LTotalItens;
    Result.Paginacao.TotalPaginas := Ceil(LTotalItens / ALimite);
  finally
    for LTarefa in LListaTarefas do
      LTarefa.Free;
    LListaTarefas.Free;
  end;
end;

function TTarefaService.ObterPorId(AId: Integer): TTarefaResponseDTO;
var
  LTarefa: TTarefa;
begin
  LTarefa := BuscarTarefaExistente(AId);
  try
    Result := MapToResponseDTO(LTarefa);
  finally
    LTarefa.Free;
  end;
end;

function TTarefaService.Criar(ADTO: TTarefaCreateDTO): TTarefaResponseDTO;
var
  LTarefa: TTarefa;
begin
  ValidarRegrasBasicas(ADTO.Titulo, ADTO.Descricao, ADTO.Prioridade);

  LTarefa := TTarefa.Create;
  try
    PreencherDadosTarefa(LTarefa, ADTO);
    // Status e DataCriacao sao preenchidos no Create da Entidade
    
    FRepository.Criar(LTarefa);
    Result := MapToResponseDTO(LTarefa);
  finally
    LTarefa.Free;
  end;
end;

function TTarefaService.Atualizar(AId: Integer; ADTO: TTarefaUpdateDTO): TTarefaResponseDTO;
var
  LTarefa: TTarefa;
begin
  ValidarRegrasBasicas(ADTO.Titulo, ADTO.Descricao, ADTO.Prioridade);

  LTarefa := BuscarTarefaExistente(AId);
  try
    PreencherDadosTarefa(LTarefa, ADTO);
    // Status não é atualizado aqui!
    
    FRepository.Atualizar(LTarefa);
    Result := MapToResponseDTO(LTarefa);
  finally
    LTarefa.Free;
  end;
end;

function TTarefaService.AtualizarStatus(AId: Integer; ADTO: TTarefaStatusDTO): TTarefaResponseDTO;
var
  LTarefa: TTarefa;
  LNovoStatus: TStatusTarefa;
begin
  try
    LNovoStatus := TStatusTarefa.FromString(ADTO.Status);
  except
    on E: Exception do
      raise EHorseException.New.Error('Status inválido.').Status(THTTPStatus.UnprocessableEntity);
  end;

  LTarefa := BuscarTarefaExistente(AId);
  try
    if not LTarefa.Status.PodeMudarPara(LNovoStatus) then
      raise EHorseException.New.Error(Format('Transição de status inválida: de %s para %s', [LTarefa.Status.ToString, ADTO.Status])).Status(THTTPStatus.UnprocessableEntity);
      
    LTarefa.Status := LNovoStatus;
    
    // Regra: Ao concluir preencher DataConclusao
    if LNovoStatus = stConcluida then
      LTarefa.DataConclusao := Now
    else
      LTarefa.DataConclusao := 0; // Se reabriu por exemplo
      
    FRepository.Atualizar(LTarefa); // Update salva as modificacoes
    Result := MapToResponseDTO(LTarefa);
  finally
    LTarefa.Free;
  end;
end;

procedure TTarefaService.Remover(AId: Integer);
var
  LTarefa: TTarefa;
begin
  LTarefa := BuscarTarefaExistente(AId);
  LTarefa.Free;
  
  FRepository.Remover(AId);
end;

function TTarefaService.ObterEstatisticas: TEstatisticasDTO;
var
  LTotal, LConcluidas: Integer;
  LMedia: Double;
begin
  FRepository.ObterEstatisticas(LTotal, LConcluidas, LMedia);
  
  Result := TEstatisticasDTO.Create;
  Result.TotalTarefas := LTotal;
  Result.MediaPrioridadePendentes := LMedia;
  Result.TarefasConcluidasUltimos7Dias := LConcluidas;
end;

end.
