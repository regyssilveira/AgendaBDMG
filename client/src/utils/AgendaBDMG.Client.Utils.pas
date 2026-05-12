unit AgendaBDMG.Client.Utils;

interface

uses
  System.SysUtils;

type
  TStatusTarefaClient = (stPendente, stEmAndamento, stConcluida, stCancelada);

  TStatusTarefaClientHelper = record helper for TStatusTarefaClient
  public
    function ToString: string;
    function ToDisplayString: string;
    class function FromString(const AValue: string): TStatusTarefaClient; static;
    class function FromDisplayString(const AValue: string): TStatusTarefaClient; static;
  end;

  TClientUtils = class
  public
    class function PrioridadeToString(APrioridade: Integer): string;
    class function StatusToString(const AStatus: string): string;
    class function StringToStatus(const AStatus: string): string;
    class function PodeMudarStatus(const AStatusAtual, ANovoStatus: string): Boolean;
    class function DataISOToDisplay(const ADateISO: string): string;
  end;

implementation

{ TStatusTarefaClientHelper }

class function TStatusTarefaClientHelper.FromDisplayString(const AValue: string): TStatusTarefaClient;
begin
  if AValue = 'Em Andamento' then Result := stEmAndamento
  else if AValue = 'Concluída' then Result := stConcluida
  else if AValue = 'Cancelada' then Result := stCancelada
  else Result := stPendente;
end;

class function TStatusTarefaClientHelper.FromString(const AValue: string): TStatusTarefaClient;
begin
  if AValue = 'EM_ANDAMENTO' then Result := stEmAndamento
  else if AValue = 'CONCLUIDA' then Result := stConcluida
  else if AValue = 'CANCELADA' then Result := stCancelada
  else Result := stPendente;
end;

function TStatusTarefaClientHelper.ToDisplayString: string;
begin
  case Self of
    stPendente: Result := 'Pendente';
    stEmAndamento: Result := 'Em Andamento';
    stConcluida: Result := 'Concluída';
    stCancelada: Result := 'Cancelada';
  end;
end;

function TStatusTarefaClientHelper.ToString: string;
begin
  case Self of
    stPendente: Result := 'PENDENTE';
    stEmAndamento: Result := 'EM_ANDAMENTO';
    stConcluida: Result := 'CONCLUIDA';
    stCancelada: Result := 'CANCELADA';
  end;
end;

{ TClientUtils }

class function TClientUtils.DataISOToDisplay(const ADateISO: string): string;
var
  LDateStr: string;
begin
  if ADateISO = '' then
    Exit('');
    
  // Exemplo: 2026-05-12T14:10:04 -> 12/05/2026 14:10:04
  LDateStr := StringReplace(ADateISO, 'T', ' ', [rfReplaceAll]);
  if Length(LDateStr) >= 19 then
    Result := Copy(LDateStr, 9, 2) + '/' + Copy(LDateStr, 6, 2) + '/' + Copy(LDateStr, 1, 4) + ' ' + Copy(LDateStr, 12, 8)
  else
    Result := LDateStr;
end;

class function TClientUtils.PodeMudarStatus(const AStatusAtual, ANovoStatus: string): Boolean;
begin
  Result := False;
  if AStatusAtual = 'PENDENTE' then
    Result := (ANovoStatus = 'EM_ANDAMENTO') or (ANovoStatus = 'CANCELADA')
  else if AStatusAtual = 'EM_ANDAMENTO' then
    Result := (ANovoStatus = 'CONCLUIDA') or (ANovoStatus = 'CANCELADA') or (ANovoStatus = 'PENDENTE')
  else if AStatusAtual = 'CANCELADA' then
    Result := (ANovoStatus = 'PENDENTE');
  // CONCLUIDA não pode mudar
end;

class function TClientUtils.PrioridadeToString(APrioridade: Integer): string;
begin
  case APrioridade of
    1: Result := '1 - Muito Baixa';
    2: Result := '2 - Baixa';
    3: Result := '3 - Normal';
    4: Result := '4 - Alta';
    5: Result := '5 - Crítica';
  else
    Result := 'Desconhecida';
  end;
end;

class function TClientUtils.StatusToString(const AStatus: string): string;
begin
  Result := TStatusTarefaClient.FromString(AStatus).ToDisplayString;
end;

class function TClientUtils.StringToStatus(const AStatus: string): string;
begin
  Result := TStatusTarefaClient.FromDisplayString(AStatus).ToString;
end;

end.
