#!/bin/bash

set -e

# Load variables
if [ -f .env ]; then
  source .env
else
  echo "❌ No .env file found. Copy .env.example and edit it first."
  exit 1
fi

# Create output directory
mkdir -p output

IFS=',' read -ra KEYS <<< "$SSH_KEYS"
SSH_YAML="\n"
for key in "${KEYS[@]}"; do
  SSH_YAML+="      - ${key}\n"
done

echo "🔧 Generating customized cloud-config.yaml..."
sed -e "s|__DOMAINS__|$DOMAINS|g" \
    -e "s|__DATA_VOLUME_PATH__|$DATA_VOLUME_PATH|g" \
    -e "s|__SSH_KEYS__|${SSH_YAML}|g" \
    -e "s|__LABEL__|$LABEL|g" \
    templates/cloud-config.template.yaml > output/cloud-config.yaml

echo "✅ Done. Your customized cloud-config.yaml is in ./output/"
