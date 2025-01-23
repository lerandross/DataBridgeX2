

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
├── pyproject.toml      # Configurações do projeto Poetry
├── poetry.lock         # Lockfile do Poetry
└── README.md          # Documentação do projeto
 