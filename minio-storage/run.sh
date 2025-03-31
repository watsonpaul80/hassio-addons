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
ENABLE_SSL=$(jq -r '.enable_ssl // false' "$CONFIG_PATH")
ENABLE_REDIRECT=$(jq -r '.enable_redirect // false' "$CONFIG_PATH")

# Prefer AWS-style access/secret keys
if [[ -n "$ACCESS_KEY" && -n "$SECRET_KEY" ]]; then
  USERNAME="$ACCESS_KEY"
  PASSWORD="$SECRET_KEY"
fi

export MINIO_ROOT_USER="$USERNAME"
export MINIO_ROOT_PASSWORD="$PASSWORD"

# Setup optional redirect URL for external access if enabled
if [[ "$ENABLE_REDIRECT" == "true" ]]; then
  export MINIO_BROWSER_REDIRECT_URL="http://homeassistant.local:9001"
  echo "[INFO] Auto-set MINIO_BROWSER_REDIRECT_URL to $MINIO_BROWSER_REDIRECT_URL"
else
  echo "[INFO] No redirect URL set, skipping MINIO_BROWSER_REDIRECT_URL"
fi

# Setup optional SSL directory
if [[ "$ENABLE_SSL" == "true" ]]; then
  CERTS_ARG="--certs-dir /ssl"
else
  CERTS_ARG=""
fi

mkdir -p "$STORAGE_PATH"

echo "[INFO] Starting MinIO"
echo "[INFO] Login with username: $USERNAME"

exec minio server "$STORAGE_PATH" \
  --address "0.0.0.0:${PORT}" \
  --console-address "0.0.0.0:${CONSOLE_PORT}" \
  $CERTS_ARG
