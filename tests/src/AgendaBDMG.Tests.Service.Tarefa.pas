unit AgendaBDMG.Tests.Service.Tarefa;

interface

uses
  System.SysUtils,
  DUnitX.TestFramework,
  Horse.Exception,
  AgendaBDMG.Interfaces,
  AgendaBDMG.DTO.Tarefa,
  AgendaBDMG.Service.Tarefa,
  AgendaBDMG.Tests.Mocks;

type
  [TestFixture]
  TServiceTarefaTests = class
  private
    FRepository: ITarefaRepository;
    FService: ITarefaService;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestCriarTarefaValida;

    [Test]
    procedure TestErroTituloVazio;

    [Test]
    procedure TestErroPrioridadeInvalida;

    [Test]
    procedure TestAtualizarStatusMaquinaDeEstados;

    [Test]
    procedure TestCalculoEstatisticas;
  end;

implementation

{ TServiceTarefaTests }

procedure TServiceTarefaTests.Setup;
begin
  FRepository := TTarefaRepositoryMock.Create;
  FService := TTarefaService.Create(FRepository);
end;

procedure TServiceTarefaTests.TearDown;
begin
  FService := nil;
  FRepository := nil;
end;

procedure TServiceTarefaTests.TestCriarTarefaValida;
var
  LDto: TTarefaCreateDTO;
  LRes: TTarefaResponseDTO;
begin
  LDto := TTarefaCreateDTO.Create;
  try
    LDto.Titulo := 'Tarefa de Teste Unitário';
    LDto.Descricao := 'Descrição da tarefa injetada via mock';
    LDto.Prioridade := 5;

    LRes := FService.Criar(LDto);
    try
      Assert.IsNotNull(LRes);
      Assert.IsTrue(LRes.Id > 0);
      Assert.AreEqual('Tarefa de Teste Unitário', LRes.Titulo);
      Assert.AreEqual('PENDENTE', LRes.Status);
    finally
      LRes.Free;
    end;
  finally
    LDto.Free;
  end;
end;

procedure TServiceTarefaTests.TestErroTituloVazio;
begin
  Assert.WillRaise(
    procedure
    var
      LDto: TTarefaCreateDTO;
      LRes: TTarefaResponseDTO;
    begin
      LDto := TTarefaCreateDTO.Create;
      try
        LDto.Titulo := '   '; // Título em branco
        LDto.Prioridade := 3;
        LRes := FService.Criar(LDto);
        LRes.Free;
      finally
        LDto.Free;
      end;
    end,
    EHorseException
  );
end;

procedure TServiceTarefaTests.TestErroPrioridadeInvalida;
begin
  Assert.WillRaise(
    procedure
    var
      LDto: TTarefaCreateDTO;
      LRes: TTarefaResponseDTO;
    begin
      LDto := TTarefaCreateDTO.Create;
      try
        LDto.Titulo := 'Título Válido';
        LDto.Prioridade := 6; // Prioridade fora do range
        LRes := FService.Criar(LDto);
        LRes.Free;
      finally
        LDto.Free;
      end;
    end,
    EHorseException
  );
end;

procedure TServiceTarefaTests.TestAtualizarStatusMaquinaDeEstados;
var
  LDto: TTarefaCreateDTO;
  LResCriada: TTarefaResponseDTO;
  LStatusDto: TTarefaStatusDTO;
  LResStatus: TTarefaResponseDTO;
begin
  // 1. Cria a tarefa pendente
  LDto := TTarefaCreateDTO.Create;
  try
    LDto.Titulo := 'Tarefa Maquina de Estados';
    LDto.Prioridade := 2;
    LResCriada := FService.Criar(LDto);
  finally
    LDto.Free;
  end;

  try
    // 2. Tenta transição inválida direto para Concluída (dispara 422)
    Assert.WillRaise(
      procedure
      var
        LStatusDtoFail: TTarefaStatusDTO;
        LResStatusFail: TTarefaResponseDTO;
      begin
        LStatusDtoFail := TTarefaStatusDTO.Create;
        try
          LStatusDtoFail.Status := 'CONCLUIDA';
          LResStatusFail := FService.AtualizarStatus(LResCriada.Id, LStatusDtoFail);
          LResStatusFail.Free;
        finally
          LStatusDtoFail.Free;
        end;
      end,
      EHorseException
    );

    // 3. Tenta transição válida para Em Andamento
    LStatusDto := TTarefaStatusDTO.Create;
    try
      LStatusDto.Status := 'EM_ANDAMENTO';
      LResStatus := FService.AtualizarStatus(LResCriada.Id, LStatusDto);
      try
        Assert.AreEqual('EM_ANDAMENTO', LResStatus.Status);
      finally
        LResStatus.Free;
      end;
    finally
      LStatusDto.Free;
    end;

  finally
    LResCriada.Free;
  end;
end;

procedure TServiceTarefaTests.TestCalculoEstatisticas;
var
  LDto: TTarefaCreateDTO;
  LRes: TTarefaResponseDTO;
  LEstat: TEstatisticasDTO;
  I: Integer;
begin
  // Insere 3 tarefas com prioridades 1, 3 e 5
  for I in [1, 3, 5] do
  begin
    LDto := TTarefaCreateDTO.Create;
    try
      LDto.Titulo := Format('Tarefa Prio %d', [I]);
      LDto.Prioridade := I;
      LRes := FService.Criar(LDto);
      LRes.Free;
    finally
      LDto.Free;
    end;
  end;

  // Calcula estatísticas
  LEstat := FService.ObterEstatisticas;
  try
    Assert.AreEqual(3, LEstat.TotalTarefas);
    // Média esperada: (1 + 3 + 5) / 3 = 3.0
    Assert.AreEqual<Double>(3.0, LEstat.MediaPrioridadePendentes);
    Assert.AreEqual(0, LEstat.TarefasConcluidasUltimos7Dias);
  finally
    LEstat.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TServiceTarefaTests);

end.
