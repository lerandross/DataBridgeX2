

# Estrutura do projeto
```
DataBridgeX2/
├── Dockerfile          # Definição da imagem Docker
├── docker-compose.yaml # Orquestração dos containers
├── Makefile            # Automação de tarefas
├── sql
│   ├── migrations     # Migrações de banco de dados (ex: Flyway, Liquibase)
│   ├── procedures     # Stored procedures
│   ├── queries        # Consultas SELECT
│   ├── schema         # Definições de schema (DDL)
│   ├── scripts        # Scripts SQL para tarefas específicas
│   └── views          # Definições de schema (DDL)
├── data/              # Dados brutos (input) e dados processados (output)
│   │── raw/           # Dados extraídos diretamente das fontes
│   │   └── parquert/  # resultado das consultas em bancos são salvos aqui(dados bruto)
│   ├── transformed/   # Dados após as transformações
│   └── logs/          # Logs das execuções do ETL
├── scripts/           # Scripts Python ou SQL para ETL
│   ├── extract/       # Scripts de extração dos dados
│   ├── transform/     # Scripts de transformação dos dados
│   └── load/          # Scripts de carregamento dos dados
├── config/            # Arquivos de configuração (conexões com bancos, etc.)
│   ├── databases.yaml # Configurações de conexão com bancos de dados
│   └── etl.yaml       # Configurações específicas do ETL
├── tests/             # Testes unitários para os scripts
│   ├── extract/
│   ├── transform/
│   └── load/
├── pyproject.toml     # Configurações do projeto Poetry
├── poetry.lock        # Lockfile do Poetry
├── main.py            # codigo principal para a execução
└── README.md          # Documentação do projeto
```


# **Guia de Commits Padronizados**

Este documento explica como utilizar o comando `make commit` para criar mensagens de commit padronizadas e consistentes no projeto. O objetivo é manter o histórico de alterações organizado e facilitar o entendimento do trabalho realizado.

---

## **Como Fazer Commits**

### **Passo a Passo**

1. **Execute o comando para iniciar o processo de commit**:
   ```bash
   make commit
   ```

2. **Tipos Disponíveis**:  
   Escolha o **tipo de alteração** que melhor descreve sua modificação.  
   - O script exibirá os tipos válidos:
     ```
     Tipos disponíveis: feat fix chore docs style refactor test perf ci
     ```

3. **Escopos Permitidos**:  
   Escolha o **escopo** que melhor representa a parte do projeto afetada.  
   - O script exibirá os escopos válidos:
     ```
     Escopos permitidos: extract transform load schema migrations queries procedures views triggers config tests docs ci
     ```

4. **Informe os Detalhes do Commit**:  
   O processo interativo solicitará os seguintes inputs:
   - **Tipo de commit** (ex.: `feat`, `fix`, etc.).
   - **Escopo** do commit (ex.: `schema`, `queries`, etc.).  
     Caso você pressione Enter, será usado o escopo padrão: `geral`.
   - **Mensagem curta** para descrever brevemente a alteração.
   - **Descrição detalhada** (opcional) para fornecer mais informações.

---

## **Estrutura da Mensagem de Commit**

As mensagens de commit seguirão o padrão:

```
<tipo>(<escopo>): mensagem curta

[Descrição detalhada opcional]
```

### **Componentes**
1. **Tipo**: Define o tipo de alteração (ex.: `feat`, `fix`, etc.).
2. **Escopo**: Indica a parte do projeto afetada (ex.: `schema`, `queries`, etc.).
3. **Mensagem Curta**: Resumo da alteração realizada.
4. **Descrição Detalhada** (opcional): Explica em mais detalhes o que foi alterado e por quê.

---

## **Tipos de Commit**

| Tipo        | Quando Usar                                                           | Exemplo                                              |
|-------------|-----------------------------------------------------------------------|-----------------------------------------------------|
| `feat`      | Quando adicionar uma nova funcionalidade.                             | `feat(schema): cria tabela de clientes`            |
| `fix`       | Quando corrigir um bug ou erro.                                       | `fix(queries): corrige erro no join de pedidos`     |
| `chore`     | Para tarefas gerais, como organização de arquivos ou atualizações.    | `chore(migrations): renomeia scripts para consistência` |
| `docs`      | Quando alterar ou adicionar documentação.                             | `docs: adiciona seção sobre índices no README`      |
| `style`     | Alterações de estilo (formatação, espaçamento, etc.).                 | `style(queries): ajusta formatação de consultas`    |
| `refactor`  | Refatorações que não alteram o comportamento externo.                 | `refactor(load): melhora lógica de carregamento`    |
| `test`      | Adição ou ajuste de testes automatizados.                             | `test(schema): adiciona teste para constraints`     |
| `perf`      | Melhorias de performance.                                             | `perf(procedures): otimiza cálculo de saldos`       |
| `ci`        | Alterações relacionadas a integração contínua ou pipelines.           | `ci: adiciona execução de testes no pipeline`       |

---

## **Escopos Permitidos**

| Escopo         | Descrição                                                           |
|----------------|---------------------------------------------------------------------|
| `extract`      | Alterações no processo de extração de dados.                       |
| `transform`    | Alterações no processo de transformação de dados.                  |
| `load`         | Alterações no carregamento de dados no destino final.              |
| `schema`       | Alterações nas definições de tabelas, índices ou constraints.      |
| `migrations`   | Scripts de migração do banco de dados.                             |
| `queries`      | Scripts de consultas SQL (`SELECT`, `JOIN`, etc.).                 |
| `procedures`   | Alterações ou criação de stored procedures.                        |
| `views`        | Criação ou alteração de views no banco.                            |
| `triggers`     | Alterações ou criação de triggers no banco.                        |
| `config`       | Alterações em arquivos de configuração do projeto.                 |
| `tests`        | Alterações ou adição de testes relacionados a dados ou SQL.        |
| `docs`         | Alterações na documentação.                                        |
| `ci`           | Alterações em pipelines ou scripts de integração contínua.         |

---

## **Exemplos Práticos**

### **1. Adicionar uma Nova Tabela**
**Entrada no terminal**:
```bash
make commit
```

**Inputs fornecidos**:
```
Tipos disponíveis: feat fix chore docs style refactor test perf ci
Escopos permitidos: extract transform load schema migrations queries procedures views triggers config tests docs ci
Digite o tipo (ex: feat, fix): feat
Digite o escopo (ou pressione Enter para 'geral'): schema
Digite a mensagem curta do commit: cria tabela de usuários
Deseja adicionar uma descrição detalhada (s/n)? s
Digite a descrição detalhada (pressione Ctrl+D para terminar):
Tabela criada para armazenar dados dos usuários, incluindo nome, email e senha.
```

**Mensagem de Commit**:
```
feat(schema): cria tabela de usuários

Tabela criada para armazenar dados dos usuários, incluindo nome, email e senha.
```

---