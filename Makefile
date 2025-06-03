install: ssh-key
	@echo "🔧 Installiere Chesskeeper..."
	cd /opt/chesskeeper && git clone git@github.com:14code/chesskeeper.git app
	cd /opt/chesskeeper && docker compose up -d --build

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

pull:
	cd /opt/chesskeeper/app && git pull
	cd /opt/chesskeeper && docker compose up -d --build

status:
	docker compose ps

configure:
	bash scripts/configure.sh

volume:
	bash scripts/prepare-volume.sh

cloud-config:
	bash scripts/prepare-cloud-config.sh

# 🔄 Standard update: pull latest code and restart containers (no rebuild)
update:
	cd /opt/chesskeeper && git pull
	cd /opt/chesskeeper/app && git pull
	docker compose up -d

# 🔁 Full rebuild: pull code and rebuild containers (e.g. after Dockerfile changes)
rebuild:
	cd /opt/chesskeeper && git pull
	cd /opt/chesskeeper/app && git pull
	docker compose build
	docker compose up -d

build:
	docker compose up -d --build

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

