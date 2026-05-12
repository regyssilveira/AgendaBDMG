unit AgendaBDMG.Repository.Tarefa;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  Data.DB, FireDAC.Comp.Client,
  AgendaBDMG.Model.Tarefa,
  AgendaBDMG.Interfaces;

type
  TTarefaRepository = class(TInterfacedObject, ITarefaRepository)
  private
    FDbConnection: IDbConnection;
    function GetConnection: TFDConnection;
    function MapDatasetToTarefa(ADataSet: TDataSet): TTarefa;
  public
    constructor Create(ADbConnection: IDbConnection);
    
    function Listar(APagina, ALimite: Integer; const AStatus: string; APrioridade: Integer; const AOrdem: string; out ATotal: Integer): TList<TTarefa>;
    function ObterPorId(AId: Integer): TTarefa;
    procedure Criar(ATarefa: TTarefa);
    procedure Atualizar(ATarefa: TTarefa);
    procedure Remover(AId: Integer);
    function ObterEstatisticas(out ATotal, ATarefasConcluidas: Integer; out AMediaPrioridade: Double): Boolean;
  end;

implementation

uses
  AgendaBDMG.Utils.Logger;

{ TTarefaRepository }

constructor TTarefaRepository.Create(ADbConnection: IDbConnection);
begin
  FDbConnection := ADbConnection;
end;

function TTarefaRepository.GetConnection: TFDConnection;
begin
  Result := TFDConnection(FDbConnection.GetConnection);
end;

function TTarefaRepository.MapDatasetToTarefa(ADataSet: TDataSet): TTarefa;
begin
  Result := TTarefa.Create;
  Result.Id := ADataSet.FieldByName('Id').AsInteger;
  Result.Titulo := ADataSet.FieldByName('Titulo').AsString;
  Result.Descricao := ADataSet.FieldByName('Descricao').AsString;
  Result.Prioridade := ADataSet.FieldByName('Prioridade').AsInteger;
  Result.Status := TStatusTarefa.FromString(ADataSet.FieldByName('Status').AsString);
  Result.DataCriacao := ADataSet.FieldByName('DataCriacao').AsDateTime;
  
  if not ADataSet.FieldByName('DataConclusao').IsNull then
    Result.DataConclusao := ADataSet.FieldByName('DataConclusao').AsDateTime;
    
  if not ADataSet.FieldByName('DataExclusao').IsNull then
    Result.DataExclusao := ADataSet.FieldByName('DataExclusao').AsDateTime;
end;

function TTarefaRepository.Listar(APagina, ALimite: Integer; const AStatus: string; APrioridade: Integer; const AOrdem: string; out ATotal: Integer): TList<TTarefa>;
var
  LQuery: TFDQuery;
  LSQL: string;
  LWhere: string;
  LOrderBy: string;
  LOffset: Integer;
begin
  Result := TObjectList<TTarefa>.Create(False); // Não possui as instâncias, mas Service pode transferir
  ATotal := 0;
  
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := GetConnection;
    
    LWhere := ' WHERE DataExclusao IS NULL ';
    
    if AStatus <> '' then
    begin
      LWhere := LWhere + ' AND Status = :Status ';
    end;
    
    if APrioridade > 0 then
    begin
      LWhere := LWhere + ' AND Prioridade = :Prioridade ';
    end;
    
    // Obter Total primeiro
    LQuery.SQL.Text := 'SELECT COUNT(*) AS Total FROM Tarefas ' + LWhere;
    if AStatus <> '' then LQuery.ParamByName('Status').AsString := AStatus;
    if APrioridade > 0 then LQuery.ParamByName('Prioridade').AsInteger := APrioridade;
    
    TLogger.SQL(LQuery.SQL.Text);
    LQuery.Open;
    ATotal := LQuery.FieldByName('Total').AsInteger;
    LQuery.Close;
    
    if ATotal = 0 then Exit;

    // Configurar Ordenação
    LOrderBy := ' ORDER BY DataCriacao DESC '; // default
    if LowerCase(AOrdem) = 'datacriacao_asc' then LOrderBy := ' ORDER BY DataCriacao ASC '
    else if LowerCase(AOrdem) = 'datacriacao_desc' then LOrderBy := ' ORDER BY DataCriacao DESC '
    else if LowerCase(AOrdem) = 'prioridade_asc' then LOrderBy := ' ORDER BY Prioridade ASC '
    else if LowerCase(AOrdem) = 'prioridade_desc' then LOrderBy := ' ORDER BY Prioridade DESC '
    else if LowerCase(AOrdem) = 'titulo_asc' then LOrderBy := ' ORDER BY Titulo ASC '
    else if LowerCase(AOrdem) = 'titulo_desc' then LOrderBy := ' ORDER BY Titulo DESC ';

    // Paginação
    LOffset := (APagina - 1) * ALimite;
    
    LSQL := 'SELECT * FROM Tarefas ' + LWhere + LOrderBy +
            ' OFFSET :Offset ROWS FETCH NEXT :Limit ROWS ONLY';
            
    LQuery.SQL.Text := LSQL;
    if AStatus <> '' then LQuery.ParamByName('Status').AsString := AStatus;
    if APrioridade > 0 then LQuery.ParamByName('Prioridade').AsInteger := APrioridade;
    LQuery.ParamByName('Offset').AsInteger := LOffset;
    LQuery.ParamByName('Limit').AsInteger := ALimite;
    
    TLogger.SQL(LQuery.SQL.Text);
    LQuery.Open;
    
    while not LQuery.Eof do
    begin
      Result.Add(MapDatasetToTarefa(LQuery));
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

