unit AgendaBDMG.Utils.Config;

interface

uses
  System.SysUtils, System.IniFiles, System.IOUtils;

type
  TServerConfig = class
  private
    FDatabaseServer: string;
    FDatabasePort: Integer;
    FDatabaseName: string;
    FDatabaseUsername: string;
    FDatabasePassword: string;
    FDatabaseDriver: string;
    FServerPort: Integer;
    FApiKey: string;
    
    class var FInstance: TServerConfig;
    procedure LoadConfig;
    procedure CreateDefaultConfig(const AFileName: string);
  public
    property DatabaseServer: string read FDatabaseServer;
    property DatabasePort: Integer read FDatabasePort;
    property DatabaseName: string read FDatabaseName;
    property DatabaseUsername: string read FDatabaseUsername;
    property DatabasePassword: string read FDatabasePassword;
    property DatabaseDriver: string read FDatabaseDriver;
    property ServerPort: Integer read FServerPort;
    property ApiKey: string read FApiKey;

    constructor Create;
    destructor Destroy; override;
    
    class function GetInstance: TServerConfig;
  end;

implementation

{ TServerConfig }

constructor TServerConfig.Create;
begin
  LoadConfig;
end;

procedure TServerConfig.CreateDefaultConfig(const AFileName: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(AFileName);
  try
    LIniFile.WriteString('Database', 'Server', 'localhost');
    LIniFile.WriteInteger('Database', 'Port', 1433);
    LIniFile.WriteString('Database', 'Database', 'AgendaBDMG');
    LIniFile.WriteString('Database', 'Username', 'sa');
    LIniFile.WriteString('Database', 'Password', 'SuaSenha123');
    LIniFile.WriteString('Database', 'Driver', 'MSSQL');
    
    LIniFile.WriteInteger('Server', 'Port', 9000);
    
    LIniFile.WriteString('Security', 'ApiKey', 'agenda-BDMG-dev-key-2026');
  finally
    LIniFile.Free;
  end;
end;

destructor TServerConfig.Destroy;
begin
  // Limpeza caso necessário
  inherited;
end;

class function TServerConfig.GetInstance: TServerConfig;
begin
  if not Assigned(FInstance) then
    FInstance := TServerConfig.Create;
  Result := FInstance;
end;

procedure TServerConfig.LoadConfig;
var
  LIniFile: TIniFile;
  LFileName: string;
begin
  LFileName := TPath.Combine(ExtractFilePath(ParamStr(0)), 'server.ini');
  
  if not TFile.Exists(LFileName) then
    CreateDefaultConfig(LFileName);
    
  LIniFile := TIniFile.Create(LFileName);
  try
    FDatabaseServer := LIniFile.ReadString('Database', 'Server', 'localhost');
    FDatabasePort := LIniFile.ReadInteger('Database', 'Port', 1433);
    FDatabaseName := LIniFile.ReadString('Database', 'Database', 'AgendaBDMG');
    FDatabaseUsername := LIniFile.ReadString('Database', 'Username', 'sa');
    FDatabasePassword := LIniFile.ReadString('Database', 'Password', 'SuaSenha123');
    FDatabaseDriver := LIniFile.ReadString('Database', 'Driver', 'MSSQL');
    
    FServerPort := LIniFile.ReadInteger('Server', 'Port', 9000);
    
    FApiKey := LIniFile.ReadString('Security', 'ApiKey', 'agenda-BDMG-dev-key-2026');
  finally
    LIniFile.Free;
  end;
end;

initialization

finalization
  if Assigned(TServerConfig.FInstance) then
    FreeAndNil(TServerConfig.FInstance);

end.
