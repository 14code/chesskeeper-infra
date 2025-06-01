#!/bin/bash

set -e

DOMAIN="${DOMAIN:-yourdomain.tld}"
SSH_KEY="${SSH_KEY:-ssh-ed25519 AAAA...}"
LABEL="${LABEL:-chessdata}"

OUTDIR="./output"
mkdir -p "$OUTDIR"

echo "🔧 Generating cloud-config.yaml..."
sed "s|__SSH_KEY__|$SSH_KEY|g" templates/cloud-config.template.yaml > "$OUTDIR/cloud-config.yaml"

echo "🔧 Generating Caddyfile..."
sed "s|__DOMAIN__|$DOMAIN|g" templates/Caddyfile.template > "$OUTDIR/Caddyfile"

echo "🔧 Copying Makefile..."
cp templates/Makefile.template "$OUTDIR/Makefile"

echo "✅ Configuration complete in $OUTDIR/"
