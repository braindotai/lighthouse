.PHONY: setup-envs up down restart logs ps up-all down-all pull-all update-all validate check-env-drift help

BACKBLAZE_DIR := backblaze

# env file management
setup-envs:
	@echo "Scanning for .env files in current dir + immediate subfolders..."
	@for envfile in ./.env ./*/.env; do \
		[ -f "$$envfile" ] || continue; \
		echo "Processing $$envfile"; \
		chmod 600 "$$envfile"; \
		dir=$$(dirname "$$envfile"); \
		examplefile="$$dir/env.example"; \
		awk -F= ' \
			/^[[:space:]]*#/ { next } \
			/^[[:space:]]*$$/ { next } \
			{ \
				key=$$1; \
				sub(/^export[[:space:]]+/, "", key); \
				gsub(/[[:space:]]+$$/, "", key); \
				print key "=" \
			}' "$$envfile" > "$$examplefile"; \
		echo "  -> chmod 600 applied, generated $$examplefile"; \
	done
	@echo "Done."

# single-stack control: make up STACK=jellyfin
up: ## Start a single stack: make up STACK=foldername
	@[ -n "$(STACK)" ] || { echo "Usage: make up STACK=foldername"; exit 1; }
	cd $(STACK) && docker compose up -d

down: ## Stop a single stack: make down STACK=foldername
	@[ -n "$(STACK)" ] || { echo "Usage: make down STACK=foldername"; exit 1; }
	cd $(STACK) && docker compose down

restart: ## Restart a single stack: make restart STACK=foldername
	@[ -n "$(STACK)" ] || { echo "Usage: make restart STACK=foldername"; exit 1; }
	cd $(STACK) && docker compose restart

logs: ## Tail logs for a single stack: make logs STACK=foldername
	@[ -n "$(STACK)" ] || { echo "Usage: make logs STACK=foldername"; exit 1; }
	cd $(STACK) && docker compose logs -f --tail=200

ps: ## Show containers for a single stack: make ps STACK=foldername
	@[ -n "$(STACK)" ] || { echo "Usage: make ps STACK=foldername"; exit 1; }
	cd $(STACK) && docker compose ps

restore: ## Restore a stack's data volume from Backblaze: make restore STACK=foldername
	@[ -n "$(STACK)" ] || { echo "Usage: make restore STACK=foldername"; exit 1; }
	@[ -d "$(STACK)" ] || { echo "Error: Stack directory ./$(STACK) does not exist."; exit 1; }
	$(eval TS := $(shell date +'%Y-%m-%d_%H-%M-%S'))
	$(eval RESTIC_HOST := $(shell grep '^HOSTNAME=' $(BACKBLAZE_DIR)/.env | cut -d '=' -f2 | tr -d '\"\r '))
	@[ -n "$(RESTIC_HOST)" ] || { echo "Error: HOSTNAME variable not found in $(BACKBLAZE_DIR)/.env"; exit 1; }
	@echo "==> Stopping $(STACK) stack to safely restore data..."
	@cd $(STACK) && docker compose down
	@if [ -d "$(STACK)/data" ]; then \
		echo "==> Moving existing data to $(STACK)/data_backup_$(TS) (may ask for sudo)..."; \
		sudo mv "$(STACK)/data" "$(STACK)/data_backup_$(TS)"; \
	fi
	@echo "==> Creating staging area and fresh data directory..."
	@mkdir -p "$(PWD)/.restore_tmp_$(TS)"
	@mkdir -p "$(STACK)/data"
	@echo "==> Downloading ONLY /data/$(STACK) from snapshot via backblaze stack (Host: $(RESTIC_HOST))..."
	@docker compose -f $(BACKBLAZE_DIR)/docker-compose.yml run --rm \
		-v "$(PWD)/.restore_tmp_$(TS):/restore" \
		--entrypoint restic \
		backblaze \
		restore latest --host $(RESTIC_HOST) --target /restore --include "/data/$(STACK)"
	@echo "==> Flattening folder structure and preserving permissions (requires sudo)..."
	@if [ -d "$(PWD)/.restore_tmp_$(TS)/data/$(STACK)/data" ]; then \
		sudo cp -a "$(PWD)/.restore_tmp_$(TS)/data/$(STACK)/data/." "$(PWD)/$(STACK)/data/"; \
	else \
		sudo cp -a "$(PWD)/.restore_tmp_$(TS)/data/$(STACK)/." "$(PWD)/$(STACK)/data/"; \
	fi
	@echo "==> Cleaning up temporary files (requires sudo)..."
	@sudo rm -rf "$(PWD)/.restore_tmp_$(TS)"
	@echo "==> Restore complete! Restarting $(STACK)..."
	@cd $(STACK) && docker compose up -d
	@echo "==> Done. $(STACK) is back online."

# fleet-wide operations (every immediate subfolder with a docker-compose.yml)
up-all: ## Start every stack
	@for d in */; do \
		[ -f "$$d/docker-compose.yml" ] || continue; \
		echo "==> $$d"; \
		(cd "$$d" && docker compose up -d); \
	done

down-all: ## Stop every stack
	@for d in */; do \
		[ -f "$$d/docker-compose.yml" ] || continue; \
		echo "==> $$d"; \
		(cd "$$d" && docker compose down); \
	done

pull-all: ## Pull latest images for every stack
	@for d in */; do \
		[ -f "$$d/docker-compose.yml" ] || continue; \
		echo "==> $$d"; \
		(cd "$$d" && docker compose pull); \
	done

update-all: pull-all ## Pull + recreate changed containers across every stack
	@for d in */; do \
		[ -f "$$d/docker-compose.yml" ] || continue; \
		echo "==> $$d"; \
		(cd "$$d" && docker compose up -d); \
	done

# validation
validate: ## Check that every stack's compose file is syntactically valid
	@for d in */; do \
		[ -f "$$d/docker-compose.yml" ] || continue; \
		echo "==> $$d"; \
		(cd "$$d" && docker compose config -q) && echo "  OK" || echo "  !! invalid compose file"; \
	done

check-env-drift: ## Warn if a stack's .env is missing keys that env.example declares
	@for d in */; do \
		[ -f "$$d/.env" ] && [ -f "$$d/env.example" ] || continue; \
		missing=$$(comm -23 <(cut -d= -f1 "$$d/env.example" | sort) <(cut -d= -f1 "$$d/.env" | sort)); \
		if [ -n "$$missing" ]; then \
			echo "$$d: MISSING KEYS:"; echo "$$missing" | sed 's/^/    /'; \
		else \
			echo "$$d: OK"; \
		fi; \
	done

# help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
