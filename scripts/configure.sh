#!/bin/bash
set -e

# Load .env line by line
if [ -f .env ]; then
  while IFS='=' read -r key value; do
    if [[ $key != \#* ]] && [[ -n "$key" ]]; then
      value="${value%\"}"
      value="${value#\"}"
      export "$key=$value"
    fi
  done < .env
fi

echo "🔧 Generating Caddyfile..."
sed "s|__DOMAINS__|$DOMAINS|g" templates/Caddyfile.template > ./Caddyfile

echo "✅ Configuration complete."
