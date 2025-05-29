#!/bin/bash
cd /opt/chesskeeper-infra || exit 1
git pull
cd app && git pull
docker compose pull
docker compose up -d --build
