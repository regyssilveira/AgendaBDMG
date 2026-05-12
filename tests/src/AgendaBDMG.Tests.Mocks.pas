unit AgendaBDMG.Tests.Mocks;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  AgendaBDMG.Model.Tarefa,
  AgendaBDMG.Interfaces;

type
  TTarefaRepositoryMock = class(TInterfacedObject, ITarefaRepository)
  private
    FLista: TObjectList<TTarefa>;
    FLastId: Integer;
    function CloneTarefa(ASource: TTarefa): TTarefa;
  public
    constructor Create;
    destructor Destroy; override;

    function Listar(APagina, ALimite: Integer; const AStatus: string; APrioridade: Integer; const AOrdem: string; out ATotal: Integer): TList<TTarefa>;
    function ObterPorId(AId: Integer): TTarefa;
    procedure Criar(ATarefa: TTarefa);
    procedure Atualizar(ATarefa: TTarefa);
    procedure Remover(AId: Integer);
    function ObterEstatisticas(out ATotal, ATarefasConcluidas: Integer; out AMediaPrioridade: Double): Boolean;
  end;

implementation

{ TTarefaRepositoryMock }

constructor TTarefaRepositoryMock.Create;
begin
  FLista := TObjectList<TTarefa>.Create(True); // Owns objects
  FLastId := 0;
end;

destructor TTarefaRepositoryMock.Destroy;
begin
  FLista.Free;
  inherited;
end;

function TTarefaRepositoryMock.CloneTarefa(ASource: TTarefa): TTarefa;
begin
  if not Assigned(ASource) then
    Exit(nil);

  Result := TTarefa.Create;
  Result.Id := ASource.Id;
  Result.Titulo := ASource.Titulo;
  Result.Descricao := ASource.Descricao;
  Result.Prioridade := ASource.Prioridade;
  Result.Status := ASource.Status;
  Result.DataCriacao := ASource.DataCriacao;
  Result.DataConclusao := ASource.DataConclusao;
  Result.DataExclusao := ASource.DataExclusao;
end;

procedure TTarefaRepositoryMock.Criar(ATarefa: TTarefa);
var
  LNova: TTarefa;
begin
  Inc(FLastId);
  ATarefa.Id := FLastId;
  
  LNova := CloneTarefa(ATarefa);
  FLista.Add(LNova);
end;

procedure TTarefaRepositoryMock.Atualizar(ATarefa: TTarefa);
var
  LItem: TTarefa;
begin
  for LItem in FLista do
  begin
    if LItem.Id = ATarefa.Id then
    begin
      LItem.Titulo := ATarefa.Titulo;
      LItem.Descricao := ATarefa.Descricao;
      LItem.Prioridade := ATarefa.Prioridade;
      LItem.Status := ATarefa.Status;
      LItem.DataConclusao := ATarefa.DataConclusao;
      Break;
    end;
  end;
end;

procedure TTarefaRepositoryMock.Remover(AId: Integer);
var
  LItem: TTarefa;
begin
  for LItem in FLista do
  begin
    if LItem.Id = AId then
    begin
      LItem.DataExclusao := Now;
      Break;
    end;
  end;
end;

function TTarefaRepositoryMock.ObterPorId(AId: Integer): TTarefa;
var
  LItem: TTarefa;
begin
  Result := nil;
  for LItem in FLista do
  begin
    if (LItem.Id = AId) and (LItem.DataExclusao = 0) then
    begin
      Result := CloneTarefa(LItem);
      Break;
    end;
  end;
end;

function TTarefaRepositoryMock.Listar(APagina, ALimite: Integer; const AStatus: string; APrioridade: Integer; const AOrdem: string; out ATotal: Integer): TList<TTarefa>;
var
  LItem: TTarefa;
  LFiltrados: TList<TTarefa>;
  I, LStart, LEnd: Integer;
begin
  LFiltrados := TList<TTarefa>.Create;
  try
    for LItem in FLista do
    begin
      if LItem.DataExclusao <> 0 then
        Continue;

      if (AStatus <> '') and (UpperCase(AStatus) <> 'TODOS') then
      begin
        if UpperCase(LItem.Status.ToString) <> UpperCase(AStatus) then
          Continue;
      end;

      if APrioridade > 0 then
      begin
        if LItem.Prioridade <> APrioridade then
          Continue;
      end;

      LFiltrados.Add(LItem);
    end;

    ATotal := LFiltrados.Count;

    Result := TList<TTarefa>.Create;
    LStart := (APagina - 1) * ALimite;
    LEnd := LStart + ALimite - 1;

    for I := 0 to LFiltrados.Count - 1 do
    begin
      if (I >= LStart) and (I <= LEnd) then
        Result.Add(CloneTarefa(LFiltrados[I]));
    end;
  finally
    LFiltrados.Free;
  end;
end;

function TTarefaRepositoryMock.ObterEstatisticas(out ATotal, ATarefasConcluidas: Integer; out AMediaPrioridade: Double): Boolean;
var
  LItem: TTarefa;
  LSomaPrioridade: Integer;
  LPendentesCount: Integer;
begin
  ATotal := 0;
  ATarefasConcluidas := 0;
  LSomaPrioridade := 0;
  LPendentesCount := 0;

  for LItem in FLista do
  begin
    if LItem.DataExclusao <> 0 then
      Continue;

    Inc(ATotal);

    if LItem.Status = stConcluida then
      Inc(ATarefasConcluidas)
    else
    begin
      Inc(LPendentesCount);
      LSomaPrioridade := LSomaPrioridade + LItem.Prioridade;
    end;
  end;

  if LPendentesCount > 0 then
    AMediaPrioridade := LSomaPrioridade / LPendentesCount
  else
    AMediaPrioridade := 0;

  Result := True;
end;

end.
