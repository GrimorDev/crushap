const { v4: uuid } = require('uuid');
const { redis } = require('../redis');

const emailKey = (email) => `email:index:${email.toLowerCase().trim()}`;
const userKey = (id) => `user:${id}`;
const photosKey = (id) => `user:${id}:photos`;

async function createUser({ name, email, passwordHash, age, bio, tags }) {
  const id = uuid();
  await redis.hset(userKey(id), {
    id,
    name,
    email: email.toLowerCase().trim(),
    passwordHash,
    age: String(age),
    bio: bio || '',
    tags: JSON.stringify(tags || []),
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
  const patch = {};
  if (fields.name !== undefined) patch.name = fields.name;
  if (fields.bio !== undefined) patch.bio = fields.bio;
  if (fields.age !== undefined) patch.age = String(fields.age);
  if (fields.tags !== undefined) patch.tags = JSON.stringify(fields.tags);
  if (Object.keys(patch).length) await redis.hset(userKey(id), patch);
  if (fields.lat !== undefined && fields.lng !== undefined) {
    await redis.geoadd('geo:users', fields.lng, fields.lat, id);
  }
}

async function addPhoto(id, url) {
  await redis.rpush(photosKey(id), url);
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
  getPhotos,
  allUserIds,
  distanceKm,
  toPublicProfile,
};
