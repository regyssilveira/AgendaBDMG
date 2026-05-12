unit AgendaBDMG.Controller.Estatistica;

interface

procedure Registry;

implementation

uses
  Horse, Horse.GBSwagger, Horse.Commons, System.SysUtils, REST.Json,
  GBSwagger.Path.Attributes,
  AgendaBDMG.Factory.Service, AgendaBDMG.DTO.Tarefa, AgendaBDMG.Interfaces;

type
  [SwagPath('estatisticas', 'Estatisticas')]
  TEstatisticaController = class(THorseGBSwagger)
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);
    [SwagGET('', 'Dashboard de Estatisticas', False, 'Retorna as estatisticas consolidadas de todas as tarefas cadastradas.')]
    [SwagParamHeader('X-API-KEY', 'Chave de API', True)]
    [SwagResponse(200, TEstatisticasDTO, 'Estatisticas retornadas com sucesso')]
    [SwagResponse(401, TErroResponseDTO, 'Nao autorizado')]
    procedure GetEstatisticas;
  end;

{ TEstatisticaController }

constructor TEstatisticaController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  inherited Create(Req, Res);
end;

procedure TEstatisticaController.GetEstatisticas;
var
  LService: ITarefaService;
  LResponse: TEstatisticasDTO;
begin
  LService := TFabricaService.Tarefa;
  LResponse := LService.ObterEstatisticas;
  try
    FResponse.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
  finally
    LResponse.Free;
  end;
end;

procedure Registry;
begin
  THorseGBSwaggerRegister.RegisterPath(TEstatisticaController);
end;

end.
