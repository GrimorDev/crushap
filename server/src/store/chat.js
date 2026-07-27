const { redis } = require('../redis');

/// Deterministic room id for a pair of user ids, independent of order.
function pairKey(a, b) {
  return [a, b].sort().join('_');
}

const chatKey = (chatId) => `chat:${chatId}`;
const lastReadKey = (chatId, userId) => `chat:${chatId}:lastRead:${userId}`;

async function appendMessage(chatId, message) {
  await redis.rpush(chatKey(chatId), JSON.stringify(message));
}

async function listMessages(chatId) {
  const raw = await redis.lrange(chatKey(chatId), 0, -1);
  return raw.map((m) => JSON.parse(m));
}

async function lastMessage(chatId) {
  const raw = await redis.lindex(chatKey(chatId), -1);
  return raw ? JSON.parse(raw) : null;
}

/// Marks everything in `chatId` as read by `userId` as of now — called
/// whenever they actually open the thread (GET .../messages).
async function markRead(chatId, userId) {
  await redis.set(lastReadKey(chatId, userId), Date.now());
}

async function lastReadAt(chatId, userId) {
  const v = await redis.get(lastReadKey(chatId, userId));
  return v ? Number(v) : 0;
}

module.exports = { pairKey, appendMessage, listMessages, lastMessage, markRead, lastReadAt };
