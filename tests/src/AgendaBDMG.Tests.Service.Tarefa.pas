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
    procedure TestErroTituloExcedido;

    [Test]
    procedure TestErroPrioridadeInvalida;

    [Test]
    procedure TestErroDescricaoExcedida;

    [Test]
    procedure TestListarPaginacaoPadrao;

    [Test]
    procedure ObterPorIdExistente;

    [Test]
    procedure ObterPorIdInexistente;

    [Test]
    procedure TestAtualizarValido;

    [Test]
    procedure TestAtualizarInexistente;

    [Test]
    procedure TestAtualizarStatusMaquinaDeEstados;

    [Test]
    procedure TestAtualizarStatusParaConcluidaPreencheData;

    [Test]
    procedure TestAtualizarStatusInvalidoString;

    [Test]
    procedure TestAtualizarStatusInexistente;

    [Test]
    procedure TestRemoverExistente;

    [Test]
    procedure TestRemoverInexistente;

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

procedure TServiceTarefaTests.TestErroTituloExcedido;
begin
  Assert.WillRaise(
    procedure
    var
      LDto: TTarefaCreateDTO;
      LRes: TTarefaResponseDTO;
    begin
      LDto := TTarefaCreateDTO.Create;
      try
        LDto.Titulo := StringOfChar('A', 151); // 151 caracteres
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

procedure TServiceTarefaTests.TestErroDescricaoExcedida;
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
        LDto.Descricao := StringOfChar('B', 1001); // 1001 caracteres
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

procedure TServiceTarefaTests.TestListarPaginacaoPadrao;
var
  LDto: TTarefaCreateDTO;
  LResCriada: TTarefaResponseDTO;
  LLista: TListaTarefasResponseDTO;
begin
  LDto := TTarefaCreateDTO.Create;
  try
    LDto.Titulo := 'Tarefa 1';
    LDto.Prioridade := 1;
    LResCriada := FService.Criar(LDto);
    LResCriada.Free;
  finally
    LDto.Free;
  end;

  // Força pagina e limite fora dos limites
  LLista := FService.Listar(0, 200, '', 0, '');
  try
    Assert.IsNotNull(LLista);
    Assert.AreEqual(1, LLista.Paginacao.PaginaAtual);
    Assert.AreEqual(100, LLista.Paginacao.ItensPorPagina); // Limite máximo é 100
    Assert.AreEqual(1, LLista.Paginacao.TotalItens);
    Assert.AreEqual(1, LLista.Dados.Count);
  finally
    LLista.Free;
  end;
end;

procedure TServiceTarefaTests.ObterPorIdExistente;
var
  LDto: TTarefaCreateDTO;
  LResCriada, LResObtida: TTarefaResponseDTO;
begin
  LDto := TTarefaCreateDTO.Create;
  try
    LDto.Titulo := 'Tarefa Existente';
    LDto.Prioridade := 4;
    LResCriada := FService.Criar(LDto);
  finally
    LDto.Free;
  end;

  try
    LResObtida := FService.ObterPorId(LResCriada.Id);
    try
      Assert.IsNotNull(LResObtida);
      Assert.AreEqual('Tarefa Existente', LResObtida.Titulo);
    finally
      LResObtida.Free;
    end;
  finally
    LResCriada.Free;
  end;
end;

procedure TServiceTarefaTests.ObterPorIdInexistente;
begin
  Assert.WillRaise(
    procedure
    var
      LRes: TTarefaResponseDTO;
    begin
      LRes := FService.ObterPorId(9999);
      LRes.Free;
    end,
    EHorseException
  );
end;

procedure TServiceTarefaTests.TestAtualizarValido;
var
  LDtoCreate: TTarefaCreateDTO;
  LDtoUpdate: TTarefaUpdateDTO;
  LResCriada, LResAtualizada: TTarefaResponseDTO;
begin
  LDtoCreate := TTarefaCreateDTO.Create;
  try
    LDtoCreate.Titulo := 'Titulo Original';
    LDtoCreate.Prioridade := 1;
    LResCriada := FService.Criar(LDtoCreate);
  finally
    LDtoCreate.Free;
  end;

  try
    LDtoUpdate := TTarefaUpdateDTO.Create;
    try
      LDtoUpdate.Titulo := 'Titulo Modificado';
      LDtoUpdate.Descricao := 'Nova Descricao';
      LDtoUpdate.Prioridade := 2;

      LResAtualizada := FService.Atualizar(LResCriada.Id, LDtoUpdate);
      try
        Assert.AreEqual('Titulo Modificado', LResAtualizada.Titulo);
        Assert.AreEqual('Nova Descricao', LResAtualizada.Descricao);
        Assert.AreEqual(2, LResAtualizada.Prioridade);
      finally
        LResAtualizada.Free;
      end;
    finally
      LDtoUpdate.Free;
    end;
  finally
    LResCriada.Free;
  end;
end;

procedure TServiceTarefaTests.TestAtualizarInexistente;
begin
  Assert.WillRaise(
    procedure
    var
      LDto: TTarefaUpdateDTO;
      LRes: TTarefaResponseDTO;
    begin
      LDto := TTarefaUpdateDTO.Create;
      try
        LDto.Titulo := 'Valido';
        LDto.Prioridade := 1;
        LRes := FService.Atualizar(9999, LDto);
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

procedure TServiceTarefaTests.TestAtualizarStatusParaConcluidaPreencheData;
var
  LDto: TTarefaCreateDTO;
  LResCriada: TTarefaResponseDTO;
  LStatusDto: TTarefaStatusDTO;
  LResStatus1, LResStatus2: TTarefaResponseDTO;
begin
  LDto := TTarefaCreateDTO.Create;
  try
    LDto.Titulo := 'Tarefa a Concluir';
    LDto.Prioridade := 3;
    LResCriada := FService.Criar(LDto);
  finally
    LDto.Free;
  end;

  try
    // Primeiro move para Em Andamento
    LStatusDto := TTarefaStatusDTO.Create;
    try
      LStatusDto.Status := 'EM_ANDAMENTO';
      LResStatus1 := FService.AtualizarStatus(LResCriada.Id, LStatusDto);
      LResStatus1.Free;
    finally
      LStatusDto.Free;
    end;

    // Depois move para Concluida
    LStatusDto := TTarefaStatusDTO.Create;
    try
      LStatusDto.Status := 'CONCLUIDA';
      LResStatus2 := FService.AtualizarStatus(LResCriada.Id, LStatusDto);
      try
        Assert.AreEqual('CONCLUIDA', LResStatus2.Status);
        Assert.IsNotEmpty(LResStatus2.DataConclusao);
      finally
        LResStatus2.Free;
      end;
    finally
      LStatusDto.Free;
    end;
  finally
    LResCriada.Free;
  end;
end;

procedure TServiceTarefaTests.TestAtualizarStatusInvalidoString;
begin
  Assert.WillRaise(
    procedure
    var
      LStatusDto: TTarefaStatusDTO;
      LRes: TTarefaResponseDTO;
    begin
      LStatusDto := TTarefaStatusDTO.Create;
      try
        LStatusDto.Status := 'STATUS_DESCONHECIDO';
        LRes := FService.AtualizarStatus(1, LStatusDto);
        LRes.Free;
      finally
        LStatusDto.Free;
      end;
    end,
    EHorseException
  );
end;

procedure TServiceTarefaTests.TestAtualizarStatusInexistente;
begin
  Assert.WillRaise(
    procedure
    var
      LStatusDto: TTarefaStatusDTO;
      LRes: TTarefaResponseDTO;
    begin
      LStatusDto := TTarefaStatusDTO.Create;
      try
        LStatusDto.Status := 'EM_ANDAMENTO';
        LRes := FService.AtualizarStatus(9999, LStatusDto);
        LRes.Free;
      finally
        LStatusDto.Free;
      end;
    end,
    EHorseException
  );
end;

procedure TServiceTarefaTests.TestRemoverExistente;
var
  LDto: TTarefaCreateDTO;
  LResCriada: TTarefaResponseDTO;
begin
  LDto := TTarefaCreateDTO.Create;
  try
    LDto.Titulo := 'Para Remover';
    LDto.Prioridade := 1;
    LResCriada := FService.Criar(LDto);
  finally
    LDto.Free;
  end;

  try
    FService.Remover(LResCriada.Id);
    
    // Tenta obter e deve dar erro 404
    Assert.WillRaise(
      procedure
      var
        LRes: TTarefaResponseDTO;
      begin
        LRes := FService.ObterPorId(LResCriada.Id);
        LRes.Free;
      end,
      EHorseException
    );
  finally
    LResCriada.Free;
  end;
end;

procedure TServiceTarefaTests.TestRemoverInexistente;
begin
  Assert.WillRaise(
    procedure
    begin
      FService.Remover(9999);
    end,
    EHorseException
  );
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
