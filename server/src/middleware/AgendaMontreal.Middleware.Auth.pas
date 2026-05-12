unit AgendaMontreal.Middleware.Auth;

interface

uses
  Horse, Horse.Commons, System.SysUtils, AgendaMontreal.Utils.Config;

procedure AuthMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

uses
  Horse.Exception;

procedure AuthMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LConfig: TServerConfig;
  LApiKeyHeader: string;
begin
  // Ignora auth para o health check
  if Trim(Req.RawWebRequest.PathInfo) = '/api/health' then
  begin
    Next();
    Exit;
  end;

  LConfig := TServerConfig.GetInstance;
  LApiKeyHeader := Req.Headers['X-API-KEY'];

  if LApiKeyHeader = '' then
  begin
    Res.Status(THTTPStatus.Unauthorized).Send('{"sucesso":false,"mensagem":"API Key não fornecida","detalhes":null}');
    Exit;
  end;

  if LApiKeyHeader <> LConfig.ApiKey then
  begin
    Res.Status(THTTPStatus.Unauthorized).Send('{"sucesso":false,"mensagem":"API Key inválida","detalhes":null}');
    Exit;
  end;

  Next();
end;

end.
