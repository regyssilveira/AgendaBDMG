unit AgendaBDMG.Tests.Model.Tarefa;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  AgendaBDMG.Model.Tarefa;

type
  [TestFixture]
  TModelTarefaTests = class
  public
    [Test]
    procedure TestCriacaoInicial;

    [Test]
    procedure TestStatusFromStringValido;

    [Test]
    procedure TestStatusFromStringInvalido;

    [Test]
    procedure TestStatusToString;

    [Test]
    procedure TestTransicoesValidas;

    [Test]
    procedure TestBloqueioEstadoFinal;
  end;

implementation

{ TModelTarefaTests }

procedure TModelTarefaTests.TestCriacaoInicial;
var
  LTarefa: TTarefa;
begin
  LTarefa := TTarefa.Create;
  try
    Assert.AreEqual(stPendente, LTarefa.Status);
    Assert.AreEqual<TDateTime>(0, LTarefa.DataConclusao);
    Assert.AreEqual<TDateTime>(0, LTarefa.DataExclusao);
  finally
    LTarefa.Free;
  end;
end;

procedure TModelTarefaTests.TestStatusFromStringValido;
begin
  Assert.AreEqual(stPendente, TStatusTarefa.FromString('PENDENTE'));
  Assert.AreEqual(stEmAndamento, TStatusTarefa.FromString('EM_ANDAMENTO'));
  Assert.AreEqual(stConcluida, TStatusTarefa.FromString('CONCLUIDA'));
  Assert.AreEqual(stCancelada, TStatusTarefa.FromString('CANCELADA'));
  
  // Teste de insensibilidade a maiúsculas/minúsculas e espaços
  Assert.AreEqual(stPendente, TStatusTarefa.FromString('  pendente  '));
end;

procedure TModelTarefaTests.TestStatusFromStringInvalido;
begin
  Assert.WillRaise(
    procedure
    begin
      TStatusTarefa.FromString('STATUS_INEXISTENTE');
    end,
    Exception
  );
end;

procedure TModelTarefaTests.TestStatusToString;
begin
  Assert.AreEqual('PENDENTE', stPendente.ToString);
  Assert.AreEqual('EM_ANDAMENTO', stEmAndamento.ToString);
  Assert.AreEqual('CONCLUIDA', stConcluida.ToString);
  Assert.AreEqual('CANCELADA', stCancelada.ToString);
end;

procedure TModelTarefaTests.TestTransicoesValidas;
var
  LStatus: TStatusTarefa;
begin
  LStatus := stPendente;
  Assert.IsTrue(LStatus.PodeMudarPara(stEmAndamento));
  Assert.IsTrue(LStatus.PodeMudarPara(stCancelada));
  Assert.IsFalse(LStatus.PodeMudarPara(stConcluida)); // Não pode pular direto para concluída

  LStatus := stEmAndamento;
  Assert.IsTrue(LStatus.PodeMudarPara(stConcluida));
  Assert.IsTrue(LStatus.PodeMudarPara(stCancelada));
  Assert.IsTrue(LStatus.PodeMudarPara(stPendente));

  LStatus := stCancelada;
  Assert.IsTrue(LStatus.PodeMudarPara(stPendente));
  Assert.IsFalse(LStatus.PodeMudarPara(stEmAndamento));
  Assert.IsFalse(LStatus.PodeMudarPara(stConcluida));
end;

procedure TModelTarefaTests.TestBloqueioEstadoFinal;
var
  LStatus: TStatusTarefa;
begin
  LStatus := stConcluida;
  Assert.IsFalse(LStatus.PodeMudarPara(stPendente));
  Assert.IsFalse(LStatus.PodeMudarPara(stEmAndamento));
  Assert.IsFalse(LStatus.PodeMudarPara(stCancelada));
end;

initialization
  TDUnitX.RegisterTestFixture(TModelTarefaTests);

end.
