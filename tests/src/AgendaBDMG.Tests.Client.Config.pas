unit AgendaBDMG.Tests.Client.Config;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  AgendaBDMG.Client.Config;

type
  [TestFixture]
  TClientConfigTests = class
  public
    [Test]
    procedure TestInstanciaSingleton;

    [Test]
    procedure TestPropriedadesPadrao;

    [Test]
    procedure TestGetBaseUrl;
  end;

implementation

{ TClientConfigTests }

procedure TClientConfigTests.TestInstanciaSingleton;
var
  LInstancia1, LInstancia2: TClientConfig;
begin
  LInstancia1 := TClientConfig.GetInstance;
  LInstancia2 := TClientConfig.GetInstance;
  
  Assert.IsNotNull(LInstancia1);
  Assert.AreSame(LInstancia1, LInstancia2); // Garante que é a mesma instância em memória
end;

procedure TClientConfigTests.TestPropriedadesPadrao;
var
  LConfig: TClientConfig;
begin
  LConfig := TClientConfig.GetInstance;
  Assert.IsNotEmpty(LConfig.Host);
  Assert.IsTrue(LConfig.Port > 0);
  Assert.IsNotEmpty(LConfig.Protocol);
  Assert.IsNotEmpty(LConfig.ApiKey);
end;

procedure TClientConfigTests.TestGetBaseUrl;
var
  LConfig: TClientConfig;
  LBaseUrl: string;
begin
  LConfig := TClientConfig.GetInstance;
  LBaseUrl := LConfig.GetBaseUrl;
  
  Assert.IsTrue(LBaseUrl.StartsWith(LConfig.Protocol + '://'));
  Assert.IsTrue(LBaseUrl.Contains(LConfig.Host));
  Assert.IsTrue(LBaseUrl.Contains(IntToStr(LConfig.Port)));
end;

initialization
  TDUnitX.RegisterTestFixture(TClientConfigTests);

end.
