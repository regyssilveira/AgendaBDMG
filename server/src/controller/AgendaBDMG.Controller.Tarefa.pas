unit AgendaBDMG.Controller.Tarefa;

interface

uses
  Horse;

procedure Registry;

implementation

uses
  Horse.Commons, System.SysUtils, REST.Json,
  AgendaBDMG.Factory.Service, AgendaBDMG.DTO.Tarefa, AgendaBDMG.Interfaces;

procedure GetTarefas(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LService: ITarefaService;
  LPagina, LLimite, LPrioridade: Integer;
  LStatus, LOrdem: string;
  LResponse: TListaTarefasResponseDTO;
begin
  LPagina := StrToIntDef(Req.Query['page'], 1);
  LLimite := StrToIntDef(Req.Query['limit'], 20);
  LStatus := Req.Query['status'];
  LPrioridade := StrToIntDef(Req.Query['prioridade'], 0);
  LOrdem := Req.Query['ordem'];
  if LOrdem = '' then LOrdem := 'dataCriacao_desc';

  LService := TFabricaService.Tarefa;
  LResponse := LService.Listar(LPagina, LLimite, LStatus, LPrioridade, LOrdem);
  try
    Res.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
  finally
    LResponse.Free;
  end;
end;

procedure GetTarefaPorId(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LService: ITarefaService;
  LResponse: TTarefaResponseDTO;
  LId: Integer;
begin
  LId := StrToIntDef(Req.Params['id'], 0);
  LService := TFabricaService.Tarefa;
  LResponse := LService.ObterPorId(LId);
  try
    Res.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
  finally
    LResponse.Free;
  end;
end;

procedure PostTarefa(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LService: ITarefaService;
  LDTO: TTarefaCreateDTO;
  LResponse: TTarefaResponseDTO;
begin
  LDTO := TJson.JsonToObject<TTarefaCreateDTO>(Req.Body);
  try
    LService := TFabricaService.Tarefa;
    LResponse := LService.Criar(LDTO);
    try
      Res.Status(THTTPStatus.Created).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
    finally
      LResponse.Free;
    end;
  finally
    LDTO.Free;
  end;
end;

procedure PutTarefa(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LService: ITarefaService;
  LDTO: TTarefaUpdateDTO;
  LResponse: TTarefaResponseDTO;
  LId: Integer;
begin
  LId := StrToIntDef(Req.Params['id'], 0);
  LDTO := TJson.JsonToObject<TTarefaUpdateDTO>(Req.Body);
  try
    LService := TFabricaService.Tarefa;
    LResponse := LService.Atualizar(LId, LDTO);
    try
      Res.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
    finally
      LResponse.Free;
    end;
  finally
    LDTO.Free;
  end;
end;

procedure PutTarefaStatus(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LService: ITarefaService;
  LDTO: TTarefaStatusDTO;
  LResponse: TTarefaResponseDTO;
  LId: Integer;
begin
  LId := StrToIntDef(Req.Params['id'], 0);
  LDTO := TJson.JsonToObject<TTarefaStatusDTO>(Req.Body);
  try
    LService := TFabricaService.Tarefa;
    LResponse := LService.AtualizarStatus(LId, LDTO);
    try
      Res.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
    finally
      LResponse.Free;
    end;
  finally
    LDTO.Free;
  end;
end;

procedure DeleteTarefa(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LService: ITarefaService;
  LId: Integer;
  LResponse: TSucessoResponseDTO;
begin
  LId := StrToIntDef(Req.Params['id'], 0);
  LService := TFabricaService.Tarefa;
  LService.Remover(LId);
  
  LResponse := TSucessoResponseDTO.Create('Tarefa removida com sucesso');
  try
    Res.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
  finally
    LResponse.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/api/tarefas', GetTarefas);
  THorse.Get('/api/tarefas/:id', GetTarefaPorId);
  THorse.Post('/api/tarefas', PostTarefa);
  THorse.Put('/api/tarefas/:id', PutTarefa);
  THorse.Put('/api/tarefas/:id/status', PutTarefaStatus);
  THorse.Delete('/api/tarefas/:id', DeleteTarefa);
end;

end.
