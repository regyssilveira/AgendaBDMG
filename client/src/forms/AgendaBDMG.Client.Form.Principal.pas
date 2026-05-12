unit AgendaBDMG.Client.Form.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB, System.UITypes,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  AgendaBDMG.Client.Service.Tarefa, AgendaBDMG.Client.DTO;

type
  TfrmPrincipal = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlEstatisticas: TPanel;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnAlterarStatus: TButton;
    btnAtualizar: TButton;
    lblTotalTarefas: TLabel;
    lblMediaPrioridade: TLabel;
    lblConcluidas7Dias: TLabel;
    cbbFiltroStatus: TComboBox;
    cbbFiltroPrioridade: TComboBox;
    lblFiltroStatus: TLabel;
    lblFiltroPrioridade: TLabel;
    btnPesquisar: TButton;
    mtTarefas: TFDMemTable;
    dsTarefas: TDataSource;
    mtTarefasId: TIntegerField;
    mtTarefasTitulo: TStringField;
    mtTarefasPrioridade: TStringField;
    mtTarefasStatus: TStringField;
    mtTarefasDataCriacao: TStringField;
    btnAdicionar: TButton;
    btnAnterior: TButton;
    lblPaginaInfo: TLabel;
    btnProximo: TButton;
    DBGridTarefas: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAlterarStatusClick(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
  private
    { Private declarations }
    FTarefaService: TTarefaApiService;
    FPaginaAtual: Integer;
    FTotalPaginas: Integer;
    procedure CarregarTarefas;
    procedure CarregarEstatisticas;
  public
    { Public declarations }
  end;

implementation

uses
  AgendaBDMG.Client.Utils,
  AgendaBDMG.Client.Form.Tarefa,
  AgendaBDMG.Client.Form.Status;

{$R *.dfm}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FTarefaService := TTarefaApiService.Create;
  FPaginaAtual := 1;
  FTotalPaginas := 1;
  mtTarefas.CreateDataSet;
  CarregarTarefas;
  CarregarEstatisticas;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  if mtTarefas.Active then
    mtTarefas.Close;
  FTarefaService.Free;
end;

procedure TfrmPrincipal.btnAdicionarClick(Sender: TObject);
var
  LDTO: TTarefaCreateDTO;
  LResp: TTarefaResponseDTO;
  LNovoId: Integer;
  frmTarefa: TfrmTarefa;
begin
  frmTarefa := TfrmTarefa.Create(Self);
  try
    frmTarefa.LoadData('', '', 3); // Valores padrao
    if frmTarefa.ShowModal = mrOk then
    begin
      LDTO := TTarefaCreateDTO.Create;
      try
        LDTO.Titulo := frmTarefa.FTitulo;
        LDTO.Descricao := frmTarefa.FDescricao;
        LDTO.Prioridade := frmTarefa.FPrioridade;
        
        LResp := FTarefaService.Criar(LDTO);
        try
          LNovoId := LResp.Id;
        finally
          LResp.Free;
        end;
        
        CarregarTarefas;
        CarregarEstatisticas;
        mtTarefas.Locate('Id', LNovoId, []);
      finally
        LDTO.Free;
      end;
    end;
  finally
    frmTarefa.Free;
  end;
end;

procedure TfrmPrincipal.btnAlterarStatusClick(Sender: TObject);
var
  LDTO: TTarefaStatusDTO;
  LTarefaResponse: TTarefaResponseDTO;
  LId: Integer;
  frmStatus: TfrmStatus;
begin
  if mtTarefas.IsEmpty then Exit;
  
  LId := mtTarefasId.AsInteger;
  
  // Obter detalhes primeiro para ter o status atual (que pode ter sido alterado por outro user)
  LTarefaResponse := FTarefaService.ObterPorId(LId);
  try
    frmStatus := TfrmStatus.Create(Self);
    try
      frmStatus.LoadData(LId, LTarefaResponse.Titulo, LTarefaResponse.Status);
      if frmStatus.ShowModal = mrOk then
      begin
        LDTO := TTarefaStatusDTO.Create;
        try
          LDTO.Status := frmStatus.FNovoStatus;
          FTarefaService.AtualizarStatus(LId, LDTO).Free;
          CarregarTarefas;
          CarregarEstatisticas;
          mtTarefas.Locate('Id', LId, []);
        finally
          LDTO.Free;
        end;
      end;
    finally
      frmStatus.Free;
    end;
  finally
    LTarefaResponse.Free;
  end;
end;

procedure TfrmPrincipal.btnAnteriorClick(Sender: TObject);
begin
  if FPaginaAtual > 1 then
  begin
    Dec(FPaginaAtual);
    CarregarTarefas;
  end;
end;

procedure TfrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
  CarregarTarefas;
  CarregarEstatisticas;
end;

procedure TfrmPrincipal.btnEditarClick(Sender: TObject);
var
  LDTO: TTarefaUpdateDTO;
  LTarefaResponse: TTarefaResponseDTO;
  LId: Integer;
  frmTarefa: TfrmTarefa;
begin
  if mtTarefas.IsEmpty then Exit;
  
  LId := mtTarefasId.AsInteger;
  LTarefaResponse := FTarefaService.ObterPorId(LId);
  try
    frmTarefa := TfrmTarefa.Create(Self);
    try
      frmTarefa.LoadData(LTarefaResponse.Titulo, LTarefaResponse.Descricao, LTarefaResponse.Prioridade);
      if frmTarefa.ShowModal = mrOk then
      begin
        LDTO := TTarefaUpdateDTO.Create;
        try
          LDTO.Titulo := frmTarefa.FTitulo;
          LDTO.Descricao := frmTarefa.FDescricao;
          LDTO.Prioridade := frmTarefa.FPrioridade;
          
          FTarefaService.Atualizar(LId, LDTO).Free;
          CarregarTarefas;
          CarregarEstatisticas;
          mtTarefas.Locate('Id', LId, []);
        finally
          LDTO.Free;
        end;
      end;
    finally
      frmTarefa.Free;
    end;
  finally
    LTarefaResponse.Free;
  end;
end;

procedure TfrmPrincipal.btnExcluirClick(Sender: TObject);
var
  LId: Integer;
begin
  if mtTarefas.IsEmpty then Exit;
  
  LId := mtTarefasId.AsInteger;
  
  if MessageDlg(Format('Deseja realmente excluir a tarefa #%d?', [LId]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FTarefaService.Remover(LId);
    CarregarTarefas;
    CarregarEstatisticas;
  end;
end;

procedure TfrmPrincipal.btnPesquisarClick(Sender: TObject);
begin
  FPaginaAtual := 1; // Reset para a primeira pagina ao pesquisar
  CarregarTarefas;
end;

procedure TfrmPrincipal.btnProximoClick(Sender: TObject);
begin
  if FPaginaAtual < FTotalPaginas then
  begin
    Inc(FPaginaAtual);
    CarregarTarefas;
  end;
end;

procedure TfrmPrincipal.CarregarEstatisticas;
var
  LEstat: TEstatisticasDTO;
begin
  try
    LEstat := FTarefaService.ObterEstatisticas;
    try
      lblTotalTarefas.Caption := Format('Total de Tarefas Ativas: %d', [LEstat.TotalTarefas]);
      lblMediaPrioridade.Caption := Format('Média Prioridade Pendentes: %.2f', [LEstat.MediaPrioridadePendentes]);
      lblConcluidas7Dias.Caption := Format('Concluídas (7 dias): %d', [LEstat.TarefasConcluidasUltimos7Dias]);
    finally
      LEstat.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar estatísticas: ' + E.Message);
  end;
end;

procedure TfrmPrincipal.CarregarTarefas;
var
  LResponse: TListaTarefasResponseDTO;
  LTarefa: TTarefaResponseDTO;
  LStatusFiltro: string;
  LPrioridadeFiltro: Integer;
begin
  // Filtros
  LStatusFiltro := '';
  if cbbFiltroStatus.ItemIndex > 0 then
    LStatusFiltro := TClientUtils.StringToStatus(cbbFiltroStatus.Text);
    
  LPrioridadeFiltro := cbbFiltroPrioridade.ItemIndex; // 0=Todas, 1=1, 2=2...
  
  try
    LResponse := FTarefaService.Listar(FPaginaAtual, 20, LStatusFiltro, LPrioridadeFiltro, 'dataCriacao_desc');
    try
      mtTarefas.DisableControls;
      mtTarefas.EmptyDataSet;
      
      for LTarefa in LResponse.Dados do
      begin
        mtTarefas.Append;
        mtTarefasId.AsInteger := LTarefa.Id;
        mtTarefasTitulo.AsString := LTarefa.Titulo;
        mtTarefasPrioridade.AsString := TClientUtils.PrioridadeToString(LTarefa.Prioridade);
        mtTarefasStatus.AsString := TClientUtils.StatusToString(LTarefa.Status);
        mtTarefasDataCriacao.AsString := TClientUtils.DataISOToDisplay(LTarefa.DataCriacao);
        mtTarefas.Post;
      end;
      
      // Paginacao
      FPaginaAtual := LResponse.Paginacao.PaginaAtual;
      FTotalPaginas := LResponse.Paginacao.TotalPaginas;
      lblPaginaInfo.Caption := Format('Página %d de %d (Total: %d itens)', 
        [LResponse.Paginacao.PaginaAtual, LResponse.Paginacao.TotalPaginas, LResponse.Paginacao.TotalItens]);
        
      btnAnterior.Enabled := (FPaginaAtual > 1);
      btnProximo.Enabled := (FPaginaAtual < FTotalPaginas);
    finally
      LResponse.Free;
      mtTarefas.EnableControls;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar tarefas: ' + E.Message);
  end;
end;

end.
