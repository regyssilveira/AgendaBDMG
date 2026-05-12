unit AgendaMontreal.Controller.Estatistica;

interface

uses
  Horse;

procedure Registry;

implementation

uses
  Horse.Commons, System.SysUtils, REST.Json,
  AgendaMontreal.Factory.Service, AgendaMontreal.DTO.Tarefa, AgendaMontreal.Interfaces;

procedure GetEstatisticas(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LService: ITarefaService;
  LResponse: TEstatisticasDTO;
begin
  LService := TFabricaService.Tarefa;
  LResponse := LService.ObterEstatisticas;
  try
    Res.Status(THTTPStatus.OK).ContentType('application/json').Send(TJson.ObjectToJsonString(LResponse));
  finally
    LResponse.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/api/estatisticas', GetEstatisticas);
end;

end.
