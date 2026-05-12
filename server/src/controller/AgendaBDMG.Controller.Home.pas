unit AgendaBDMG.Controller.Home;

interface

uses
  Horse;

procedure Registry;

implementation

uses
  Horse.Commons, System.SysUtils, AgendaBDMG.Utils.Config;

procedure GetHome(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LHTML: string;
  LConfig: TServerConfig;
begin
  LConfig := TServerConfig.GetInstance;
  
  LHTML := 
    '<!DOCTYPE html>' +
    '<html lang="pt-BR">' +
    '<head>' +
    '    <meta charset="UTF-8">' +
    '    <meta name="viewport" content="width=device-width, initial-scale=1.0">' +
    '    <title>Agenda BDMG - API</title>' +
    '    <style>' +
    '        body { font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: #0f172a; color: #f8fafc; margin: 0; padding: 40px; display: flex; justify-content: center; align-items: center; min-height: 100vh; }' +
    '        .card { background-color: #1e293b; border-radius: 12px; padding: 40px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); max-width: 600px; width: 100%; text-align: center; border-top: 4px solid #3b82f6; }' +
    '        h1 { margin-top: 0; color: #60a5fa; font-size: 28px; }' +
    '        p { line-height: 1.6; color: #cbd5e1; }' +
    '        .btn { display: inline-block; background-color: #3b82f6; color: white; text-decoration: none; padding: 12px 24px; border-radius: 6px; font-weight: bold; margin-top: 20px; transition: background-color 0.2s; }' +
    '        .btn:hover { background-color: #2563eb; }' +
    '        .info { text-align: left; background: #0f172a; padding: 20px; border-radius: 8px; margin-top: 30px; font-family: monospace; }' +
    '        .info p { margin: 5px 0; color: #94a3b8; }' +
    '        .info span { color: #38bdf8; }' +
    '    </style>' +
    '</head>' +
    '<body>' +
    '    <div class="card">' +
    '        <h1>&#128640; Agenda BDMG - Backend Ativo</h1>' +
    '        <p>Bem-vindo! O servidor REST da Agenda BDMG est&aacute; online e processando requisi&ccedil;&otilde;es corretamente.</p>' +
    '        <a href="/swagger/doc/html" class="btn">Visualizar Swagger UI</a>' +
    '        <div class="info">' +
    '            <p>Status: <span>ONLINE</span></p>' +
    '            <p>Database: <span>' + LConfig.DatabaseName + '</span></p>' +
    '            <p>Vers&atilde;o API: <span>1.0.0</span></p>' +
    '        </div>' +
    '    </div>' +
    '</body>' +
    '</html>';

  Res.Status(THTTPStatus.OK).ContentType('text/html; charset=UTF-8').Send(LHTML);
end;

procedure Registry;
begin
  THorse.Get('/api', GetHome);
  THorse.Get('/api/', GetHome);
end;

end.
