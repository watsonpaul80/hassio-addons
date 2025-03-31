#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

# Read values from config
ACCESS_KEY=$(jq -r '.access_key // empty' "$CONFIG_PATH")
SECRET_KEY=$(jq -r '.secret_key // empty' "$CONFIG_PATH")
PORT=$(jq -r '.port // 9000' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port // 9001' "$CONFIG_PATH")
STORAGE_PATH=$(jq -r '.storage_path // "/data/minio"' "$CONFIG_PATH")

# Generate credentials if not provided
if [[ -z "$ACCESS_KEY" || -z "$SECRET_KEY" ]]; then
    echo "[INFO] No access/secret key provided, generating random credentials..."
    ACCESS_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
    SECRET_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
    echo "[INFO] Generated Access Key: $ACCESS_KEY"
    echo "[INFO] Generated Secret Key: $SECRET_KEY"
fi

# Export required environment variables
export MINIO_ROOT_USER="${ACCESS_KEY}"
export MINIO_ROOT_PASSWORD="${SECRET_KEY}"

echo "[INFO] Starting MinIO"
echo "[INFO] Login with username: ${MINIO_ROOT_USER}"

exec minio server "$STORAGE_PATH" \
  --address "0.0.0.0:${PORT}" \
  --console-address "0.0.0.0:${CONSOLE_PORT}"
