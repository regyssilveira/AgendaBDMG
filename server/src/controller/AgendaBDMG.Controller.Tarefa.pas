unit AgendaBDMG.Controller.Tarefa;

interface

procedure Registry;

implementation

uses
  Horse, Horse.GBSwagger, Horse.Commons, System.SysUtils, REST.Json,
  GBSwagger.Path.Attributes,
  AgendaBDMG.Factory.Service, AgendaBDMG.DTO.Tarefa, AgendaBDMG.Interfaces;

type
  [SwagPath('tarefas', 'Tarefas')]
  TTarefaController = class(THorseGBSwagger)
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);
    [SwagGET('', 'Listar Tarefas', False, 'Retorna uma lista paginada de tarefas com possibilidade de filtros e ordenacao.')]
    [SwagParamHeader('X-API-KEY', 'Chave de API', True)]
    [SwagParamQuery('page', 'Numero da pagina', False, True)]
    [SwagParamQuery('limit', 'Itens por pagina', False, True)]
    [SwagParamQuery('status', 'Filtrar por status da tarefa')]
    [SwagParamQuery('prioridade', 'Filtrar por prioridade (1 a 5)', False, True)]
    [SwagParamQuery('ordem', 'Ordenacao (ex: dataCriacao_desc, prioridade_asc)')]
    [SwagResponse(200, TListaTarefasResponseDTO, 'Lista retornada com sucesso')]
    [SwagResponse(401, TErroResponseDTO, 'Nao autorizado')]
    procedure GetTarefas;

    [SwagGET(':id', 'Obter Tarefa', False, 'Retorna os detalhes de uma unica tarefa baseada no ID informado.')]
    [SwagParamHeader('X-API-KEY', 'Chave de API', True)]
    [SwagParamPath('id', 'ID numerico da Tarefa', True)]
    [SwagResponse(200, TTarefaResponseDTO, 'Tarefa encontrada com sucesso')]
    [SwagResponse(404, TErroResponseDTO, 'Tarefa nao encontrada')]
    [SwagResponse(401, TErroResponseDTO, 'Nao autorizado')]
    procedure GetTarefaPorId;

    [SwagPOST('', 'Criar Tarefa', False, 'Cadastra uma nova tarefa no banco de dados.')]
    [SwagParamHeader('X-API-KEY', 'Chave de API', True)]
    [SwagParamBody('body', TTarefaCreateDTO, 'Dados da nova tarefa', False, True)]
    [SwagResponse(201, TTarefaResponseDTO, 'Tarefa criada com sucesso')]
    [SwagResponse(400, TErroResponseDTO, 'Erro de validacao')]
    [SwagResponse(401, TErroResponseDTO, 'Nao autorizado')]
    procedure PostTarefa;

    [SwagPUT(':id', 'Atualizar Tarefa', False, 'Atualiza completamente os dados de uma tarefa existente.')]
    [SwagParamHeader('X-API-KEY', 'Chave de API', True)]
    [SwagParamPath('id', 'ID numerico da Tarefa', True)]
    [SwagParamBody('body', TTarefaUpdateDTO, 'Dados atualizados da tarefa', False, True)]
    [SwagResponse(200, TTarefaResponseDTO, 'Tarefa atualizada com sucesso')]
    [SwagResponse(404, TErroResponseDTO, 'Tarefa nao encontrada')]
    [SwagResponse(400, TErroResponseDTO, 'Erro de validacao')]
    [SwagResponse(401, TErroResponseDTO, 'Nao autorizado')]
    procedure PutTarefa;

    [SwagPUT(':id/status', 'Atualizar Status', False, 'Avanca ou altera apenas o status da tarefa atraves da maquina de estados.')]
    [SwagParamHeader('X-API-KEY', 'Chave de API', True)]
    [SwagParamPath('id', 'ID numerico da Tarefa', True)]
    [SwagParamBody('body', TTarefaStatusDTO, 'Novo status', False, True)]
    [SwagResponse(200, TTarefaResponseDTO, 'Status atualizado com sucesso')]
    [SwagResponse(404, TErroResponseDTO, 'Tarefa nao encontrada')]
    [SwagResponse(400, TErroResponseDTO, 'Transicao invalida ou Erro de validacao')]
    [SwagResponse(401, TErroResponseDTO, 'Nao autorizado')]
    procedure PutTarefaStatus;

    [SwagDELETE(':id', 'Excluir Tarefa', False, 'Remove definitivamente uma tarefa do sistema.')]
    [SwagParamHeader('X-API-KEY', 'Chave de API', True)]
    [SwagParamPath('id', 'ID numerico da Tarefa', True)]
    [SwagResponse(200, TSucessoResponseDTO, 'Tarefa excluida com sucesso')]
    [SwagResponse(404, TErroResponseDTO, 'Tarefa nao encontrada')]
    [SwagResponse(401, TErroResponseDTO, 'Nao autorizado')]
    procedure DeleteTarefa;
  end;

