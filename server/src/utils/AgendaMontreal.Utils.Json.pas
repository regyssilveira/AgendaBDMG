unit AgendaMontreal.Utils.Json;

interface

uses
  System.SysUtils;

type
  TJsonUtils = class
  public
    class function DateTimeToISO8601(const ADateTime: TDateTime): string;
    class function ISO8601ToDateTime(const ADateString: string): TDateTime;
  end;

implementation

uses
  System.DateUtils;

{ TJsonUtils }

class function TJsonUtils.DateTimeToISO8601(const ADateTime: TDateTime): string;
begin
  if ADateTime = 0 then
    Result := ''
  else
    Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', ADateTime);
end;

class function TJsonUtils.ISO8601ToDateTime(const ADateString: string): TDateTime;
var
  LYear, LMonth, LDay, LHour, LMin, LSec: Word;
  LDateStr: string;
begin
  if ADateString = '' then
    Exit(0);

  LDateStr := StringReplace(ADateString, 'T', ' ', [rfReplaceAll]);
  
  if Length(LDateStr) >= 19 then
  begin
    LYear := StrToIntDef(Copy(LDateStr, 1, 4), 0);
    LMonth := StrToIntDef(Copy(LDateStr, 6, 2), 0);
    LDay := StrToIntDef(Copy(LDateStr, 9, 2), 0);
    LHour := StrToIntDef(Copy(LDateStr, 12, 2), 0);
    LMin := StrToIntDef(Copy(LDateStr, 15, 2), 0);
    LSec := StrToIntDef(Copy(LDateStr, 18, 2), 0);
    
    if (LYear > 0) and (LMonth > 0) and (LDay > 0) then
      Result := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, 0)
    else
      Result := 0;
  end
  else
    Result := 0;
end;

end.
