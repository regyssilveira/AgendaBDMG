unit AgendaBDMG.Client.Form.Tarefa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmTarefa = class(TForm)
    pnlBottom: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    lblTitulo: TLabel;
    edtTitulo: TEdit;
    lblDescricao: TLabel;
    memDescricao: TMemo;
    lblPrioridade: TLabel;
    cbbPrioridade: TComboBox;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FTitulo: string;
    FDescricao: string;
    FPrioridade: Integer;
    
    procedure LoadData(const ATitulo, ADescricao: string; APrioridade: Integer);
  end;

implementation

{$R *.dfm}

{ TfrmTarefa }

procedure TfrmTarefa.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTarefa.btnSalvarClick(Sender: TObject);
begin
  if Trim(edtTitulo.Text) = '' then
  begin
    ShowMessage('O título é obrigatório.');
    edtTitulo.SetFocus;
    Exit;
  end;

  FTitulo := Trim(edtTitulo.Text);
  FDescricao := Trim(memDescricao.Text);
  FPrioridade := cbbPrioridade.ItemIndex + 1; // 0 = 1, 1 = 2...

  ModalResult := mrOk;
end;

procedure TfrmTarefa.FormShow(Sender: TObject);
begin
  edtTitulo.Text := FTitulo;
  memDescricao.Text := FDescricao;
  if FPrioridade > 0 then
    cbbPrioridade.ItemIndex := FPrioridade - 1
  else
    cbbPrioridade.ItemIndex := 2; // Default Normal (3)
end;

procedure TfrmTarefa.LoadData(const ATitulo, ADescricao: string; APrioridade: Integer);
begin
  FTitulo := ATitulo;
  FDescricao := ADescricao;
  FPrioridade := APrioridade;
end;

end.
