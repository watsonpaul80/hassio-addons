#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

USERNAME=$(jq -r '.username' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password' "$CONFIG_PATH")
PORT=$(jq -r '.port' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port' "$CONFIG_PATH")
GENERATE_KEYS=$(jq -r '.generate_keys' "$CONFIG_PATH")

if [[ "$GENERATE_KEYS" == "true" && ( -z "$USERNAME" || -z "$PASSWORD" ) ]]; then
    echo "[INFO] Generating random credentials..."
    USERNAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
    PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
fi

export MINIO_ROOT_USER="${USERNAME}"
export MINIO_ROOT_PASSWORD="${PASSWORD}"

# Ingress Path Detection (Fallback)
if [[ -z "$MINIO_BROWSER_REDIRECT_URL" ]]; then
    INGRESS_SLUG=$(basename "$(dirname "$(realpath "$0")")")
    export MINIO_BROWSER_REDIRECT_URL="/hassio/ingress/${INGRESS_SLUG}"
    echo "[INFO] Auto-set MINIO_BROWSER_REDIRECT_URL to $MINIO_BROWSER_REDIRECT_URL"
fi

echo "[INFO] Starting MinIO in Ingress mode"
echo "[INFO] Login with username: $USERNAME"

exec minio server /data \
  --address "127.0.0.1:${PORT}" \
  --console-address "127.0.0.1:${CONSOLE_PORT}"
