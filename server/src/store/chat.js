const { redis } = require('../redis');

/// Deterministic room id for a pair of user ids, independent of order.
function pairKey(a, b) {
  return [a, b].sort().join('_');
}

const chatKey = (chatId) => `chat:${chatId}`;

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

module.exports = { pairKey, appendMessage, listMessages, lastMessage };
