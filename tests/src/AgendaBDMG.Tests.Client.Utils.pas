unit AgendaBDMG.Tests.Client.Utils;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  AgendaBDMG.Client.Utils;

type
  [TestFixture]
  TClientUtilsTests = class
  public
    [Test]
    procedure TestPrioridadeToString;

    [Test]
    procedure TestStatusToString;

    [Test]
    procedure TestStringToStatus;

    [Test]
    procedure TestPodeMudarStatus;

    [Test]
    procedure TestDataISOToDisplay;
  end;

implementation

{ TClientUtilsTests }

procedure TClientUtilsTests.TestPrioridadeToString;
begin
  Assert.AreEqual('1 - Muito Baixa', TClientUtils.PrioridadeToString(1));
  Assert.AreEqual('2 - Baixa', TClientUtils.PrioridadeToString(2));
  Assert.AreEqual('3 - Normal', TClientUtils.PrioridadeToString(3));
  Assert.AreEqual('4 - Alta', TClientUtils.PrioridadeToString(4));
  Assert.AreEqual('5 - Crítica', TClientUtils.PrioridadeToString(5));
  Assert.AreEqual('Desconhecida', TClientUtils.PrioridadeToString(99));
end;

procedure TClientUtilsTests.TestStatusToString;
begin
  Assert.AreEqual('Pendente', TClientUtils.StatusToString('PENDENTE'));
  Assert.AreEqual('Em Andamento', TClientUtils.StatusToString('EM_ANDAMENTO'));
  Assert.AreEqual('Concluída', TClientUtils.StatusToString('CONCLUIDA'));
  Assert.AreEqual('Cancelada', TClientUtils.StatusToString('CANCELADA'));
  Assert.AreEqual('OUTRO', TClientUtils.StatusToString('OUTRO'));
end;

procedure TClientUtilsTests.TestStringToStatus;
begin
  Assert.AreEqual('PENDENTE', TClientUtils.StringToStatus('Pendente'));
  Assert.AreEqual('EM_ANDAMENTO', TClientUtils.StringToStatus('Em Andamento'));
  Assert.AreEqual('CONCLUIDA', TClientUtils.StringToStatus('Concluída'));
  Assert.AreEqual('CANCELADA', TClientUtils.StringToStatus('Cancelada'));
  Assert.AreEqual('OUTRO', TClientUtils.StringToStatus('OUTRO'));
end;

procedure TClientUtilsTests.TestPodeMudarStatus;
begin
  // PENDENTE
  Assert.IsTrue(TClientUtils.PodeMudarStatus('PENDENTE', 'EM_ANDAMENTO'));
  Assert.IsTrue(TClientUtils.PodeMudarStatus('PENDENTE', 'CANCELADA'));
  Assert.IsFalse(TClientUtils.PodeMudarStatus('PENDENTE', 'CONCLUIDA'));

  // EM_ANDAMENTO
  Assert.IsTrue(TClientUtils.PodeMudarStatus('EM_ANDAMENTO', 'CONCLUIDA'));
  Assert.IsTrue(TClientUtils.PodeMudarStatus('EM_ANDAMENTO', 'CANCELADA'));
  Assert.IsTrue(TClientUtils.PodeMudarStatus('EM_ANDAMENTO', 'PENDENTE'));

  // CANCELADA
  Assert.IsTrue(TClientUtils.PodeMudarStatus('CANCELADA', 'PENDENTE'));
  Assert.IsFalse(TClientUtils.PodeMudarStatus('CANCELADA', 'EM_ANDAMENTO'));

  // CONCLUIDA
  Assert.IsFalse(TClientUtils.PodeMudarStatus('CONCLUIDA', 'PENDENTE'));
end;

procedure TClientUtilsTests.TestDataISOToDisplay;
begin
  Assert.AreEqual('', TClientUtils.DataISOToDisplay(''));
  Assert.AreEqual('12/05/2026 14:10:04', TClientUtils.DataISOToDisplay('2026-05-12T14:10:04'));
  // Formato curto sem a letra T maiúscula retorna inalterado
  Assert.AreEqual('2026-05-12', TClientUtils.DataISOToDisplay('2026-05-12'));
end;

initialization
  TDUnitX.RegisterTestFixture(TClientUtilsTests);

end.

