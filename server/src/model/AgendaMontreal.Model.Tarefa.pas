unit AgendaMontreal.Model.Tarefa;

interface

uses
  System.SysUtils;

type
  TStatusTarefa = (stPendente, stEmAndamento, stConcluida, stCancelada);
  TPrioridadeTarefa = 1..5;

  TStatusTarefaHelper = record helper for TStatusTarefa
  public
    function ToString: string;
    class function FromString(const AValue: string): TStatusTarefa; static;
    function PodeMudarPara(ANovoStatus: TStatusTarefa): Boolean;
  end;

  TTarefa = class
  private
    FId: Integer;
    FTitulo: string;
    FDescricao: string;
    FPrioridade: Integer;
    FStatus: TStatusTarefa;
    FDataCriacao: TDateTime;
    FDataConclusao: TDateTime;
    FDataExclusao: TDateTime;
  public
    property Id: Integer read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
    property Prioridade: Integer read FPrioridade write FPrioridade;
    property Status: TStatusTarefa read FStatus write FStatus;
    property DataCriacao: TDateTime read FDataCriacao write FDataCriacao;
    property DataConclusao: TDateTime read FDataConclusao write FDataConclusao;
    property DataExclusao: TDateTime read FDataExclusao write FDataExclusao;

    constructor Create;
  end;

implementation

{ TStatusTarefaHelper }

class function TStatusTarefaHelper.FromString(const AValue: string): TStatusTarefa;
var
  LValue: string;
begin
  LValue := UpperCase(Trim(AValue));
  if LValue = 'PENDENTE' then
    Result := stPendente
  else if LValue = 'EM_ANDAMENTO' then
    Result := stEmAndamento
  else if LValue = 'CONCLUIDA' then
    Result := stConcluida
  else if LValue = 'CANCELADA' then
    Result := stCancelada
  else
    raise Exception.CreateFmt('Status inválido: %s', [AValue]);
end;

function TStatusTarefaHelper.PodeMudarPara(ANovoStatus: TStatusTarefa): Boolean;
begin
  Result := False;
  case Self of
    stPendente:
      Result := (ANovoStatus in [stEmAndamento, stCancelada]);
    stEmAndamento:
      Result := (ANovoStatus in [stConcluida, stCancelada, stPendente]);
    stConcluida:
      Result := False; // Estado final
    stCancelada:
      Result := (ANovoStatus = stPendente);
  end;
end;

function TStatusTarefaHelper.ToString: string;
begin
  case Self of
    stPendente: Result := 'PENDENTE';
    stEmAndamento: Result := 'EM_ANDAMENTO';
    stConcluida: Result := 'CONCLUIDA';
    stCancelada: Result := 'CANCELADA';
  else
    Result := '';
  end;
end;

{ TTarefa }

constructor TTarefa.Create;
begin
  inherited;
  FDataCriacao := Now;
  FStatus := stPendente;
  FDataConclusao := 0;
  FDataExclusao := 0;
end;

end.
