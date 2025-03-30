#!/usr/bin/env bash
source /usr/lib/bashio.sh

PORT=$(bashio::config 'port')
CONSOLE_PORT=$(bashio::config 'console_port')
GEN_KEYS=$(bashio::config 'generate_keys')
ACCESS_KEY=$(bashio::config 'access_key')
SECRET_KEY=$(bashio::config 'secret_key')

if bashio::var.true "$GEN_KEYS" || [[ -z "$ACCESS_KEY" || -z "$SECRET_KEY" ]]; then
    echo "[INFO] Generating access/secret keys..."
    ACCESS_KEY=$(openssl rand -base64 12 | tr -dc A-Za-z0-9 | head -c 20)
    SECRET_KEY=$(openssl rand -base64 24 | tr -dc A-Za-z0-9 | head -c 40)
fi

export MINIO_ROOT_USER="${ACCESS_KEY}"
export MINIO_ROOT_PASSWORD="${SECRET_KEY}"

echo "[INFO] Starting MinIO..."
exec minio server /data --address ":${PORT}" --console-address ":${CONSOLE_PORT}"