function TTarefaRepository.ObterPorId(AId: Integer): TTarefa;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := GetConnection;
    LQuery.SQL.Text := 'SELECT * FROM Tarefas WHERE Id = :Id AND DataExclusao IS NULL';
    LQuery.ParamByName('Id').AsInteger := AId;
    
    TLogger.SQL(LQuery.SQL.Text);
    LQuery.Open;
    
    if not LQuery.IsEmpty then
      Result := MapDatasetToTarefa(LQuery);
  finally
    LQuery.Free;
  end;
end;

procedure TTarefaRepository.Criar(ATarefa: TTarefa);
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := GetConnection;
    LQuery.SQL.Text := 
      'INSERT INTO Tarefas (Titulo, Descricao, Prioridade, Status, DataCriacao) ' +
      'OUTPUT INSERTED.Id ' +
      'VALUES (:Titulo, :Descricao, :Prioridade, :Status, :DataCriacao)';
      
    LQuery.ParamByName('Titulo').AsString := ATarefa.Titulo;
    LQuery.ParamByName('Descricao').AsString := ATarefa.Descricao;
    LQuery.ParamByName('Prioridade').AsInteger := ATarefa.Prioridade;
    LQuery.ParamByName('Status').AsString := ATarefa.Status.ToString;
    LQuery.ParamByName('DataCriacao').AsDateTime := ATarefa.DataCriacao;
    
    TLogger.SQL(LQuery.SQL.Text);
    LQuery.Open;
    
    ATarefa.Id := LQuery.FieldByName('Id').AsInteger;
  finally
    LQuery.Free;
  end;
end;

procedure TTarefaRepository.Atualizar(ATarefa: TTarefa);
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := GetConnection;
    LQuery.SQL.Text := 
      'UPDATE Tarefas SET ' +
      ' Titulo = :Titulo, ' +
      ' Descricao = :Descricao, ' +
      ' Prioridade = :Prioridade, ' +
      ' Status = :Status, ' +
      ' DataConclusao = :DataConclusao ' +
      'WHERE Id = :Id AND DataExclusao IS NULL';
      
    LQuery.ParamByName('Id').AsInteger := ATarefa.Id;
    LQuery.ParamByName('Titulo').AsString := ATarefa.Titulo;
    LQuery.ParamByName('Descricao').AsString := ATarefa.Descricao;
    LQuery.ParamByName('Prioridade').AsInteger := ATarefa.Prioridade;
    LQuery.ParamByName('Status').AsString := ATarefa.Status.ToString;
    
    if ATarefa.DataConclusao > 0 then
      LQuery.ParamByName('DataConclusao').AsDateTime := ATarefa.DataConclusao
    else
      LQuery.ParamByName('DataConclusao').Clear;
    
    TLogger.SQL(LQuery.SQL.Text);
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

procedure TTarefaRepository.Remover(AId: Integer);
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := GetConnection;
    LQuery.SQL.Text := 'UPDATE Tarefas SET DataExclusao = GETDATE() WHERE Id = :Id';
    LQuery.ParamByName('Id').AsInteger := AId;
    
    TLogger.SQL(LQuery.SQL.Text);
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

function TTarefaRepository.ObterEstatisticas(out ATotal, ATarefasConcluidas: Integer; out AMediaPrioridade: Double): Boolean;
var
  LQuery: TFDQuery;
begin
  Result := True;
  ATotal := 0;
  ATarefasConcluidas := 0;
  AMediaPrioridade := 0;
  
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := GetConnection;
    
    // Total Tarefas Ativas
    LQuery.SQL.Text := 'SELECT COUNT(*) AS Total FROM Tarefas WHERE DataExclusao IS NULL';
    LQuery.Open;
    ATotal := LQuery.FieldByName('Total').AsInteger;
    LQuery.Close;
    
    // Media Prioridade Pendentes
    LQuery.SQL.Text := 'SELECT AVG(CAST(Prioridade AS FLOAT)) AS Media FROM Tarefas WHERE Status = ''PENDENTE'' AND DataExclusao IS NULL';
    LQuery.Open;
    if not LQuery.FieldByName('Media').IsNull then
      AMediaPrioridade := LQuery.FieldByName('Media').AsFloat;
    LQuery.Close;
    
    // Concluidas ultimos 7 dias
    LQuery.SQL.Text := 
      'SELECT COUNT(*) AS Total FROM Tarefas ' +
      'WHERE Status = ''CONCLUIDA'' ' +
      'AND DataConclusao >= DATEADD(DAY, -7, GETDATE()) ' +
      'AND DataExclusao IS NULL';
    LQuery.Open;
    ATarefasConcluidas := LQuery.FieldByName('Total').AsInteger;
    LQuery.Close;
    
  finally
    LQuery.Free;
  end;
end;

end.
