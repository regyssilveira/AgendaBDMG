unit AgendaMontreal.Utils.Logger;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.SyncObjs;

type
  TLogger = class
  private
    class var FCriticalSection: TCriticalSection;
    class function GetLogFileName: string;
    class procedure WriteLog(const ALevel, AMessage: string);
  public
    class constructor Create;
    class destructor Destroy;
    
    class procedure Info(const AMessage: string);
    class procedure Warning(const AMessage: string);
    class procedure Error(const AMessage: string);
    class procedure SQL(const AMessage: string);
  end;

implementation

{ TLogger }

class constructor TLogger.Create;
begin
  FCriticalSection := TCriticalSection.Create;
end;

class destructor TLogger.Destroy;
begin
  FCriticalSection.Free;
end;

class procedure TLogger.Error(const AMessage: string);
begin
  WriteLog('ERROR', AMessage);
end;

class function TLogger.GetLogFileName: string;
var
  LLogDir: string;
begin
  LLogDir := TPath.Combine(ExtractFilePath(ParamStr(0)), 'logs');
  if not TDirectory.Exists(LLogDir) then
    TDirectory.CreateDirectory(LLogDir);
    
  Result := TPath.Combine(LLogDir, FormatDateTime('yyyy-mm-dd', Now) + '.log');
end;

class procedure TLogger.Info(const AMessage: string);
begin
  WriteLog('INFO', AMessage);
end;

class procedure TLogger.SQL(const AMessage: string);
begin
  WriteLog('SQL', AMessage);
end;

class procedure TLogger.Warning(const AMessage: string);
begin
  WriteLog('WARN', AMessage);
end;

class procedure TLogger.WriteLog(const ALevel, AMessage: string);
var
  LFile: TextFile;
  LLogLine: string;
begin
  FCriticalSection.Enter;
  try
    LLogLine := Format('[%s] [%s] %s', [FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now), ALevel, AMessage]);
    
    AssignFile(LFile, GetLogFileName);
    try
      if FileExists(GetLogFileName) then
        Append(LFile)
      else
        Rewrite(LFile);
        
      Writeln(LFile, LLogLine);
    finally
      CloseFile(LFile);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

end.
