unit AgendaMontreal.Controller.Health;

interface

uses
  Horse;

procedure Registry;

implementation

uses
  Horse.Commons, AgendaMontreal.Utils.Json, System.SysUtils;

procedure GetHealth(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LStatus: string;
begin
  LStatus := Format('{"status":"UP","timestamp":"%s","version":"1.0.0"}', [TJsonUtils.DateTimeToISO8601(Now)]);
  Res.Status(THTTPStatus.OK).ContentType('application/json').Send(LStatus);
end;

procedure Registry;
begin
  THorse.Get('/api/health', GetHealth);
end;

end.
