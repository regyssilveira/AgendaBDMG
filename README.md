# AgendaMontreal

Sistema de Gerenciamento de Tarefas completo em Delphi (Backend Horse REST + Frontend VCL), construído com boas práticas, separação de responsabilidades (Clean Code) e padronização.

## Tecnologias Utilizadas

- **Delphi 13** (dcc32 v37.0)
- **Boss** v3.0.12 (Gerenciador de Dependências)
- **Horse** v3.2.0 (Framework REST Backend)
- **RESTRequest4Delphi** v4.0.23 (Client REST Frontend)
- **SQL Server** (Banco de Dados)
- **FireDAC** (Acesso a dados com Connection Pooling)

## Estrutura do Projeto

O repositório é dividido em duas aplicações principais:

- `server/`: API RESTful backend construída com Horse. Implementa a camada de acesso a banco de dados com FireDAC, regras de negócio isoladas em Services e Middlewares (Auth, ErrorHandler, Logger).
- `client/`: Aplicação Desktop VCL consumindo a API. Contém formulários modulares (Principal, Tarefa, Status) e encapsula a camada de chamadas REST via `TTarefaApiService`.

## Como Configurar e Executar

### 1. Banco de Dados (SQL Server)

Na pasta `sql/`, execute os scripts na ordem:
1. `001_create_database.sql` (Cria o banco de dados `AgendaMontreal`)
2. `002_create_table_tarefas.sql` (Cria a tabela, índices otimizados e insere dados iniciais de exemplo).

### 2. Configurações (.ini)

Ambos os projetos dependem de um arquivo `.ini` de configuração que é gerado automaticamente na primeira execução com valores padrão (baseados no `.ini.example`). 

Caso queira configurar antes de executar:
- Copie `server.ini.example` para a pasta do `server.exe` (ou onde for executar o projeto server) e renomeie para `server.ini`. Ajuste credenciais do banco.
- Copie `client.ini.example` para a pasta do `client.exe` (ou onde for executar o projeto client) e renomeie para `client.ini`.

**Chave da API:** O backend exige que todas as requisições (exceto `/api/health`) possuam o header `X-API-KEY`. O padrão gerado é `agenda-montreal-dev-key-2026`. Essa chave deve ser igual tanto no `server.ini` quanto no `client.ini`.

### 3. Executando o Backend

1. Abra o prompt de comando na pasta `server/`.
2. Restaure dependências: `boss install`
3. Compile o projeto: `dcc32 server.dpr` (ou compile pela IDE do Delphi).
4. Execute `server.exe`. O console informará a porta em que o servidor está escutando (padrão `9000`).

### 4. Executando o Frontend

1. Abra o prompt de comando na pasta `client/`.
2. Restaure dependências: `boss install` (se necessário, certifique-se de usar `boss install github.com/viniciussanchez/RESTRequest4Delphi`).
3. Compile o projeto: `dcc32 client.dpr` (ou compile pela IDE do Delphi).
4. Execute `client.exe`. A tela principal carregará a grid vazia se o servidor estiver off, ou preenchida com as tarefas do Seed se o servidor e banco estiverem configurados corretamente.

## API Endpoints

A documentação interativa das requisições está disponível via **Postman Collection** na pasta `postman/`.

| Endpoint | Método | Funcionalidade |
|---|---|---|
| `/api/health` | GET | Verifica se o servidor está online |
| `/api/tarefas` | GET | Lista tarefas (com paginação e filtros) |
| `/api/tarefas/:id` | GET | Obtém os detalhes de uma tarefa específica |
| `/api/tarefas` | POST | Cria uma nova tarefa |
| `/api/tarefas/:id` | PUT | Atualiza uma tarefa (Título, Descrição, Prioridade) |
| `/api/tarefas/:id/status` | PUT | Transita o status de uma tarefa |
| `/api/tarefas/:id` | DELETE | Exclui uma tarefa (Soft Delete) |
| `/api/estatisticas` | GET | Obtém painel de indicadores (KPIs) |

---
**Desenvolvido para o teste prático.**
