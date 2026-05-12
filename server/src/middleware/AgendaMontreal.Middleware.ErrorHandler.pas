unit AgendaMontreal.Middleware.ErrorHandler;

interface

uses
  Horse;

procedure ErrorHandlerMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

uses
  System.SysUtils, Horse.Exception, Horse.Commons,
  AgendaMontreal.DTO.Tarefa, AgendaMontreal.Utils.Logger,
  REST.Json;

procedure ErrorHandlerMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LErroDTO: TErroResponseDTO;
  LStatus: THTTPStatus;
begin
  try
    Next();
  except
    on E: EHorseException do
    begin
      TLogger.Error(Format('[EHorseException] Status: %d - Message: %s', [E.Status.ToInteger, E.Message]));
      LStatus := E.Status;
      LErroDTO := TErroResponseDTO.Create(E.Message);
      try
        Res.Status(LStatus).Send(TJson.ObjectToJsonString(LErroDTO));
      finally
        LErroDTO.Free;
      end;
    end;
    on E: Exception do
    begin
      TLogger.Error(Format('[Exception] Message: %s', [E.Message]));
      LStatus := THTTPStatus.InternalServerError;
      LErroDTO := TErroResponseDTO.Create('Erro interno do servidor', E.Message);
      try
        Res.Status(LStatus).Send(TJson.ObjectToJsonString(LErroDTO));
      finally
        LErroDTO.Free;
      end;
    end;
  end;
end;

end.
