#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

USERNAME=$(jq -r '.username // empty' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password // empty' "$CONFIG_PATH")
ACCESS_KEY=$(jq -r '.access_key // empty' "$CONFIG_PATH")
SECRET_KEY=$(jq -r '.secret_key // empty' "$CONFIG_PATH")
PORT=$(jq -r '.port' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port' "$CONFIG_PATH")
STORAGE_PATH=$(jq -r '.storage_path // "/data/minio"' "$CONFIG_PATH")
ENABLE_SSL=$(jq -r '.enable_ssl' "$CONFIG_PATH")
GENERATE_KEYS=$(jq -r '.generate_keys' "$CONFIG_PATH")

# Fallback to access_key/secret_key if username/password not provided
if [[ -z "$USERNAME" && -n "$ACCESS_KEY" ]]; then
  USERNAME="$ACCESS_KEY"
  PASSWORD="$SECRET_KEY"
fi

# Auto-generate credentials if required
if [[ "$GENERATE_KEYS" == "true" && ( -z "$USERNAME" || -z "$PASSWORD" ) ]]; then
  echo "[INFO] Generating random credentials..."
  USERNAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
  PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)
fi

# Export credentials
export MINIO_ROOT_USER="${USERNAME}"
export MINIO_ROOT_PASSWORD="${PASSWORD}"

# SSL support
CERTS_FLAG=""
if [[ "$ENABLE_SSL" == "true" ]]; then
  CERTS_FLAG="--certs-dir /ssl"
  echo "[INFO] SSL enabled, using certs from /ssl"
fi

# Log summary
echo "[INFO] Starting MinIO"
echo "[INFO] Access Key: $USERNAME"
echo "[INFO] Port: $PORT"
echo "[INFO] Console: $CONSOLE_PORT"
echo "[INFO] Data Dir: $STORAGE_PATH"

exec minio server "$STORAGE_PATH" \
  --address "0.0.0.0:${PORT}" \
  --console-address "0.0.0.0:${CONSOLE_PORT}" \
  $CERTS_FLAG
