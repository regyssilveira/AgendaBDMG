unit AgendaBDMG.Client.Service.Tarefa;

interface

uses
  System.SysUtils, System.Classes, REST.Json, REST.Types,
  RESTRequest4D,
  AgendaBDMG.Client.Config,
  AgendaBDMG.Client.DTO;

type
  TTarefaApiService = class
  private
    FConfig: TClientConfig;
    function PrepararRequisicao(const ASubRota: string): IRequest;
    function ProcessarResposta<T: class>(AResponse: IResponse; const AMensagemErro: string): T;
  public
    constructor Create;
    
    function Listar(APagina: Integer = 1; ALimite: Integer = 20; const AStatus: string = ''; APrioridade: Integer = 0; const AOrdem: string = ''): TListaTarefasResponseDTO;
    function ObterPorId(AId: Integer): TTarefaResponseDTO;
    function Criar(ADTO: TTarefaCreateDTO): TTarefaResponseDTO;
    function Atualizar(AId: Integer; ADTO: TTarefaUpdateDTO): TTarefaResponseDTO;
    function AtualizarStatus(AId: Integer; ADTO: TTarefaStatusDTO): TTarefaResponseDTO;
    procedure Remover(AId: Integer);
    function ObterEstatisticas: TEstatisticasDTO;
  end;

implementation

{ TTarefaApiService }

constructor TTarefaApiService.Create;
begin
  FConfig := TClientConfig.GetInstance;
end;

function TTarefaApiService.PrepararRequisicao(const ASubRota: string): IRequest;
begin
  Result := TRequest.New
    .BaseURL(FConfig.GetBaseUrl)
    .Resource(ASubRota)
    .AddHeader('X-API-KEY', FConfig.ApiKey);
end;

function TTarefaApiService.ProcessarResposta<T>(AResponse: IResponse; const AMensagemErro: string): T;
begin
  if (AResponse.StatusCode >= 200) and (AResponse.StatusCode <= 299) then
    Result := TJson.JsonToObject<T>(AResponse.Content)
  else
    raise Exception.CreateFmt('%s Status: %d - %s', [AMensagemErro, AResponse.StatusCode, AResponse.Content]);
end;

function TTarefaApiService.Listar(APagina: Integer = 1; ALimite: Integer = 20; const AStatus: string = ''; APrioridade: Integer = 0; const AOrdem: string = ''): TListaTarefasResponseDTO;
var
  LRequest: IRequest;
begin
  LRequest := PrepararRequisicao('/api/tarefas')
    .AddParam('page', APagina.ToString)
    .AddParam('limit', ALimite.ToString);
    
  if AStatus <> '' then
    LRequest.AddParam('status', AStatus);
    
  if APrioridade > 0 then
    LRequest.AddParam('prioridade', APrioridade.ToString);
    
  if AOrdem <> '' then
    LRequest.AddParam('ordem', AOrdem);

  Result := ProcessarResposta<TListaTarefasResponseDTO>(LRequest.Get, 'Erro ao listar tarefas.');
end;

function TTarefaApiService.ObterPorId(AId: Integer): TTarefaResponseDTO;
begin
  Result := ProcessarResposta<TTarefaResponseDTO>(PrepararRequisicao('/api/tarefas/' + AId.ToString).Get, 'Erro ao obter tarefa.');
end;

function TTarefaApiService.Criar(ADTO: TTarefaCreateDTO): TTarefaResponseDTO;
var
  LRequest: IRequest;
begin
  LRequest := PrepararRequisicao('/api/tarefas')
    .ContentType('application/json')
    .AddBody(TJson.ObjectToJsonString(ADTO));
  Result := ProcessarResposta<TTarefaResponseDTO>(LRequest.Post, 'Erro ao criar tarefa.');
end;

function TTarefaApiService.Atualizar(AId: Integer; ADTO: TTarefaUpdateDTO): TTarefaResponseDTO;
var
  LRequest: IRequest;
begin
  LRequest := PrepararRequisicao('/api/tarefas/' + AId.ToString)
    .ContentType('application/json')
    .AddBody(TJson.ObjectToJsonString(ADTO));
  Result := ProcessarResposta<TTarefaResponseDTO>(LRequest.Put, 'Erro ao atualizar tarefa.');
end;

function TTarefaApiService.AtualizarStatus(AId: Integer; ADTO: TTarefaStatusDTO): TTarefaResponseDTO;
var
  LRequest: IRequest;
begin
  LRequest := PrepararRequisicao(Format('/api/tarefas/%d/status', [AId]))
    .ContentType('application/json')
    .AddBody(TJson.ObjectToJsonString(ADTO));
  Result := ProcessarResposta<TTarefaResponseDTO>(LRequest.Put, 'Erro ao atualizar status.');
end;

procedure TTarefaApiService.Remover(AId: Integer);
var
  LResponse: IResponse;
begin
  LResponse := PrepararRequisicao('/api/tarefas/' + AId.ToString).Delete;
  if not ((LResponse.StatusCode >= 200) and (LResponse.StatusCode <= 299)) then
    raise Exception.CreateFmt('Erro ao remover tarefa. Status: %d - %s', [LResponse.StatusCode, LResponse.Content]);
end;

function TTarefaApiService.ObterEstatisticas: TEstatisticasDTO;
begin
  Result := ProcessarResposta<TEstatisticasDTO>(PrepararRequisicao('/api/estatisticas').Get, 'Erro ao obter estatísticas.');
end;

end.
