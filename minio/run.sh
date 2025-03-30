#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

ACCESS_KEY=$(jq -r '.access_key' "$CONFIG_PATH")
SECRET_KEY=$(jq -r '.secret_key' "$CONFIG_PATH")
PORT=$(jq -r '.port' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port' "$CONFIG_PATH")
GENERATE_KEYS=$(jq -r '.generate_keys' "$CONFIG_PATH")

# Generate if needed
if [[ "$GENERATE_KEYS" == "true" && ( -z "$ACCESS_KEY" || -z "$SECRET_KEY" ) ]]; then
    echo "[INFO] Generating random credentials..."
    ACCESS_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
    SECRET_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
fi

# Export for MinIO to use
export MINIO_ROOT_USER="${ACCESS_KEY}"
export MINIO_ROOT_PASSWORD="${SECRET_KEY}"

echo "[INFO] Starting MinIO with user: $ACCESS_KEY"
exec minio server /data --address ":${PORT}" --console-address ":${CONSOLE_PORT}"
