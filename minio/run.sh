#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

USERNAME=$(jq -r '.username' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password' "$CONFIG_PATH")
PORT=$(jq -r '.port' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port' "$CONFIG_PATH")
STORAGE_PATH=$(jq -r '.storage_path' "$CONFIG_PATH")
GENERATE_KEYS=$(jq -r '.generate_keys' "$CONFIG_PATH")

if [[ "$GENERATE_KEYS" == "true" && ( -z "$USERNAME" || -z "$PASSWORD" ) ]]; then
    echo "[INFO] Generating random credentials..."
    USERNAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
    PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
fi

export MINIO_ROOT_USER="${USERNAME}"
export MINIO_ROOT_PASSWORD="${PASSWORD}"

echo "[INFO] Starting MinIO in Ingress mode"
echo "[INFO] Login with username: $USERNAME"
echo "[INFO] Using storage path: $STORAGE_PATH"

exec minio server "$STORAGE_PATH" \
  --address "127.0.0.1:${PORT}" \
  --console-address "127.0.0.1:${CONSOLE_PORT}"
