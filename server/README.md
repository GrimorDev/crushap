# crushap-server

Node.js/Express API backing the Crushap app — auth, profiles, discover/swipe/match, real-time chat (WebSocket + Redis pub/sub), photo upload. Redis is the only datastore.

See `../DEPLOYMENT.md` for deploying this as a Portainer stack.

## Run locally

```
npm install
cp .env.example .env   # edit REDIS_URL/JWT_SECRET as needed
redis-server &          # or point REDIS_URL at any Redis
npm start
```

## API

All `/api/*` routes except `/api/auth/*` require `Authorization: Bearer <token>`.

| Method | Path | Body | Notes |
|---|---|---|---|
| GET | `/health` | — | `{ ok: true }` |
| POST | `/api/auth/register` | `{ name, email, password, age, bio?, tags? }` | → `{ token, user }` |
| POST | `/api/auth/login` | `{ email, password }` | → `{ token, user }` |
| GET | `/api/me` | — | current user's profile |
| PATCH | `/api/me` | `{ name?, bio?, age?, tags?, lat?, lng? }` | `lat`/`lng` are optional and only used for real distance (Redis `GEO*`) — never fabricated if absent |
| POST | `/api/me/photos` | multipart, field `photo` | → `{ url }`, appends to the user's photo list |
| GET | `/api/discover` | — | up to 30 candidate profiles, excluding self and anyone already swiped |
| POST | `/api/swipes` | `{ targetId, action: "pass"\|"like"\|"superlike" }` | → `{ matched, profile? }` |
| GET | `/api/matches` | — | matched profiles, most recent first |
| GET | `/api/chat/:otherUserId/messages` | — | full history; 403 if not matched with that user |

## WebSocket (`/ws?token=<jwt>`)

One connection per open chat thread is the simplest client pattern (the server doesn't disambiguate rooms in the payload beyond `chatId`, since a client that joined exactly one room only ever gets that room's traffic).

```
→ {"type":"join","matchId":"<other user id>"}
→ {"type":"message","matchId":"<other user id>","text":"hey"}
← {"type":"message","chatId":"...","message":{"id","fromUserId","text","ts"}}
```

Messages are persisted to the same Redis list `GET /api/chat/:id/messages` reads, and published on `chat:<chatId>` so every connected participant (including other tabs/devices) gets them live.
