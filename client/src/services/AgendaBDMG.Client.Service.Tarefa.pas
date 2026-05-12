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

function TTarefaApiService.Listar(APagina: Integer = 1; ALimite: Integer = 20; const AStatus: string = ''; APrioridade: Integer = 0; const AOrdem: string = ''): TListaTarefasResponseDTO;
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  LRequest := TRequest.New
    .BaseURL(FConfig.GetBaseUrl)
    .Resource('/api/tarefas')
    .AddHeader('X-API-KEY', FConfig.ApiKey)
    .AddParam('page', APagina.ToString)
    .AddParam('limit', ALimite.ToString);
    
  if AStatus <> '' then
    LRequest.AddParam('status', AStatus);
    
  if APrioridade > 0 then
    LRequest.AddParam('prioridade', APrioridade.ToString);
    
  if AOrdem <> '' then
    LRequest.AddParam('ordem', AOrdem);

  LResponse := LRequest.Get;

  if (LResponse.StatusCode >= 200) and (LResponse.StatusCode <= 299) then
    Result := TJson.JsonToObject<TListaTarefasResponseDTO>(LResponse.Content)
  else
    raise Exception.CreateFmt('Erro ao listar tarefas. Status: %d - %s', [LResponse.StatusCode, LResponse.Content]);
end;

function TTarefaApiService.ObterPorId(AId: Integer): TTarefaResponseDTO;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FConfig.GetBaseUrl)
    .Resource('/api/tarefas')
    .ResourceSuffix(AId.ToString)
    .AddHeader('X-API-KEY', FConfig.ApiKey)
    .Get;

  if (LResponse.StatusCode >= 200) and (LResponse.StatusCode <= 299) then
    Result := TJson.JsonToObject<TTarefaResponseDTO>(LResponse.Content)
  else
    raise Exception.CreateFmt('Erro ao obter tarefa. Status: %d - %s', [LResponse.StatusCode, LResponse.Content]);
end;

function TTarefaApiService.Criar(ADTO: TTarefaCreateDTO): TTarefaResponseDTO;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FConfig.GetBaseUrl)
    .Resource('/api/tarefas')
    .AddHeader('X-API-KEY', FConfig.ApiKey)
    .ContentType('application/json')
    .AddBody(TJson.ObjectToJsonString(ADTO))
    .Post;

  if (LResponse.StatusCode >= 200) and (LResponse.StatusCode <= 299) then
    Result := TJson.JsonToObject<TTarefaResponseDTO>(LResponse.Content)
  else
    raise Exception.CreateFmt('Erro ao criar tarefa. Status: %d - %s', [LResponse.StatusCode, LResponse.Content]);
end;

function TTarefaApiService.Atualizar(AId: Integer; ADTO: TTarefaUpdateDTO): TTarefaResponseDTO;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FConfig.GetBaseUrl)
    .Resource('/api/tarefas')
    .ResourceSuffix(AId.ToString)
    .AddHeader('X-API-KEY', FConfig.ApiKey)
    .ContentType('application/json')
    .AddBody(TJson.ObjectToJsonString(ADTO))
    .Put;

  if (LResponse.StatusCode >= 200) and (LResponse.StatusCode <= 299) then
    Result := TJson.JsonToObject<TTarefaResponseDTO>(LResponse.Content)
  else
    raise Exception.CreateFmt('Erro ao atualizar tarefa. Status: %d - %s', [LResponse.StatusCode, LResponse.Content]);
end;

function TTarefaApiService.AtualizarStatus(AId: Integer; ADTO: TTarefaStatusDTO): TTarefaResponseDTO;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FConfig.GetBaseUrl)
    .Resource(Format('/api/tarefas/%d/status', [AId]))
    .AddHeader('X-API-KEY', FConfig.ApiKey)
    .ContentType('application/json')
    .AddBody(TJson.ObjectToJsonString(ADTO))
    .Put;

  if (LResponse.StatusCode >= 200) and (LResponse.StatusCode <= 299) then
    Result := TJson.JsonToObject<TTarefaResponseDTO>(LResponse.Content)
  else
    raise Exception.CreateFmt('Erro ao atualizar status. Status: %d - %s', [LResponse.StatusCode, LResponse.Content]);
end;

procedure TTarefaApiService.Remover(AId: Integer);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FConfig.GetBaseUrl)
    .Resource('/api/tarefas')
    .ResourceSuffix(AId.ToString)
    .AddHeader('X-API-KEY', FConfig.ApiKey)
    .Delete;

  if not ((LResponse.StatusCode >= 200) and (LResponse.StatusCode <= 299)) then
    raise Exception.CreateFmt('Erro ao remover tarefa. Status: %d - %s', [LResponse.StatusCode, LResponse.Content]);
end;

function TTarefaApiService.ObterEstatisticas: TEstatisticasDTO;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FConfig.GetBaseUrl)
    .Resource('/api/estatisticas')
    .AddHeader('X-API-KEY', FConfig.ApiKey)
    .Get;

  if (LResponse.StatusCode >= 200) and (LResponse.StatusCode <= 299) then
    Result := TJson.JsonToObject<TEstatisticasDTO>(LResponse.Content)
  else
    raise Exception.CreateFmt('Erro ao obter estatísticas. Status: %d - %s', [LResponse.StatusCode, LResponse.Content]);
end;

end.
