# Ubuntu on-prem deployment

This stack builds every service from the repository source and runs:

- `xiaozhi-server`
- `manager-api`
- `manager-web`
- `mysql`
- `redis`

## Prerequisites

- Ubuntu 22.04 or 24.04
- Docker Engine
- Docker Compose plugin

Example install:

```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-v2
sudo systemctl enable --now docker
```

## 1. Prepare the repo

Clone or copy the whole repository to the Ubuntu server, then go to:

```bash
cd deploy/onpremise
cp .env.example .env
mkdir -p volumes/mysql volumes/redis volumes/uploadfile
```

## 2. Adjust the runtime config

### Manager web and manager api

By default:

- `manager-web` is exposed on port `8001`
- `manager-api` is exposed on port `8002`

`manager-web` proxies `/xiaozhi/*` to `manager-api`, so the browser only needs `http://your-host:8001`.

### xiaozhi-server config

Edit [main/xiaozhi-server/data/.config.yaml](../../main/xiaozhi-server/data/.config.yaml) before first start.

At minimum, make sure:

1. `server.websocket` points to the real public or LAN address that ESP32 devices will use.
2. Any model endpoints such as Ollama use reachable addresses from inside the container.
3. If you want `xiaozhi-server` to pull configuration from `manager-api`, add:

```yaml
manager-api:
  url: http://manager-api:8002/xiaozhi
  secret: your-manager-api-secret
```

If you keep local-file mode, you can leave the `manager-api` block out.

### Local models

If your selected ASR or other modules need local model files, place them under:

```text
main/xiaozhi-server/models/
```

The compose stack mounts that folder directly into the container.

## 3. Build and start

```bash
docker compose build
docker compose up -d
```

## 4. Verify

```bash
docker compose ps
docker compose logs -f manager-api
docker compose logs -f xiaozhi-server
```

Useful URLs:

- Manager web: `http://your-host:8001`
- Manager API docs: `http://your-host:8002/xiaozhi/doc.html`
- Xiaozhi websocket: `ws://your-host:8000/xiaozhi/v1/`
- Xiaozhi OTA/http: `http://your-host:8003/xiaozhi/ota/`

## 5. Upgrade

After pulling repo changes:

```bash
docker compose build
docker compose up -d
```

## Notes

- Database, Redis, and uploaded files persist under `deploy/onpremise/volumes/`.
- `xiaozhi-server` data and models are mounted from the repository so you can edit config and assets without rebuilding the image.
- If you put this behind Nginx or Traefik later, keep the websocket route for port `8000` intact.
