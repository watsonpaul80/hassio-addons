#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

USERNAME=$(jq -r '.username' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password' "$CONFIG_PATH")
PORT=$(jq -r '.port' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port' "$CONFIG_PATH")
GENERATE_KEYS=$(jq -r '.generate_keys' "$CONFIG_PATH")
EXTERNAL_ACCESS=$(jq -r '.external_access' "$CONFIG_PATH")

# Generate credentials if needed
if [[ "$GENERATE_KEYS" == "true" && ( -z "$USERNAME" || -z "$PASSWORD" ) ]]; then
    echo "[INFO] Generating random credentials..."
    USERNAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
    PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
fi

export MINIO_ROOT_USER="${USERNAME}"
export MINIO_ROOT_PASSWORD="${PASSWORD}"

# Set redirect URL for web UI
if [[ "$EXTERNAL_ACCESS" == "true" ]]; then
    export MINIO_BROWSER_REDIRECT_URL="http://homeassistant.local:${CONSOLE_PORT}"
    echo "[INFO] External access enabled. Redirect URL: $MINIO_BROWSER_REDIRECT_URL"
else
    export MINIO_BROWSER_REDIRECT_URL="/hassio/ingress/$(basename "$HOSTNAME" | tr _ -)"
    echo "[INFO] Auto-set MINIO_BROWSER_REDIRECT_URL to $MINIO_BROWSER_REDIRECT_URL"
fi

echo "[INFO] Starting MinIO"
echo "[INFO] Login with username: $USERNAME"

exec minio server /data \
  --address "0.0.0.0:${PORT}" \
  --console-address "0.0.0.0:${CONSOLE_PORT}"
