# Variáveis
COMMIT_TYPES := feat fix chore docs style refactor test perf ci
DEFAULT_SCOPE := geral
ALLOWED_SCOPES := extract transform load schema migrations queries procedures views triggers config tests docs ci

commit:
    @echo "Escopos permitidos: $(ALLOWED_SCOPES)"
    @read -p "Digite o tipo (feat, fix, chore, etc.): " type; \
    read -p "Digite o escopo: " scope; \
    if ! echo "$(ALLOWED_SCOPES)" | grep -qw "$$scope"; then \
        echo "Erro: Escopo inválido! Use um dos seguintes: $(ALLOWED_SCOPES)"; \
        exit 1; \
    fi; \
    read -p "Digite a mensagem curta do commit: " msg; \
    read -p "Deseja adicionar uma descrição detalhada (s/n)? " desc; \
    if [ "$$desc" = "s" ]; then \
        echo "Digite a descrição detalhada (pressione Ctrl+D para terminar):"; \
        desc_text=$$(cat); \
        git commit -m "$$type($$scope): $$msg" -m "$$desc_text"; \
    else \
        git commit -m "$$type($$scope): $$msg"; \
    fi