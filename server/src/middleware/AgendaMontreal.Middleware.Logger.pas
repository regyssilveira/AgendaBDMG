unit AgendaMontreal.Middleware.Logger;

interface

uses
  Horse, System.SysUtils, System.Diagnostics;

procedure LoggerMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

uses
  AgendaMontreal.Utils.Logger;

procedure LoggerMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LStopwatch: TStopwatch;
  LMethod, LPath: string;
begin
  LStopwatch := TStopwatch.StartNew;
  LMethod := Req.RawWebRequest.Method;
  LPath := Req.RawWebRequest.PathInfo;
  
  try
    Next();
  finally
    LStopwatch.Stop;
    TLogger.Info(Format('%s %s - Status: %d - %d ms', [LMethod, LPath, Res.Status, LStopwatch.ElapsedMilliseconds]));
  end;
end;

end.
