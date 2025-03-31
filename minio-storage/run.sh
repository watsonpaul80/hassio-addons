#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

ACCESS_KEY=$(jq -r '.access_key' "$CONFIG_PATH")
SECRET_KEY=$(jq -r '.secret_key' "$CONFIG_PATH")
PORT=$(jq -r '.port' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port' "$CONFIG_PATH")
STORAGE_PATH=$(jq -r '.storage_path' "$CONFIG_PATH")

# Generate fallback credentials if unset or null
if [ "$ACCESS_KEY" == "null" ] || [ -z "$ACCESS_KEY" ]; then
    ACCESS_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
    echo "[INFO] Generated random access key: $ACCESS_KEY"
fi

if [ "$SECRET_KEY" == "null" ] || [ -z "$SECRET_KEY" ]; then
    SECRET_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
    echo "[INFO] Generated random secret key."
fi

export MINIO_ROOT_USER="${ACCESS_KEY}"
export MINIO_ROOT_PASSWORD="${SECRET_KEY}"

echo "[INFO] Starting MinIO"
echo "[INFO] Login with access key: $ACCESS_KEY"

exec minio server "$STORAGE_PATH" \
  --address "0.0.0.0:${PORT}" \
  --console-address "0.0.0.0:${CONSOLE_PORT}"
