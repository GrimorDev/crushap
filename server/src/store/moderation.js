const { redis } = require('../redis');

const blockedKey = (id) => `blocked:${id}`; // ids that `id` has blocked
const blockedByKey = (id) => `blockedBy:${id}`; // reverse index: ids who have blocked `id`
const reportsKey = 'reports';

async function block(userId, targetId) {
  await redis.sadd(blockedKey(userId), targetId);
  await redis.sadd(blockedByKey(targetId), userId);
}

async function unblock(userId, targetId) {
  await redis.srem(blockedKey(userId), targetId);
  await redis.srem(blockedByKey(targetId), userId);
}

async function isBlockedEitherWay(a, b) {
  const [ab, ba] = await Promise.all([
    redis.sismember(blockedKey(a), b),
    redis.sismember(blockedKey(b), a),
  ]);
  return ab === 1 || ba === 1;
}

/// Everyone that should never surface for `userId` — people they blocked,
/// and people who blocked them — for filtering discover/search/matches.
async function exclusionSet(userId) {
  const [iBlocked, blockedMe] = await Promise.all([
    redis.smembers(blockedKey(userId)),
    redis.smembers(blockedByKey(userId)),
  ]);
  return new Set([...iBlocked, ...blockedMe]);
}

async function listBlocked(userId) {
  return redis.smembers(blockedKey(userId));
}

async function fileReport(report) {
  await redis.rpush(reportsKey, JSON.stringify(report));
}

module.exports = { block, unblock, isBlockedEitherWay, exclusionSet, listBlocked, fileReport };
