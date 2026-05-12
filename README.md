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
  - `CORSMiddleware`: Permite o consumo seguro da API por origens externas (cross-origin).
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

## 🚀 Passo a Passo de Execução para Iniciantes

Para que qualquer pessoa (mesmo sem experiência prévia com Delphi) consiga rodar o sistema completo localmente em poucos minutos, elaboramos este guia passo a passo detalhado:

### Etapa 0: Pré-requisitos e Instalação das Ferramentas (Para Leigos)

Antes de iniciar, você precisará de duas ferramentas essenciais configuradas no seu ambiente Windows. Caso ainda não as possua, siga as instruções abaixo:

#### 1. Docker Desktop (Para rodar o Banco de Dados)
O Docker permite executar o SQL Server em um ambiente isolado (container) sem a necessidade de instalar o banco de dados pesado diretamente na sua máquina.
* **Onde baixar:** Acesse o site oficial em [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) e clique em **Download for Windows**.
* **Como instalar:**
  1. Execute o instalador baixado (`Docker Desktop Installer.exe`).
  2. Mantenha as opções recomendadas marcadas (especialmente a de usar o **WSL 2** se solicitada).
  3. Prossiga até o fim e, se necessário, reinicie o computador.
  4. Abra o aplicativo **Docker Desktop** pelo menu Iniciar e aguarde até que a engine esteja iniciada e rodando perfeitamente.

