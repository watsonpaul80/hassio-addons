#!/usr/bin/with-contenv bashio

# Load config values
PORT=$(bashio::config 'port')
CONSOLE_PORT=$(bashio::config 'console_port')
GEN_KEYS=$(bashio::config 'generate_keys')
ACCESS_KEY=$(bashio::config 'access_key')
SECRET_KEY=$(bashio::config 'secret_key')

# Generate keys if requested or missing
if bashio::var.true "${GEN_KEYS}" || [[ -z "$ACCESS_KEY" || -z "$SECRET_KEY" ]]; then
    echo "[INFO] Generating random access and secret keys..."
    ACCESS_KEY=$(openssl rand -base64 12 | tr -dc A-Za-z0-9 | head -c 20)
    SECRET_KEY=$(openssl rand -base64 24 | tr -dc A-Za-z0-9 | head -c 40)
    echo "[INFO] Generated ACCESS_KEY: $ACCESS_KEY"
    echo "[INFO] Generated SECRET_KEY: $SECRET_KEY"
fi

export MINIO_ROOT_USER="${ACCESS_KEY}"
export MINIO_ROOT_PASSWORD="${SECRET_KEY}"

echo "[INFO] Starting MinIO on port $PORT with console at $CONSOLE_PORT..."

exec minio server /data --address ":${PORT}" --console-address ":${CONSOLE_PORT}"
