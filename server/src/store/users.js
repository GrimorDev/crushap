const { v4: uuid } = require('uuid');
const { redis } = require('../redis');

const emailKey = (email) => `email:index:${email.toLowerCase().trim()}`;
const userKey = (id) => `user:${id}`;
const photosKey = (id) => `user:${id}:photos`;

async function createUser({ name, email, passwordHash, age, bio, tags, gender }) {
  const id = uuid();
  await redis.hset(userKey(id), {
    id,
    name,
    email: email.toLowerCase().trim(),
    passwordHash,
    age: String(age),
    bio: bio || '',
    tags: JSON.stringify(tags || []),
    gender: gender || '',
    verified: '0',
    createdAt: String(Date.now()),
  });
  await redis.set(emailKey(email), id);
  await redis.sadd('users:all', id);
  return id;
}

async function findIdByEmail(email) {
  return redis.get(emailKey(email));
}

async function getUserRaw(id) {
  const data = await redis.hgetall(userKey(id));
  return Object.keys(data).length ? data : null;
}

async function updateUser(id, fields) {
  // `!= null` (loose) catches both a missing key AND an explicit `null` —
  // a client sending `{"name": null}` must not blank out the field (and,
  // for `age`, would otherwise store the literal string "null", which
  // then fails to parse back into an int and breaks the profile).
  const patch = {};
  if (fields.name != null) patch.name = fields.name;
  if (fields.bio != null) patch.bio = fields.bio;
  if (fields.age != null) patch.age = String(fields.age);
  if (fields.tags != null) patch.tags = JSON.stringify(fields.tags);
  if (fields.gender != null) patch.gender = fields.gender;
  if (Object.keys(patch).length) await redis.hset(userKey(id), patch);
  if (fields.lat != null && fields.lng != null) {
    await redis.geoadd('geo:users', fields.lng, fields.lat, id);
  }
}

async function addPhoto(id, url) {
  await redis.rpush(photosKey(id), url);
}

async function removePhoto(id, url) {
  await redis.lrem(photosKey(id), 0, url);
}

async function getPhotos(id) {
  return redis.lrange(photosKey(id), 0, -1);
}

async function allUserIds() {
  return redis.smembers('users:all');
}

/// Real distance in km between two users, if both have opted into geo
/// (via PATCH /api/me with lat/lng) — null otherwise. Never fabricated.
async function distanceKm(fromId, toId) {
  const d = await redis.geodist('geo:users', fromId, toId, 'km');
  return d === null ? null : Math.round(parseFloat(d) * 10) / 10;
}

function toPublicProfile(raw, { photos = [], distance = null } = {}) {
  return {
    id: raw.id,
    name: raw.name,
    age: parseInt(raw.age, 10),
    bio: raw.bio || '',
    tags: JSON.parse(raw.tags || '[]'),
    gender: raw.gender || null,
    verified: raw.verified === '1',
    photos,
    distanceKm: distance,
  };
}

module.exports = {
  createUser,
  findIdByEmail,
  getUserRaw,
  updateUser,
  addPhoto,
  removePhoto,
  getPhotos,
  allUserIds,
  distanceKm,
  toPublicProfile,
};
