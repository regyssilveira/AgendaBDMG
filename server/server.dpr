program server;

{$APPTYPE CONSOLE}

uses
  Horse,
  System.SysUtils,
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
  AgendaBDMG.Controller.Estatistica in 'src\controller\AgendaBDMG.Controller.Estatistica.pas';

var
  LPort: Integer;
begin
  try
    // Middlewares
    THorse.Use(AgendaBDMG.Middleware.Logger.LoggerMiddleware);
    THorse.Use(AgendaBDMG.Middleware.Auth.AuthMiddleware);
    THorse.Use(AgendaBDMG.Middleware.ErrorHandler.ErrorHandlerMiddleware);

    // Controllers
    AgendaBDMG.Controller.Health.Registry;
    AgendaBDMG.Controller.Tarefa.Registry;
    AgendaBDMG.Controller.Estatistica.Registry;

    LPort := TServerConfig.GetInstance.ServerPort;

    THorse.Listen(LPort, 
      procedure 
      begin 
        Writeln(Format('Server running on port %d', [LPort])); 
        Writeln('Press ENTER to exit...');
      end);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
