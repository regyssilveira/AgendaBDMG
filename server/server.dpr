program server;

{$APPTYPE CONSOLE}

uses
  Horse,
  System.SysUtils,
  AgendaMontreal.Utils.Config in 'src\utils\AgendaMontreal.Utils.Config.pas',
  AgendaMontreal.Utils.Logger in 'src\utils\AgendaMontreal.Utils.Logger.pas',
  AgendaMontreal.Utils.Json in 'src\utils\AgendaMontreal.Utils.Json.pas',
  AgendaMontreal.Model.Tarefa in 'src\model\AgendaMontreal.Model.Tarefa.pas',
  AgendaMontreal.Interfaces in 'src\interfaces\AgendaMontreal.Interfaces.pas',
  AgendaMontreal.DTO.Tarefa in 'src\dto\AgendaMontreal.DTO.Tarefa.pas',
  AgendaMontreal.Database.Connection in 'src\database\AgendaMontreal.Database.Connection.pas',
  AgendaMontreal.Repository.Tarefa in 'src\repository\AgendaMontreal.Repository.Tarefa.pas',
  AgendaMontreal.Service.Tarefa in 'src\service\AgendaMontreal.Service.Tarefa.pas',
  AgendaMontreal.Factory.Connection in 'src\factory\AgendaMontreal.Factory.Connection.pas',
  AgendaMontreal.Factory.Repository in 'src\factory\AgendaMontreal.Factory.Repository.pas',
  AgendaMontreal.Factory.Service in 'src\factory\AgendaMontreal.Factory.Service.pas',
  AgendaMontreal.Middleware.Auth in 'src\middleware\AgendaMontreal.Middleware.Auth.pas',
  AgendaMontreal.Middleware.ErrorHandler in 'src\middleware\AgendaMontreal.Middleware.ErrorHandler.pas',
  AgendaMontreal.Middleware.Logger in 'src\middleware\AgendaMontreal.Middleware.Logger.pas',
  AgendaMontreal.Controller.Health in 'src\controller\AgendaMontreal.Controller.Health.pas',
  AgendaMontreal.Controller.Tarefa in 'src\controller\AgendaMontreal.Controller.Tarefa.pas',
  AgendaMontreal.Controller.Estatistica in 'src\controller\AgendaMontreal.Controller.Estatistica.pas';

var
  LPort: Integer;
begin
  try
    // Middlewares
    THorse.Use(AgendaMontreal.Middleware.Logger.LoggerMiddleware);
    THorse.Use(AgendaMontreal.Middleware.Auth.AuthMiddleware);
    THorse.Use(AgendaMontreal.Middleware.ErrorHandler.ErrorHandlerMiddleware);

    // Controllers
    AgendaMontreal.Controller.Health.Registry;
    AgendaMontreal.Controller.Tarefa.Registry;
    AgendaMontreal.Controller.Estatistica.Registry;

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
