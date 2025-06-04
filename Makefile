
install: ssh-key ## Initial install: SSH key + clone + build
	@echo "🔧 Installiere Chesskeeper..."
	@if [ ! -d /opt/chesskeeper ]; then \
		git clone git@github.com:14code/chesskeeper-infra.git /opt/chesskeeper; \
	fi
	cd /opt/chesskeeper && git clone git@github.com:14code/chesskeeper.git app
	$(MAKE) build

ssh-key:
	@if [ ! -f ~/.ssh/id_ed25519 ]; then \
		echo "🔐 Erstelle neuen SSH-Key..."; \
		ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519; \
	else \
		echo "🔐 SSH-Key existiert bereits."; \
	fi
	@echo "📋 Dein Public Key (kopiere ihn nach GitHub):"; \
	cat ~/.ssh/id_ed25519.pub
	@read -p "❓ Wenn du den Key zu GitHub hinzugefügt hast, drücke Enter zum Fortfahren... " confirm

status:
	docker compose ps

configure:
	bash scripts/configure.sh

volume:
	@echo "📦 Preparing data volume..."
	@FORCE_FORMAT=$(FORCE_FORMAT) bash scripts/prepare-volume.sh

cloud-config:
	bash scripts/prepare-cloud-config.sh

# 🔄 Pull latest code
pull:
	cd /opt/chesskeeper && git pull
	cd /opt/chesskeeper/app && git pull

# 🔄 Standard update: pull latest code and restart containers (no rebuild)
update: pull
	cd /opt/chesskeeper && docker compose up -d

# 🔁 Full rebuild: pull code and rebuild containers (e.g. after Dockerfile changes)
rebuild: pull build

build:
	cd /opt/chesskeeper && docker compose up -d --build

composer:
	docker run --rm \
		-u "$$(id -u):$$(id -g)" \
		-v "$$(pwd)/app:/app" \
		-w /app \
		composer install

npm:
	docker run --rm \
		-u "$$(id -u):$$(id -g)" \
		-v "$$(pwd)/app:/app" \
		-w /app \
		node:20 npm install


# 🔗 Link ./app/data to /mnt/chesskeeper-data (external volume mount)
symlink-data:
	@if [ -L ./app/data ]; then \
		echo "🔗 Symlink ./app/data already exists"; \
	elif [ -e ./app/data ]; then \
		echo "❌ ./app/data exists and is not a symlink – please remove manually"; \
		exit 1; \
	else \
		echo "🔗 Creating symlink: ./app/data → /mnt/chesskeeper-data"; \
		ln -s /mnt/chesskeeper-data ./app/data; \
	fi

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "🛠  \033[36m%-20s\033[0m %s\n", $$1, $$2}'


