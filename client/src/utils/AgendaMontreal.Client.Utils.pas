unit AgendaMontreal.Client.Utils;

interface

uses
  System.SysUtils;

type
  TClientUtils = class
  public
    class function PrioridadeToString(APrioridade: Integer): string;
    class function StatusToString(const AStatus: string): string;
    class function StringToStatus(const AStatus: string): string;
    class function PodeMudarStatus(const AStatusAtual, ANovoStatus: string): Boolean;
    class function DataISOToDisplay(const ADateISO: string): string;
  end;

implementation

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
  if AStatus = 'PENDENTE' then Result := 'Pendente'
  else if AStatus = 'EM_ANDAMENTO' then Result := 'Em Andamento'
  else if AStatus = 'CONCLUIDA' then Result := 'Concluída'
  else if AStatus = 'CANCELADA' then Result := 'Cancelada'
  else Result := AStatus;
end;

class function TClientUtils.StringToStatus(const AStatus: string): string;
begin
  if AStatus = 'Pendente' then Result := 'PENDENTE'
  else if AStatus = 'Em Andamento' then Result := 'EM_ANDAMENTO'
  else if AStatus = 'Concluída' then Result := 'CONCLUIDA'
  else if AStatus = 'Cancelada' then Result := 'CANCELADA'
  else Result := AStatus;
end;

end.
