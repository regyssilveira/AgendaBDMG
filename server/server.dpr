program server;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Attributes,
  GBSwagger.Model.Interfaces,
  System.SysUtils,
  Winapi.Windows,
  AgendaBDMG.Utils.Config in 'src\utils\AgendaBDMG.Utils.Config.pas',
  AgendaBDMG.Utils.Logger in 'src\utils\AgendaBDMG.Utils.Logger.pas',
  AgendaBDMG.Utils.Json in 'src\utils\AgendaBDMG.Utils.Json.pas',
  AgendaBDMG.Model.Tarefa in 'src\model\AgendaBDMG.Model.Tarefa.pas',
  AgendaBDMG.Interfaces in 'src\interfaces\AgendaBDMG.Interfaces.pas',
  AgendaBDMG.DTO.Tarefa in 'src\dto\AgendaBDMG.DTO.Tarefa.pas',
  AgendaBDMG.Database.Connection in 'src\database\AgendaBDMG.Database.Connection.pas',
  AgendaBDMG.Repository.Tarefa in 'src\repository\AgendaBDMG.Repository.Tarefa.pas',
  AgendaBDMG.Service.Tarefa in 'src\service\AgendaBDMG.Service.Tarefa.pas',
  AgendaBDMG.Factory.Connection in 'src\factory\AgendaBDMG.Factory.Connection.pas',
  AgendaBDMG.Factory.Repository in 'src\factory\AgendaBDMG.Factory.Repository.pas',
  AgendaBDMG.Factory.Service in 'src\factory\AgendaBDMG.Factory.Service.pas',
  AgendaBDMG.Middleware.Auth in 'src\middleware\AgendaBDMG.Middleware.Auth.pas',
  AgendaBDMG.Middleware.ErrorHandler in 'src\middleware\AgendaBDMG.Middleware.ErrorHandler.pas',
  AgendaBDMG.Middleware.Logger in 'src\middleware\AgendaBDMG.Middleware.Logger.pas',
  AgendaBDMG.Controller.Health in 'src\controller\AgendaBDMG.Controller.Health.pas',
  AgendaBDMG.Controller.Tarefa in 'src\controller\AgendaBDMG.Controller.Tarefa.pas',
  AgendaBDMG.Controller.Estatistica in 'src\controller\AgendaBDMG.Controller.Estatistica.pas',
  AgendaBDMG.Controller.Home in 'src\controller\AgendaBDMG.Controller.Home.pas';

var
  LPort: Integer;
begin
  try
    // Swagger Meta
    Swagger
      .BasePath('/api')
      .Info
        .Title('Agenda BDMG API')
        .Version('1.0.0')
        .Description('API do sistema de gerenciamento de tarefas');


    // Middlewares
    THorse.Use(AgendaBDMG.Middleware.Logger.LoggerMiddleware);
    THorse.Use(AgendaBDMG.Middleware.Auth.AuthMiddleware);
    THorse.Use(AgendaBDMG.Middleware.ErrorHandler.ErrorHandlerMiddleware);
    THorse.Use(HorseSwagger);

    // Controllers
    AgendaBDMG.Controller.Health.Registry;
    AgendaBDMG.Controller.Tarefa.Registry;
    AgendaBDMG.Controller.Estatistica.Registry;
    AgendaBDMG.Controller.Home.Registry;

    LPort := TServerConfig.GetInstance.ServerPort;

    IsConsole := False;
    THorse.Listen(LPort, 
      procedure 
      var
        LConfig: TServerConfig;
      begin 
        LConfig := TServerConfig.GetInstance;
        Writeln('');
        Writeln('=============================================================');
        Writeln('            AGENDA BDMG - SERVIDOR BACKEND (API)             ');
        Writeln('=============================================================');
        Writeln(Format(' [v] Status     : ONLINE na porta %d', [LPort])); 
        Writeln(Format(' [v] Base URL   : http://localhost:%d/api', [LPort]));
        Writeln(Format(' [v] Swagger UI : http://localhost:%d/swagger/doc/html', [LPort]));
        Writeln('-------------------------------------------------------------');
        Writeln('                CONEXAO COM BANCO DE DADOS                   ');
        Writeln('-------------------------------------------------------------');
        Writeln(Format(' [ ] Driver     : %s', [LConfig.DatabaseDriver]));
        Writeln(Format(' [ ] Servidor   : %s:%d', [LConfig.DatabaseServer, LConfig.DatabasePort]));
        Writeln(Format(' [ ] Database   : %s', [LConfig.DatabaseName]));
        Writeln(Format(' [ ] Usuario    : %s', [LConfig.DatabaseUsername]));
        Writeln(' [v] FireDAC    : Connection Pooling Ativo (Max 50 Conexoes)');
        Writeln('=============================================================');
        Writeln(' Pressione ESC para encerrar o servidor...                   ');
        Writeln('=============================================================');
      end);

    while True do
    begin
      if (GetAsyncKeyState(VK_ESCAPE) and $8000) <> 0 then
      begin
        THorse.StopListen;
        Break;
      end;
      Sleep(100);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
