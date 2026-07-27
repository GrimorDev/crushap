// In-memory online-presence tracking, ref-counted so a user with multiple
// tabs/devices connected stays "online" until every connection closes, not
// just the first one that disconnects. Per-API-instance by design — fine
// for the single-instance deployment this project assumes (see
// docker-compose.yml); a multi-instance deployment would need this shared
// via Redis the way ws.js already does for chat fan-out.
const counts = new Map();

function markOnline(userId) {
  counts.set(userId, (counts.get(userId) || 0) + 1);
}

function markOffline(userId) {
  const next = (counts.get(userId) || 0) - 1;
  if (next <= 0) counts.delete(userId);
  else counts.set(userId, next);
}

function isOnline(userId) {
  return counts.has(userId);
}

module.exports = { markOnline, markOffline, isOnline };
