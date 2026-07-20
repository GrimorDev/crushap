const { WebSocketServer } = require('ws');
const { URL } = require('url');
const { verifyToken } = require('./auth');
const { publisher, subscriber } = require('./redis');
const swipesStore = require('./store/swipes');
const chatStore = require('./store/chat');
const { v4: uuid } = require('uuid');

// chatId -> Set<ws>, in-process fan-out. Redis pub/sub is the layer that
// makes this correct if the API is ever scaled to multiple instances: every
// instance subscribes to a chat channel once any of its own clients joins
// that room, and relays whatever gets published (by any instance) to its
// own locally-connected clients.
const rooms = new Map();
const subscribedChannels = new Set();

function channelFor(chatId) {
  return `chat:${chatId}`;
}

subscriber.on('message', (channel, payload) => {
  const chatId = channel.replace(/^chat:/, '');
  const clients = rooms.get(chatId);
  if (!clients) return;
  for (const ws of clients) {
    if (ws.readyState === ws.OPEN) ws.send(payload);
  }
});

function joinRoom(ws, chatId) {
  if (!rooms.has(chatId)) rooms.set(chatId, new Set());
  rooms.get(chatId).add(ws);
  ws.rooms.add(chatId);
  if (!subscribedChannels.has(chatId)) {
    subscribedChannels.add(chatId);
    subscriber.subscribe(channelFor(chatId)).catch((err) => console.error('[ws] subscribe failed', err));
  }
}

function leaveAllRooms(ws) {
  for (const chatId of ws.rooms) {
    rooms.get(chatId)?.delete(ws);
  }
  ws.rooms.clear();
}

function attachWebSocketServer(server) {
  const wss = new WebSocketServer({ server, path: '/ws' });

  wss.on('connection', (ws, request) => {
    let userId;
    try {
      const url = new URL(request.url, 'http://localhost');
      userId = verifyToken(url.searchParams.get('token') || '');
    } catch {
      ws.close(4001, 'Invalid token');
      return;
    }
    ws.userId = userId;
    ws.rooms = new Set();

    ws.on('message', async (raw) => {
      let msg;
      try {
        msg = JSON.parse(raw.toString());
      } catch {
        return;
      }

      if (msg.type === 'join' && msg.matchId) {
        if (!(await swipesStore.isMatch(userId, msg.matchId))) return;
        joinRoom(ws, chatStore.pairKey(userId, msg.matchId));
        return;
      }

      if (msg.type === 'message' && msg.matchId && typeof msg.text === 'string' && msg.text.trim()) {
        if (!(await swipesStore.isMatch(userId, msg.matchId))) return;
        const chatId = chatStore.pairKey(userId, msg.matchId);
        const message = { id: uuid(), fromUserId: userId, text: msg.text.trim(), ts: Date.now() };
        await chatStore.appendMessage(chatId, message);
        await publisher.publish(channelFor(chatId), JSON.stringify({ type: 'message', chatId, message }));
      }
    });

    ws.on('close', () => leaveAllRooms(ws));
  });

  return wss;
}

module.exports = { attachWebSocketServer };
