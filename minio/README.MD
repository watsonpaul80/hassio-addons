# MinIO - Home Assistant Add-on

![MinIO](https://img.shields.io/badge/MinIO-S3--Compatible-blue)

This Home Assistant add-on provides a self-hosted, high-performance S3-compatible object storage server using [MinIO](https://min.io).

---

## 🚀 Features

- MinIO latest container image from Quay.io
- Web UI available at `http://<your-ha-ip>:9001`
- Uses clean `username` and `password` config
- Optional key generation
- Persistent data stored in `/data`

---

## 🧠 Configuration

```yaml
username: admin
password: minio123
port: 9000
console_port: 9001
generate_keys: false
```

> Set `generate_keys: true` to auto-generate a random username/password.

---

## 🔐 Access

- Web UI: `http://homeassistant.local:9001` or your HA IP
- Default login: `admin / minio123` (or your custom values)

---

## 📦 Storage

- Buckets and objects are stored under `/data`
- Use it for backup scripts, object storage, or snapshot retention

---

## 🛠 Maintainer

**Paul Watson**  
[watsonpaul80@googlemail.com](mailto:watsonpaul80@googlemail.com)

---

## ✅ Installation

1. Add this repo to Home Assistant:
   ```
   https://github.com/watsonpaul80/hassio-addons
   ```
2. Reload the Add-on Store
3. Install **MinIO**
4. Start the add-on and open the Web UI