#### 2. Boss (Gerenciador de Dependências do Delphi)
O Boss atua baixando e gerenciando as bibliotecas de terceiros que o projeto utiliza (como o Horse e o RESTRequest4Delphi), de forma parecida com o `npm` no ecossistema JavaScript ou `NuGet` no C#.
* **Onde baixar:** Acesse a página oficial de lançamentos no GitHub: [HashLoad/boss/releases](https://github.com/HashLoad/boss/releases).
* **Como instalar no Windows:**
  1. Baixe o arquivo `.zip` da versão mais recente para Windows (ex: `boss-windows-x86_64.zip`).
  2. Crie uma pasta fixa no seu computador para armazenar a ferramenta (por exemplo, `C:\Ferramentas\Boss\`) e extraia o arquivo `boss.exe` dentro dela.
  3. **Adicione o Boss ao PATH do Windows** para que os terminais consigam reconhecer o comando globalmente:
     * Pressione a tecla `Windows`, digite **Variáveis de Ambiente** e clique em **Editar as variáveis de ambiente do sistema**.
     * Clique no botão **Variáveis de Ambiente...** na aba Avançado.
     * Na lista de *Variáveis do sistema* (ou de usuário), selecione a variável `Path` e clique em **Editar...**.
     * Clique no botão **Novo**, cole o caminho da pasta criada (ex: `C:\Ferramentas\Boss`) e pressione Enter.
     * Clique em **OK** em todas as janelas para aplicar.
  4. Para testar se tudo deu certo, abra um **novo** terminal (PowerShell ou Prompt de Comando) e digite:
     ```bash
     boss --version
     ```
     Se o terminal retornar o número da versão, o Boss está pronto para uso!

---

### Etapa 1: Subindo o Banco de Dados (SQL Server)
O sistema precisa de um banco de dados para salvar as tarefas. A forma mais simples e rápida é usar o Docker já incluso no projeto:

1. Certifique-se de ter o **Docker Desktop** instalado e aberto no seu Windows.
2. Abra um terminal (PowerShell ou Prompt de Comando) na pasta raiz do projeto.
3. Digite o comando abaixo e pressione Enter:
   ```bash
   docker-compose up -d
   ```
4. O Docker baixará a imagem oficial do SQL Server 2022 e iniciará o banco na porta padrão `1433` com a senha ultrassegura `SuaSenha@123`.
5. Abra o seu gerenciador de banco de dados favorito (como o **DBeaver** ou o **SSMS**) e conecte-se em `localhost:1433` usando o usuário `sa` e a senha `SuaSenha@123`.
6. Abra e execute os dois scripts localizados na pasta `/sql/`:
   * Primeiro rode o `001_create_database.sql` para criar o banco de dados vazio.
   * Em seguida, rode o `002_create_table_tarefas.sql` para criar as tabelas e popular o sistema com tarefas de demonstração iniciais.

---

### Etapa 2: Configurando as Chaves e Senhas
Tanto o servidor quanto o cliente utilizam arquivos simples de texto (`.ini`) para saber onde está o banco e qual é a chave secreta de comunicação.

1. Na pasta raiz do projeto, localize o arquivo chamado `server.ini.example`. Copie e cole este arquivo dentro da pasta `/server/`, renomeando a cópia para **`server.ini`**.
2. Abra o `server.ini` em um bloco de notas. Verifique se as configurações de banco correspondem ao Docker (usuário `sa` e senha `SuaSenha@123`).
3. Localize o arquivo `client.ini.example` na raiz do projeto. Copie e cole dentro da pasta `/client/`, renomeando a cópia para **`client.ini`**. Certifique-se de que a porta configurada no cliente corresponda à porta em que a API atende (padrão **9005**).
4. Ambos os arquivos já vêm configurados com a chave de segurança padrão (`agenda-BDMG-dev-key-2026`). Não é necessário alterá-la para testes locais.

---

### Etapa 3: Compilando e Rodando o Servidor (Backend API)
1. Abra um terminal dentro da pasta `/server/`.
2. Baixe as dependências do projeto executando o gerenciador de pacotes do Delphi:
   ```bash
   boss install
   ```
3. Compile o servidor executando o compilador de linha de comando do Delphi:
   ```bash
   dcc32 server.dpr
   ```
4. Inicie o executável gerado:
   ```bash
   .\server.exe
   ```
5. **Sucesso!** Uma janela de console se abrirá exibindo um painel de status completo, informando que a API está **ONLINE na porta 9005**. Deixe esta janela aberta.

---

### Etapa 4: Explorando a Documentação Viva (Swagger UI)
Com o servidor rodando, você pode testar a API diretamente pelo navegador sem precisar de nenhuma ferramenta externa!

* **Página Inicial de Boas-Vindas:** Abra [http://localhost:9005/api](http://localhost:9005/api) para ver o painel inicial.
* **Interface Interativa do Swagger:** Acesse [http://localhost:9005/swagger/doc/html](http://localhost:9005/swagger/doc/html). 
  Pelo Swagger UI, você visualiza todos os campos, descrições em português e pode clicar em *"Try it out"* para enviar requisições reais para o servidor.

---

### Etapa 5: Rodando o Aplicativo Desktop (Client VCL)
1. Abra um terminal dentro da pasta `/client/`.
2. Baixe a biblioteca de requisições REST executando:
   ```bash
   boss install github.com/viniciussanchez/RESTRequest4Delphi
   ```
3. Compile o aplicativo cliente:
   ```bash
   dcc32 client.dpr
   ```
4. Inicie o aplicativo:
   ```bash
   .\client.exe
   ```
5. **Pronto!** A interface gráfica moderna carregará automaticamente, conectando-se à API e listando todas as tarefas cadastradas com totalizadores estatísticos em tempo real.

---

### Etapa 6: Rodando os Testes Unitários Automatizados
O projeto conta com uma suíte robusta e abrangente de testes automatizados unitários construída com **DUnitX**, que valida isoladamente tanto o domínio e a inteligência dos serviços do **Backend** (com *Mocks* em memória de repositório, validações de texto, limites e regras da máquina de estados), quanto as lógicas e utilitários estáticos do **Frontend / Client**, tudo sem exigir SGBD ativo ou conexão HTTP.

Como os utilitários da API compartilham conversores com o **GBSwagger**, a pasta de testes conta com seu próprio gerenciador de pacotes para manter a compilação fluida:

1. Abra um terminal dentro da pasta `/tests/`.
2. Baixe as dependências exigidas pelos utilitários da suíte:
   ```bash
   boss install
   ```
3. Compile o executável de testes apontando para os códigos-fonte do servidor:
   ```bash
   dcc32 -U"..\server\src\model;..\server\src\dto;..\server\src\interfaces;..\server\src\service;..\server\src\utils;..\server\modules\horse\src;..\server\modules\gbswagger\Source\Core;..\server\modules\gbswagger\Source\JSON" -NS"System;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Vcl" AgendaBDMG.Tests.dpr
   ```
4. Execute o binário gerado:
   ```bash
   .\AgendaBDMG.Tests.exe
   ```
5. Você acompanhará a auditoria limpa do DUnitX atestando **100% de sucesso** e **0 vazamentos de memória** (*0 bytes leaked*).

---

## 📡 Referência Rápida dos Endpoints da API

Para integrações externas (como o frontend em Angular ou via Postman), a API responde nos seguintes endereços baseados em `http://localhost:9005/api`:

| Método | Endpoint | Descrição | Status HTTP |
|---|---|---|---|
| **GET** | `/health` | Monitoramento de integridade e uptime da API (Público) | `200 OK` |
| **GET** | `/tarefas` | Lista tarefas ativas com paginação e filtros | `200 OK` |
| **GET** | `/tarefas/:id` | Retorna os detalhes completos de uma tarefa específica | `200 OK` / `404 Not Found` |
| **POST** | `/tarefas` | Cadastra uma nova tarefa no banco de dados | `201 Created` |
| **PUT** | `/tarefas/:id` | Edita o título, descrição e prioridade de uma tarefa | `200 OK` / `404 Not Found` |
| **PUT** | `/tarefas/:id/status`| Altera o status validando regras lógicas de transição | `200 OK` / `422 Unprocessable` |
| **DELETE**| `/tarefas/:id` | Realiza a exclusão lógica (*Soft Delete*) da tarefa | `200 OK` / `404 Not Found` |
| **GET** | `/estatisticas` | Retorna os KPIs consolidados para os painéis de dashboard | `200 OK` |

> **Autenticação Obrigatória:** Todas as rotas (exceto `/health`, a raiz `/api` e o Swagger) exigem o envio do cabeçalho de segurança:
> `X-API-KEY: agenda-BDMG-dev-key-2026`

---
*Agenda BDMG foi construído primando pela excelência em engenharia de software, legibilidade e alta manutenibilidade.*
