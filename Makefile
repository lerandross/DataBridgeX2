# Variáveis
COMMIT_TYPES := feat fix chore docs style refactor test perf ci
ALLOWED_SCOPES := extract transform load schema migrations queries procedures views triggers config tests docs ci geral
DEFAULT_SCOPE := geral

# Regra para commits
commit:
	@echo "Tipos disponíveis: $(COMMIT_TYPES)"
	@echo "Escopos permitidos: $(ALLOWED_SCOPES)"
	@read -p "Digite o tipo (ex: feat, fix): " type; \
	if ! echo "$(COMMIT_TYPES)" | grep -qw "$$type"; then \
		echo "Erro: Tipo de commit inválido! Escolha um dos seguintes: $(COMMIT_TYPES)"; \
		exit 1; \
	fi; \
	read -p "Digite o escopo (ou pressione Enter para '$(DEFAULT_SCOPE)'): " scope; \
	scope=$${scope:-$(DEFAULT_SCOPE)}; \
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

.PHONY: build-production
build-production:
	docker build -t escolamobile/databridgex:latest .

.PHONY: push-production-image
push-production-image:
	docker push escolamobile/databridgex:latest

.PHONY: build-and-push
build-and-push:
	docker build -t escolamobile/databridgex:latest . && docker push escolamobile/databridgex:latest

.PHONY: update_and_exec
update_and_exec:
	@if docker pull escolamobile/databridgex:latest | grep -q "Status: Downloaded newer image"; then \
		docker build -t escolamobile/databridgex:latest . && docker push escolamobile/databridgex:latest; \
	fi
	docker run -d --memory="3g" --memory-swap="3g" --cpu-quota=20000 escolamobile/databridgex:latest

.PHONY: run-jupyter
run-jupyter:
	jupyter notebook --NotebookApp.allow_origin='https://colab.research.google.com' --port=8888 --NotebookApp.port_retries=0

.PHONY: run-local
run-local:
	@echo "Iniciando o container local para testes..."
	docker run -d \
		--name databridgex-local \
		-p 8080:8080 \
		--memory="1g" \
		--memory-swap="1g" \
		--cpu-quota=10000 \
		-e ENVIRONMENT=local \
		escolamobile/databridgex:latest

.PHONY: stop-container
stop-container:
	@read -p "Digite o nome ou ID do container a ser parado: " container_name; \
	if docker ps | grep -qw "$$container_name"; then \
		docker stop "$$container_name"; \
		docker rm "$$container_name"; \
		echo "Container '$$container_name' foi parado e removido com sucesso."; \
	else \
		echo "Erro: Nenhum container com o nome ou ID '$$container_name' encontrado."; \
	fi
