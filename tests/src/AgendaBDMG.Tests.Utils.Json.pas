unit AgendaBDMG.Tests.Utils.Json;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  AgendaBDMG.Utils.Json;

type
  [TestFixture]
  TUtilsJsonTests = class
  public
    [Test]
    procedure TestDateTimeToISO8601;

    [Test]
    procedure TestISO8601ToDateTime;
  end;

implementation

uses
  System.DateUtils;

{ TUtilsJsonTests }

procedure TUtilsJsonTests.TestDateTimeToISO8601;
var
  LDate: TDateTime;
begin
  Assert.AreEqual('', TJsonUtils.DateTimeToISO8601(0));
  
  LDate := EncodeDateTime(2026, 5, 12, 14, 30, 0, 0);
  Assert.AreEqual('2026-05-12T14:30:00', TJsonUtils.DateTimeToISO8601(LDate));
end;

procedure TUtilsJsonTests.TestISO8601ToDateTime;
var
  LDateEsperada: TDateTime;
begin
  Assert.AreEqual<TDateTime>(0, TJsonUtils.ISO8601ToDateTime(''));
  Assert.AreEqual<TDateTime>(0, TJsonUtils.ISO8601ToDateTime('DATA_INVALIDA_AQUI'));
  
  LDateEsperada := EncodeDateTime(2026, 5, 12, 14, 30, 0, 0);
  Assert.AreEqual<TDateTime>(LDateEsperada, TJsonUtils.ISO8601ToDateTime('2026-05-12T14:30:00'));
end;

initialization
  TDUnitX.RegisterTestFixture(TUtilsJsonTests);

end.
