const { redis } = require('../redis');

const swipedKey = (id) => `swiped:${id}`;
const likedKey = (id) => `liked:${id}`;
const likedByKey = (id) => `likedBy:${id}`; // reverse index of likedKey, for "who liked me"
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
  await redis.zadd(likedByKey(targetId), Date.now(), userId);
  const mutual = (await redis.sismember(likedKey(targetId), userId)) === 1;
  if (!mutual) return false;

  const ts = Date.now();
  await redis.zadd(matchesKey(userId), ts, targetId);
  await redis.zadd(matchesKey(targetId), ts, userId);
  return true;
}

/// Everyone who's liked/superliked userId and isn't already a mutual match,
/// most-recent first — the "Likes" screen. Matched likers drop out since
/// they surface as a match instead once it's mutual.
async function listLikedBy(userId) {
  const likerIds = await redis.zrevrange(likedByKey(userId), 0, -1, 'WITHSCORES');
  const result = [];
  for (let i = 0; i < likerIds.length; i += 2) {
    const id = likerIds[i];
    const ts = Number(likerIds[i + 1]);
    if (await isMatch(userId, id)) continue;
    result.push({ id, likedAt: ts });
  }
  return result;
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
  await redis.zrem(likedByKey(targetId), userId);
  return true;
}

module.exports = { hasSwiped, swipedIds, recordSwipe, listMatches, listLikedBy, isMatch, undoSwipe };
