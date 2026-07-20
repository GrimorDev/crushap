# Deploying the Crushap backend (Portainer / Docker)

This repo's root `docker-compose.yml` is a two-service stack:

- **redis** — `redis:7-alpine`, AOF persistence enabled, data on a named volume (`redis-data`). Not exposed to the host — only `api` talks to it.
- **api** — the Node.js/Express server in `server/`, built from `server/Dockerfile`. Serves the REST API, the WebSocket chat endpoint (`/ws`), and uploaded photos (`/uploads/...`). Uploaded files live on a named volume (`uploads-data`) so they survive redeploys.

## Deploy as a Portainer stack from this GitHub repo

1. Portainer → **Stacks** → **Add stack**.
2. **Build method**: *Repository*.
3. **Repository URL**: `https://github.com/GrimorDev/crushap` (branch `main`).
4. **Compose path**: `docker-compose.yml` (repo root — leave default).
5. **Environment variables** — add these in the stack's env var editor:
   - `JWT_SECRET` — **required**, a long random string (e.g. `openssl rand -hex 32`). The stack refuses to start without it.
   - `API_PORT` — optional, host port the API is published on (default `3000`).
   - `CORS_ORIGIN` — optional, default `*` (fine for a personal deploy).
6. **Deploy the stack**. Portainer clones the repo and runs `docker compose up -d --build`, building the `api` image from `server/Dockerfile` on your VPS.
7. Confirm it's up: `http://<your-vps-ip>:3000/health` should return `{"ok":true}`.

To pick up new commits later, use Portainer's **Pull and redeploy** (or **Update the stack** → *Re-pull image and redeploy*) on the stack.

## Pointing the app at your server

The Flutter app doesn't have your VPS IP baked in — it asks once, on first launch (and it's editable later from Profile → Server). Enter:

```
http://<your-vps-ip>:3000
```

That's the same base URL used for both the REST API and the WebSocket connection (the app derives the `ws://` URL from it).

## Notes

- **Plain HTTP, no TLS.** This is a bare IP, not a domain, so there's no Let's Encrypt cert here. If you later put a domain in front of this (e.g. via Traefik or nginx as a reverse proxy, or Portainer's own), switch it to HTTPS/WSS and update the app's server URL accordingly — everything here works the same over TLS, nothing to change server-side beyond terminating TLS in front of it.
- **Backups**: the two named volumes (`redis-data`, `uploads-data`) are the entire state of the app — everyone's accounts, matches, messages, and photos. Back those up (`docker run --rm -v crushap_redis-data:/data ...` style volume snapshots, or Portainer's own volume backup features) however you back up the rest of the VPS.
- **Scaling beyond one `api` container** works out of the box for chat (it's Redis pub/sub-backed for exactly this reason) but isn't needed for a personal deploy — mentioned here only so it's not a surprise later.
