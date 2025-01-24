# Variáveis
COMMIT_TYPES := feat fix chore docs style refactor test perf ci
DEFAULT_SCOPE := geral

# Regra para commits
commit:
	@echo "Tipos disponíveis: $(COMMIT_TYPES)"
	@read -p "Digite o tipo (ex: feat, fix): " type; \
	if ! echo "$(COMMIT_TYPES)" | grep -qw "$$type"; then \
		echo "Erro: Tipo de commit inválido! Escolha um dos seguintes: $(COMMIT_TYPES)"; \
		exit 1; \
	fi; \
	read -p "Digite o escopo (ou pressione Enter para '$(DEFAULT_SCOPE)'): " scope; \
	scope=$${scope:-$(DEFAULT_SCOPE)}; \
	read -p "Digite a mensagem curta do commit: " msg; \
	read -p "Deseja adicionar uma descrição detalhada (s/n)? " desc; \
	if [ "$$desc" = "s" ]; then \
		echo "Digite a descrição detalhada (pressione Ctrl+D para terminar):"; \
		desc_text=$$(cat); \
		git commit -m "$$type($$scope): $$msg" -m "$$desc_text"; \
	else \
		git commit -m "$$type($$scope): $$msg"; \
	fi
