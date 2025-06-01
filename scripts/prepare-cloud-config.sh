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

echo "🔧 Generating customized cloud-config.yaml..."
sed -e "s|__DOMAIN__|$DOMAIN|g" \
    -e "s|__SSH_KEY__|$SSH_KEY|g" \
    -e "s|__LABEL__|$LABEL|g" \
    templates/cloud-config.template.yaml > output/cloud-config.yaml

echo "✅ Done. Your customized cloud-config.yaml is in ./output/"
