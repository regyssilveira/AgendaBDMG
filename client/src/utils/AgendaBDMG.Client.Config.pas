unit AgendaBDMG.Client.Config;

interface

uses
  System.SysUtils, System.IniFiles, System.IOUtils;

type
  TClientConfig = class
  private
    FHost: string;
    FPort: Integer;
    FProtocol: string;
    FApiKey: string;
    
    class var FInstance: TClientConfig;
    procedure LoadConfig;
    procedure CreateDefaultConfig(const AFileName: string);
  public
    property Host: string read FHost;
    property Port: Integer read FPort;
    property Protocol: string read FProtocol;
    property ApiKey: string read FApiKey;
    
    function GetBaseUrl: string;

    constructor Create;
    destructor Destroy; override;
    
    class function GetInstance: TClientConfig;
  end;

implementation

{ TClientConfig }

constructor TClientConfig.Create;
begin
  LoadConfig;
end;

procedure TClientConfig.CreateDefaultConfig(const AFileName: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(AFileName);
  try
    LIniFile.WriteString('Server', 'Host', 'localhost');
    LIniFile.WriteInteger('Server', 'Port', 9005);
    LIniFile.WriteString('Server', 'Protocol', 'http');
    
    LIniFile.WriteString('Security', 'ApiKey', 'agenda-BDMG-dev-key-2026');
  finally
    LIniFile.Free;
  end;
end;

destructor TClientConfig.Destroy;
begin
  inherited;
end;

function TClientConfig.GetBaseUrl: string;
begin
  Result := Format('%s://%s:%d', [FProtocol, FHost, FPort]);
end;

class function TClientConfig.GetInstance: TClientConfig;
begin
  if not Assigned(FInstance) then
    FInstance := TClientConfig.Create;
  Result := FInstance;
end;

procedure TClientConfig.LoadConfig;
var
  LIniFile: TIniFile;
  LFileName: string;
begin
  LFileName := TPath.Combine(ExtractFilePath(ParamStr(0)), 'client.ini');
  
  if not TFile.Exists(LFileName) then
    CreateDefaultConfig(LFileName);
    
  LIniFile := TIniFile.Create(LFileName);
  try
    FHost := LIniFile.ReadString('Server', 'Host', 'localhost');
    FPort := LIniFile.ReadInteger('Server', 'Port', 9005);
    FProtocol := LIniFile.ReadString('Server', 'Protocol', 'http');
    
    FApiKey := LIniFile.ReadString('Security', 'ApiKey', 'agenda-BDMG-dev-key-2026');
  finally
    LIniFile.Free;
  end;
end;

initialization

finalization
  if Assigned(TClientConfig.FInstance) then
    FreeAndNil(TClientConfig.FInstance);

end.
