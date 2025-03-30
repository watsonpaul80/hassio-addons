#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

USERNAME=$(jq -r '.username' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password' "$CONFIG_PATH")
PORT=$(jq -r '.port' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port' "$CONFIG_PATH")
GENERATE_KEYS=$(jq -r '.generate_keys' "$CONFIG_PATH")
BROWSER_REDIRECT_URL=$(jq -r '.browser_redirect_url // empty' "$CONFIG_PATH")

if [[ "$GENERATE_KEYS" == "true" && ( -z "$USERNAME" || -z "$PASSWORD" ) ]]; then
    echo "[INFO] Generating random credentials..."
    USERNAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
    PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
fi

export MINIO_ROOT_USER="${USERNAME}"
export MINIO_ROOT_PASSWORD="${PASSWORD}"

if [[ -n "$BROWSER_REDIRECT_URL" ]]; then
    echo "[INFO] Setting browser redirect URL to $BROWSER_REDIRECT_URL"
    export MINIO_BROWSER_REDIRECT_URL="$BROWSER_REDIRECT_URL"
else
    # Use safe fallback (external access only)
    echo "[INFO] No redirect URL set, skipping MINIO_BROWSER_REDIRECT_URL"
fi

echo "[INFO] Starting MinIO"
echo "[INFO] Login with username: $USERNAME"

exec minio server /data \
  --address "0.0.0.0:${PORT}" \
  --console-address "0.0.0.0:${CONSOLE_PORT}"
