#!/bin/bash
set -e

# Load environment from .env if present
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

DOMAIN="${DOMAIN:-yourdomain.tld}"
DOMAINS="${DOMAINS:-$DOMAIN}"  # fallback auf single domain
SSH_KEY="${SSH_KEY:-ssh-ed25519 AAAA...}"
LABEL="${LABEL:-chessdata}"

echo "🔧 Generating Caddyfile..."
sed "s|__DOMAINS__|$DOMAINS|g" templates/Caddyfile.template > ./Caddyfile

echo "✅ Configuration complete."
