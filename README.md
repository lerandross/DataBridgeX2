

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


# Guia de Commits Padronizados no Projeto

Este guia explica como estruturar e organizar commits de forma clara, padronizada e compreensível para todos os envolvidos no projeto. Ele segue o padrão **Conventional Commits**, uma abordagem amplamente utilizada para melhorar a legibilidade e a rastreabilidade no versionamento de código.

### Resumo
| **Tipo**      | **Quando Usar em SQL**                                   | **Exemplo**                                              |
|---------------|---------------------------------------------------------|----------------------------------------------------------|
| `feat`        | Nova funcionalidade ou tabela/view/procedure            | `feat(schema): cria tabela de pedidos`                  |
| `fix`         | Correção de erros em tabelas, consultas ou procedures    | `fix(queries): corrige join que retornava valores errados` |
| `chore`       | Reorganização ou ajustes não funcionais                  | `chore(sql): reorganiza diretório de scripts`           |
| `docs`        | Documentação ou comentários em SQL                      | `docs(schema): adiciona comentários nas tabelas`        |
| `refactor`    | Alteração na estrutura sem modificar comportamento       | `refactor(schema): altera estrutura de índices`         |
| `test`        | Criação ou ajuste de testes SQL                         | `test(procedures): adiciona testes para validar cálculo`|
| `perf`        | Melhoria de desempenho                                  | `perf(queries): otimiza consulta com índices`           |
| `style`       | Alterações cosméticas (formatação, alinhamento, etc.)    | `style(queries): ajusta formatação de consulta SQL`     |
| `ci`          | Scripts SQL em pipelines de CI/CD                       | `ci: adiciona execução de migrações SQL no pipeline`    |

---

## **Por Que Usar Commits Padronizados?**

1. **Clareza**: Facilita a compreensão do que foi alterado em cada commit.
2. **Organização**: Ajuda a categorizar mudanças (novas funcionalidades, correções, melhorias, etc.).
3. **Automação**: Permite a integração com ferramentas de CI/CD para gerar changelogs ou versões automaticamente.
4. **Colaboração**: Facilita para outros desenvolvedores entenderem o histórico do projeto.

---

## **Tipos de Commit**

### **1. feat (Feature)**
- Representa a adição de uma **nova funcionalidade** ao projeto.
- **Exemplo**:
  ```
  feat(transform): adiciona suporte para normalização de JSON
  ```

### **2. fix**
- Indica uma **correção de bug** no código.
- **Exemplo**:
  ```
  fix(extract): corrige erro na extração de arquivos CSV
  ```

### **3. chore**
- Usado para tarefas que **não alteram o código da aplicação**, como atualizações de dependências ou configurações de build.
- **Exemplo**:
  ```
  chore: atualiza dependências do Poetry
  ```

### **4. docs**
- Relacionado a **mudanças na documentação**.
- **Exemplo**:
  ```
  docs: adiciona instruções de configuração no README
  ```

### **5. style**
- Indica alterações que **não afetam a lógica do código**, como ajustes de formatação, identação ou remoção de espaços.
- **Exemplo**:
  ```
  style: ajusta identação no script de transformação
  ```

### **6. refactor**
- Usado para **refatorações** de código que **não alteram o comportamento existente**, mas melhoram a legibilidade ou eficiência.
- **Exemplo**:
  ```
  refactor(load): simplifica lógica de carregamento de dados
  ```

### **7. test**
- Relacionado a **adição ou ajuste de testes** automatizados.
- **Exemplo**:
  ```
  test(extract): adiciona teste para verificar extração de arquivos JSON
  ```

### **8. perf**
- Indica uma alteração que **melhora o desempenho** do código.
- **Exemplo**:
  ```
  perf(transform): otimiza a função de normalização
  ```

### **9. ci**
- Refere-se a mudanças em **pipelines de integração contínua** ou scripts de CI/CD.
- **Exemplo**:
  ```
  ci: ajusta configuração do GitHub Actions para rodar testes
  ```

---

## **Como Fazer Commits?**

### **Passo a Passo**
1. **Adicionar os Arquivos Modificados**:
   ```bash
   git add <arquivo>  # Adiciona um arquivo específico
   git add .          # Adiciona todos os arquivos modificados
   ```

2. **Criar o Commit**:
   Use o comando abaixo para criar um commit padronizado:
   ```bash
   make commit
   ```
   O processo interativo solicitará:
   - **Tipo do commit** (ex.: feat, fix, chore).
   - **Escopo** (opcional, ex.: extract, transform).
   - **Mensagem curta** (obrigatória).
   - **Descrição detalhada** (opcional).

3. **Enviar para o Repositório Remoto**:
   ```bash
   git push origin <branch>
   ```

---

## **Como Entender os Commits Feitos?**

### **Visualizando o Histórico de Commits**
- Para ver todos os commits realizados:
  ```bash
  git log --oneline
  ```
  Exemplo de saída:
  ```
  a1b2c3d feat(extract): adiciona suporte para JSON
  d4e5f6 fix(transform): corrige erro na função normalize
  g7h8i9 docs: atualiza documentação do README
  ```

### **Exibindo Commits com Mais Detalhes**
- Para ver detalhes de cada commit:
  ```bash
  git log
  ```
  Exemplo de saída:
  ```
  commit a1b2c3d
  Author: Leandro
  Date:   Fri Jan 24 12:00:00 2025 -0300

      feat(extract): adiciona suporte para JSON

      Adicionado suporte à extração de arquivos JSON, permitindo integração com novas fontes de dados.
  ```

### **Filtrando Commits por Tipo ou Autor**
- Exibir commits de um tipo específico (ex.: `feat`):
  ```bash
  git log --grep="^feat"
  ```
- Exibir commits feitos por um autor específico:
  ```bash
  git log --author="Leandro"
  ```

---

## **Boas Práticas**
1. **Mensagens Claras**:
   - Escreva mensagens curtas e diretas.
   - Use o idioma do projeto (Português ou Inglês) de forma consistente.

2. **Commits Atômicos**:
   - Faça commits pequenos e coesos. Cada commit deve tratar de uma única alteração.

3. **Referencie Issues**:
   - Sempre que possível, associe o commit a uma issue ou tarefa. Exemplo:
     ```
     fix(transform): corrige bug no normalizador de dados

     Closes #42
     ```

4. **Revisão Antes do Commit**:
   - Use `git diff` para revisar mudanças antes de fazer o commit:
     ```bash
     git diff
     ```