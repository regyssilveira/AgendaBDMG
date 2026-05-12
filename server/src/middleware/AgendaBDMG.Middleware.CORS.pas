unit AgendaBDMG.Middleware.CORS;

interface

uses
  Horse, Horse.Commons, System.SysUtils;

procedure CORSMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure CORSMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.RawWebResponse.SetCustomHeader('Access-Control-Allow-Origin', '*');
  Res.RawWebResponse.SetCustomHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  Res.RawWebResponse.SetCustomHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-API-KEY');
  
  if UpperCase(Req.RawWebRequest.Method) = 'OPTIONS' then
  begin
    Res.Status(THTTPStatus.NoContent);
    Exit;
  end;

  Next();
end;

end.
