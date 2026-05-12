program client;

uses
  Vcl.Forms,
  AgendaBDMG.Client.Form.Principal in 'src\forms\AgendaBDMG.Client.Form.Principal.pas' {frmPrincipal},
  AgendaBDMG.Client.Form.Tarefa in 'src\forms\AgendaBDMG.Client.Form.Tarefa.pas' {frmTarefa},
  AgendaBDMG.Client.Form.Status in 'src\forms\AgendaBDMG.Client.Form.Status.pas' {frmStatus},
  AgendaBDMG.Client.Config in 'src\utils\AgendaBDMG.Client.Config.pas',
  AgendaBDMG.Client.Utils in 'src\utils\AgendaBDMG.Client.Utils.pas',
  AgendaBDMG.Client.DTO in 'src\dto\AgendaBDMG.Client.DTO.pas',
  AgendaBDMG.Client.Service.Tarefa in 'src\services\AgendaBDMG.Client.Service.Tarefa.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  
  // Inicializa configuração
  AgendaBDMG.Client.Config.TClientConfig.GetInstance;
  
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