{ TTarefaController }

constructor TTarefaController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  inherited Create(Req, Res);
end;

procedure TTarefaController.GetTarefas;
var
  LService: ITarefaService;
  LPagina, LLimite, LPrioridade: Integer;
  LStatus, LOrdem: string;
  LResponse: TListaTarefasResponseDTO;
begin
  LPagina := StrToIntDef(FRequest.Query['page'], 1);
  LLimite := StrToIntDef(FRequest.Query['limit'], 20);
  LStatus := FRequest.Query['status'];
  LPrioridade := StrToIntDef(FRequest.Query['prioridade'], 0);
  LOrdem := FRequest.Query['ordem'];
  if LOrdem = '' then LOrdem := 'dataCriacao_desc';

  LService := TFabricaService.Tarefa;
  LResponse := LService.Listar(LPagina, LLimite, LStatus, LPrioridade, LOrdem);
  try
    FResponse.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
  finally
    LResponse.Free;
  end;
end;

procedure TTarefaController.GetTarefaPorId;
var
  LService: ITarefaService;
  LResponse: TTarefaResponseDTO;
  LId: Integer;
begin
  LId := StrToIntDef(FRequest.Params['id'], 0);
  LService := TFabricaService.Tarefa;
  LResponse := LService.ObterPorId(LId);
  try
    FResponse.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
  finally
    LResponse.Free;
  end;
end;

procedure TTarefaController.PostTarefa;
var
  LService: ITarefaService;
  LDTO: TTarefaCreateDTO;
  LResponse: TTarefaResponseDTO;
begin
  LDTO := TJson.JsonToObject<TTarefaCreateDTO>(FRequest.Body);
  try
    LService := TFabricaService.Tarefa;
    LResponse := LService.Criar(LDTO);
    try
      FResponse.Status(THTTPStatus.Created).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
    finally
      LResponse.Free;
    end;
  finally
    LDTO.Free;
  end;
end;

procedure TTarefaController.PutTarefa;
var
  LService: ITarefaService;
  LDTO: TTarefaUpdateDTO;
  LResponse: TTarefaResponseDTO;
  LId: Integer;
begin
  LId := StrToIntDef(FRequest.Params['id'], 0);
  LDTO := TJson.JsonToObject<TTarefaUpdateDTO>(FRequest.Body);
  try
    LService := TFabricaService.Tarefa;
    LResponse := LService.Atualizar(LId, LDTO);
    try
      FResponse.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
    finally
      LResponse.Free;
    end;
  finally
    LDTO.Free;
  end;
end;

procedure TTarefaController.PutTarefaStatus;
var
  LService: ITarefaService;
  LDTO: TTarefaStatusDTO;
  LResponse: TTarefaResponseDTO;
  LId: Integer;
begin
  LId := StrToIntDef(FRequest.Params['id'], 0);
  LDTO := TJson.JsonToObject<TTarefaStatusDTO>(FRequest.Body);
  try
    LService := TFabricaService.Tarefa;
    LResponse := LService.AtualizarStatus(LId, LDTO);
    try
      FResponse.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
    finally
      LResponse.Free;
    end;
  finally
    LDTO.Free;
  end;
end;

procedure TTarefaController.DeleteTarefa;
var
  LService: ITarefaService;
  LId: Integer;
  LResponse: TSucessoResponseDTO;
begin
  LId := StrToIntDef(FRequest.Params['id'], 0);
  LService := TFabricaService.Tarefa;
  LService.Remover(LId);
  
  LResponse := TSucessoResponseDTO.Create('Tarefa removida com sucesso');
  try
    FResponse.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
  finally
    LResponse.Free;
  end;
end;

procedure Registry;
begin
  THorseGBSwaggerRegister.RegisterPath(TTarefaController);
end;

end.
