program client;

uses
  Vcl.Forms,
  AgendaMontreal.Client.Form.Principal in 'src\forms\AgendaMontreal.Client.Form.Principal.pas' {frmPrincipal},
  AgendaMontreal.Client.Form.Tarefa in 'src\forms\AgendaMontreal.Client.Form.Tarefa.pas' {frmTarefa},
  AgendaMontreal.Client.Form.Status in 'src\forms\AgendaMontreal.Client.Form.Status.pas' {frmStatus},
  AgendaMontreal.Client.Config in 'src\utils\AgendaMontreal.Client.Config.pas',
  AgendaMontreal.Client.Utils in 'src\utils\AgendaMontreal.Client.Utils.pas',
  AgendaMontreal.Client.DTO in 'src\dto\AgendaMontreal.Client.DTO.pas',
  AgendaMontreal.Client.Service.Tarefa in 'src\services\AgendaMontreal.Client.Service.Tarefa.pas';

// {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  
  // Inicializa configuração
  AgendaMontreal.Client.Config.TClientConfig.GetInstance;
  
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
