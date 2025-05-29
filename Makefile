install:
	@echo "🔧 Initialisiere Chesskeeper Umgebung..."
	git clone git@github.com:14code/chesskeeper-infra.git /opt/chesskeeper
	cd /opt/chesskeeper && git clone git@github.com:14code/chesskeeper.git app
	cd /opt/chesskeeper && docker compose up -d --build

pull:
	cd /opt/chesskeeper/app && git pull
	cd /opt/chesskeeper && docker compose up -d --build

status:
	docker compose ps


volume:
	bash scripts/prepare-volume.sh
