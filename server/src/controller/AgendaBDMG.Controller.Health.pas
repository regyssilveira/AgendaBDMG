unit AgendaBDMG.Controller.Health;

interface

procedure Registry;

implementation

uses
  Horse, Horse.GBSwagger, Horse.Commons, AgendaBDMG.Utils.Json, System.SysUtils,
  GBSwagger.Path.Attributes;

type
  [SwagPath('health', 'Monitoramento')]
  THealthController = class(THorseGBSwagger)
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);
    [SwagGET('', 'Health Check', False, 'Verifica se a API esta online e respondendo adequadamente.')]
    [SwagResponse(200, 'Objeto JSON contendo o status, timestamp e versao.')]
    procedure GetHealth;
  end;

{ THealthController }

constructor THealthController.Create(Req: THorseRequest; Res: THorseResponse);
begin
  inherited Create(Req, Res);
end;

procedure THealthController.GetHealth;
var
  LStatus: string;
begin
  LStatus := Format('{"status":"UP","timestamp":"%s","version":"1.0.0"}', [TJsonUtils.DateTimeToISO8601(Now)]);
  FResponse.Status(THTTPStatus.OK).ContentType('application/json').Send(LStatus);
end;

procedure Registry;
begin
  THorseGBSwaggerRegister.RegisterPath(THealthController);
end;

end.
