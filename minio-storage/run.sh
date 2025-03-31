#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

# Load primary login credentials
USERNAME=$(jq -r '.username // empty' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password // empty' "$CONFIG_PATH")

# Optional AWS-style access keys (override if provided)
ACCESS_KEY=$(jq -r '.access_key // empty' "$CONFIG_PATH")
SECRET_KEY=$(jq -r '.secret_key // empty' "$CONFIG_PATH")

# Ports and storage path
PORT=$(jq -r '.port' "$CONFIG_PATH")
CONSOLE_PORT=$(jq -r '.console_port' "$CONFIG_PATH")
STORAGE_PATH=$(jq -r '.storage_path // "/data/minio"' "$CONFIG_PATH")
ENABLE_SSL=$(jq -r '.enable_ssl' "$CONFIG_PATH")

# Use access_key/secret_key as override if set
if [[ -n "$ACCESS_KEY" && -n "$SECRET_KEY" ]]; then
    echo "[INFO] Using access_key/secret_key as login credentials"
    USERNAME="$ACCESS_KEY"
    PASSWORD="$SECRET_KEY"
fi

# Fallback check
if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
    echo "[ERROR] No valid credentials provided"
    exit 1
fi

export MINIO_ROOT_USER="${USERNAME}"
export MINIO_ROOT_PASSWORD="${PASSWORD}"

# Optional SSL support
CERTS_FLAG=""
if [[ "$ENABLE_SSL" == "true" && -d /ssl ]]; then
    echo "[INFO] SSL enabled with certs in /ssl"
    CERTS_FLAG="--certs-dir /ssl"
fi

# Logging startup
echo "[INFO] Starting MinIO"
echo "[
