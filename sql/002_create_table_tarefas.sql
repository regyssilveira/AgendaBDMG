USE AgendaMontreal;
GO

CREATE TABLE Tarefas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Titulo VARCHAR(150) NOT NULL,
    Descricao VARCHAR(1000),
    Prioridade INT NOT NULL CHECK (Prioridade BETWEEN 1 AND 5),
    Status VARCHAR(30) NOT NULL CHECK (Status IN ('PENDENTE', 'EM_ANDAMENTO', 'CONCLUIDA', 'CANCELADA')),
    DataCriacao DATETIME NOT NULL DEFAULT GETDATE(),
    DataConclusao DATETIME NULL,
    DataExclusao DATETIME NULL
);
GO

-- Índices para otimização de consultas frequentes
CREATE INDEX IX_Tarefas_Status ON Tarefas (Status) WHERE DataExclusao IS NULL;
CREATE INDEX IX_Tarefas_DataExclusao ON Tarefas (DataExclusao);
CREATE INDEX IX_Tarefas_DataConclusao ON Tarefas (DataConclusao) WHERE Status = 'CONCLUIDA';
CREATE INDEX IX_Tarefas_Prioridade ON Tarefas (Prioridade) WHERE DataExclusao IS NULL;
GO

-- Seed data
INSERT INTO Tarefas (Titulo, Descricao, Prioridade, Status, DataCriacao)
VALUES 
    ('Configurar ambiente', 'Instalar Delphi, SQL Server e Boss', 5, 'CONCLUIDA', DATEADD(DAY, -2, GETDATE())),
    ('Criar banco de dados', 'Executar scripts SQL de criação', 5, 'PENDENTE', GETDATE()),
    ('Desenvolver API REST', 'Implementar rotas usando Horse', 4, 'PENDENTE', GETDATE()),
    ('Criar interface VCL', 'Desenvolver forms e grids', 3, 'PENDENTE', GETDATE()),
    ('Escrever documentação', 'Atualizar README e Postman', 2, 'PENDENTE', GETDATE());

-- Atualizar data de conclusão para a tarefa concluída
UPDATE Tarefas SET DataConclusao = GETDATE() WHERE Id = 1;
GO
