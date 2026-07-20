const { redis } = require('../redis');

const swipedKey = (id) => `swiped:${id}`;
const likedKey = (id) => `liked:${id}`;
const matchesKey = (id) => `matches:${id}`;

async function hasSwiped(userId, targetId) {
  return (await redis.hexists(swipedKey(userId), targetId)) === 1;
}

async function swipedIds(userId) {
  return redis.hkeys(swipedKey(userId));
}

/// Records the swipe and, for like/superlike, checks for a mutual match.
/// Returns true if this swipe just created a match.
async function recordSwipe(userId, targetId, action) {
  await redis.hset(swipedKey(userId), targetId, action);
  if (action === 'pass') return false;

  await redis.sadd(likedKey(userId), targetId);
  const mutual = (await redis.sismember(likedKey(targetId), userId)) === 1;
  if (!mutual) return false;

  const ts = Date.now();
  await redis.zadd(matchesKey(userId), ts, targetId);
  await redis.zadd(matchesKey(targetId), ts, userId);
  return true;
}

/// Most-recently-matched first.
async function listMatches(userId) {
  return redis.zrevrange(matchesKey(userId), 0, -1);
}

async function isMatch(userId, otherId) {
  const score = await redis.zscore(matchesKey(userId), otherId);
  return score !== null;
}

/// Reverts the caller's swipe on targetId so it can be shown again — only
/// when it didn't create a match (a match is a shared, persistent fact
/// between two accounts; one side "undoing" it would silently pull the rug
/// from under the other person). Returns false if there was nothing to
/// undo or a match already exists.
async function undoSwipe(userId, targetId) {
  if (await isMatch(userId, targetId)) return false;
  const removed = await redis.hdel(swipedKey(userId), targetId);
  if (!removed) return false;
  await redis.srem(likedKey(userId), targetId);
  return true;
}

module.exports = { hasSwiped, swipedIds, recordSwipe, listMatches, isMatch, undoSwipe };
