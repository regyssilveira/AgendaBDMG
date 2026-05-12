unit AgendaMontreal.Client.Form.Status;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmStatus = class(TForm)
    lblTarefaInfo: TLabel;
    lblNovoStatus: TLabel;
    cbbStatus: TComboBox;
    pnlBottom: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FStatusAtual: string;
    FTarefaId: Integer;
    FTarefaTitulo: string;
    FNovoStatus: string;
    
    procedure LoadData(AId: Integer; const ATitulo, AStatusAtual: string);
  end;

var
  frmStatus: TfrmStatus;

implementation

uses
  AgendaMontreal.Client.Utils;

{$R *.dfm}

{ TfrmStatus }

procedure TfrmStatus.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmStatus.btnSalvarClick(Sender: TObject);
begin
  if cbbStatus.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um status.');
    Exit;
  end;
  
  FNovoStatus := TClientUtils.StringToStatus(cbbStatus.Text);
  ModalResult := mrOk;
end;

procedure TfrmStatus.FormShow(Sender: TObject);
begin
  lblTarefaInfo.Caption := Format('Tarefa #%d: %s', [FTarefaId, FTarefaTitulo]);
  
  cbbStatus.Items.Clear;
  
  // Preencher apenas transições válidas
  if TClientUtils.PodeMudarStatus(FStatusAtual, 'PENDENTE') then
    cbbStatus.Items.Add('Pendente');
  if TClientUtils.PodeMudarStatus(FStatusAtual, 'EM_ANDAMENTO') then
    cbbStatus.Items.Add('Em Andamento');
  if TClientUtils.PodeMudarStatus(FStatusAtual, 'CONCLUIDA') then
    cbbStatus.Items.Add('Concluída');
  if TClientUtils.PodeMudarStatus(FStatusAtual, 'CANCELADA') then
    cbbStatus.Items.Add('Cancelada');
    
  if cbbStatus.Items.Count > 0 then
    cbbStatus.ItemIndex := 0;
end;

procedure TfrmStatus.LoadData(AId: Integer; const ATitulo, AStatusAtual: string);
begin
  FTarefaId := AId;
  FTarefaTitulo := ATitulo;
  FStatusAtual := AStatusAtual;
end;

end.
