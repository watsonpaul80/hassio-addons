#!/usr/bin/env bash
set -e

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

CONFIG_PATH=/data/options.json

ACCESS_KEY=$(jq -r '.access_key' "$CONFIG_PATH")
SECRET_KEY=$(jq -r '.secret_key' "$CONFIG_PATH")
PORT=$(jq -r '.port' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port' "$CONFIG_PATH")
GENERATE_KEYS=$(jq -r '.generate_keys' "$CONFIG_PATH")

if [[ "$GENERATE_KEYS" == "true" || -z "$ACCESS_KEY" || -z "$SECRET_KEY" ]]; then
    log "Generating random access and secret keys..."
    ACCESS_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
    SECRET_KEY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
fi

export MINIO_ROOT_USER="${ACCESS_KEY}"
export MINIO_ROOT_PASSWORD="${SECRET_KEY}"

log "Starting MinIO on port $PORT with console at $CONSOLE_PORT"
exec minio server /data --address ":${PORT}" --console-address ":${CONSOLE_PORT}"
