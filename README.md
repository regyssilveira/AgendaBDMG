# Agenda BDMG - Sistema de Gerenciamento de Tarefas

O **Agenda BDMG** é um sistema completo e moderno de gerenciamento de tarefas desenvolvido em Delphi, arquitetado para demonstrar proficiência em padrões de projeto, arquitetura de software (Clean Code, SOLID) e separação de responsabilidades.

O projeto é dividido fisicamente em duas aplicações independentes que se comunicam via API REST, promovendo escalabilidade, manutenibilidade e segurança.

---

## 🛠️ Tecnologias e Bibliotecas Utilizadas

- **Linguagem:** Object Pascal (Delphi 13)
- **Gerenciador de Dependências:** [Boss](https://github.com/HashLoad/boss)
- **Backend (API RESTful):** [Horse](https://github.com/HashLoad/horse) v3.2.0
- **Frontend (Cliente VCL):** Delphi VCL nativo + [RESTRequest4Delphi](https://github.com/viniciussanchez/RESTRequest4Delphi) v4.0.23
- **Banco de Dados:** Microsoft SQL Server
- **Acesso a Dados:** FireDAC (com Connection Pooling)

---

## 🏛️ Arquitetura do Sistema

A solução adota a abordagem de **Monorepo** com separação física de projetos (`server` e `client`).

### 1. Banco de Dados
A modelagem conta com a tabela principal `Tarefas`. A persistência e consistência dos dados são garantidas a nível de SGBD através de:
- **Constraints (CHECK):** Validação rígida de domínio no banco para os campos `Status` (PENDENTE, EM_ANDAMENTO, CONCLUIDA, CANCELADA) e `Prioridade` (1 a 5).
- **Índices Filtrados (Filtered Indexes):** Criação de índices específicos desconsiderando tarefas excluídas (Soft Delete), garantindo máxima performance na listagem de dados ativos.
- **Soft Delete:** Tarefas nunca são apagadas fisicamente. Apenas o campo `DataExclusao` é preenchido, preservando o histórico de dados.

### 2. Backend (Server API)
A API foi construída sob os princípios do Clean Architecture, dividida em camadas muito bem definidas:
- **Models / Entities:** Representação das entidades de negócio e seus comportamentos (Enums e validações de estado).
- **Interfaces:** Contratos definidos (`ITarefaRepository`, `ITarefaService`) para inverter dependências e facilitar testes unitários futuros.
- **DTOs (Data Transfer Objects):** Isolação completa entre a estrutura do Banco de Dados e os dados trafegados na API. Há DTOs específicos para Criação, Atualização, Alteração de Status, Resposta, e Paginação.
- **Repository:** Centraliza todo o SQL e uso do FireDAC (`TFDQuery`), entregando coleções de Models. O banco conta com **Connection Pooling** ativo para alta performance em concorrência.
- **Service:** Onde a regra de negócio vive. Valida limites de caracteres, transições de status válidas (ex: uma tarefa `CONCLUIDA` não pode voltar para `PENDENTE`), regras de prioridade e preenchimento automático de datas (como a `DataConclusao`).
- **Middlewares Globais:**
  - `AuthMiddleware`: Intercepta rotas validando o header `X-API-KEY`.
  - `ErrorHandlerMiddleware`: Captura exceções não tratadas e devolve um JSON formatado com o código HTTP adequado (evitando leak de stack trace).
  - `LoggerMiddleware`: Audita todas as requisições, métricas de tempo (ms) e status HTTP gravando em arquivos físicos de log (`/logs/yyyy-mm-dd.log`).
- **Controllers:** Orquestram as chamadas, parse de rotas/parâmetros do Horse e invocação dos Services através das Factories.

### 3. Frontend (Client VCL)
O Client Desktop interage exclusivamente com a API:
- **Client Configuration:** Lê propriedades como Host, Porta e API Key de um arquivo local `client.ini`.
- **Camada de Serviço (TTarefaApiService):** Usa o `RESTRequest4Delphi` de forma fluente (`TRequest.New.BaseURL(...).Get`) abstraindo completamente o HTTP dos formulários VCL.
- **Formulários Visuais:**
  - `TfrmPrincipal`: Um painel intuitivo com um Dashboard de indicadores em tempo real (Total de Tarefas, Média de Prioridade e Tarefas Concluídas nos últimos 7 dias). Possui filtros avançados, listagem com DataGrid (in-memory dataset) e paginação completa.
  - `TfrmTarefa`: Modal de criação e edição com tratamento amigável de campos e validações na interface.
  - `TfrmStatus`: Um formulário especializado de fluxo de trabalho. Só exibe os próximos "Status" possíveis baseados no estado atual da tarefa, impedindo que o usuário cometa um erro lógico (bloqueado pela UI antes mesmo de bater na API).

---

## 🚀 Como Configurar e Executar

Siga as etapas abaixo para ter o ambiente rodando localmente de forma rápida:

### 1. Preparação do Banco de Dados
Certifique-se de possuir acesso a uma instância do MS SQL Server.
1. Acesse a pasta `/sql/`.
2. Execute o script `001_create_database.sql` para criar o schema `AgendaBDMG`.
3. Execute o script `002_create_table_tarefas.sql`. Ele irá criar a tabela, as constraints, os índices e **inserir 5 tarefas de exemplo (Seed)**.

### 2. Configurando o Ambiente
As aplicações leem arquivos `.ini` físicos para suas configurações (banco, portas, API keys).
Se os arquivos não existirem na primeira execução, as aplicações os criarão com dados padrão.

Para configurar antes de abrir:
1. Copie o arquivo `server.ini.example` localizado na raiz para a pasta onde o `server.exe` será compilado, renomeando-o para `server.ini`. Ajuste o `[Database]Username` e `[Database]Password`.
2. O sistema usa uma chave de segurança nativa (padrão: `agenda-BDMG-dev-key-2026`). Verifique se a chave é idêntica no `server.ini` e no `client.ini` (copiado do `client.ini.example`).

### 3. Instalando as Dependências e Compilando o Backend
1. Abra o prompt de comando (CMD/PowerShell) na pasta `/server/`.
2. Execute o comando `boss install` (requer o Boss instalado na máquina). Isso fará o download do Horse.
3. Abra o projeto no Delphi ou compile via terminal: `dcc32 server.dpr`.
4. Execute o `server.exe`. Você verá uma mensagem no console: `Server running on port 9000`.

### 4. Instalando as Dependências e Compilando o Frontend
1. Abra o prompt de comando (CMD/PowerShell) na pasta `/client/`.
2. Execute o comando `boss install github.com/viniciussanchez/RESTRequest4Delphi`.
3. Abra o projeto no Delphi ou compile via terminal: `dcc32 client.dpr`.
4. Execute o `client.exe`. A tela carregará as configurações, fará o login automático pela API Key informada e carregará as tarefas simuladas inseridas pelo script SQL.

---

## 📡 Documentação da API REST

A API conta com endpoints ricos e testáveis via a [Collection do Postman](./postman/AgendaBDMG.postman_collection.json) incluída no projeto. Basta importá-la no Postman ou Insomnia.

| Método | Endpoint | Descrição | Status HTTP |
|---|---|---|---|
| GET | `/api/health` | Verifica a integridade e uptime da API (sem Auth) | 200 OK |
| GET | `/api/tarefas` | Listagem com parâmetros: `page`, `limit`, `status`, `prioridade`, `ordem` | 200 OK |
| GET | `/api/tarefas/:id` | Recupera detalhes de uma tarefa ativa | 200 OK / 404 NotFound |
| POST | `/api/tarefas` | Cria uma nova tarefa | 201 Created |
| PUT | `/api/tarefas/:id` | Atualiza dados descritivos e prioridade | 200 OK / 404 NotFound |
| PUT | `/api/tarefas/:id/status`| Aciona a transição de status (valida a máquina de estado) | 200 OK / 422 Unprocessable |
| DELETE| `/api/tarefas/:id` | Oculta a tarefa do sistema (Soft Delete) | 200 OK / 404 NotFound |
| GET | `/api/estatisticas` | Executa as métricas (KPIs) usadas no Dashboard do Cliente | 200 OK |

Todos os endpoints (exceto o health) esperam o cabeçalho: `X-API-KEY: agenda-BDMG-dev-key-2026`. Em caso de ausência ou valor incorreto, a API devolve código HTTP 401 Unauthorized, gerido nativamente pelo `AuthMiddleware`.

---
*Agenda BDMG foi construído primando pela qualidade de código e solidez estrutural.*
