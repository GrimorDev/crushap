const express = require('express');
const multer = require('multer');
const path = require('path');
const { v4: uuid } = require('uuid');
const users = require('../store/users');
const swipes = require('../store/swipes');
const { requireAuth } = require('../auth');
const { uploadDir } = require('../config');

const router = express.Router();

const upload = multer({
  storage: multer.diskStorage({
    destination: uploadDir,
    filename: (req, file, cb) => {
      const ext = path.extname(file.originalname || '').toLowerCase() || '.jpg';
      cb(null, `${uuid()}${ext}`);
    },
  }),
  limits: { fileSize: 8 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    cb(null, /^image\//.test(file.mimetype));
  },
});

router.use(requireAuth);

router.get('/me', async (req, res) => {
  const raw = await users.getUserRaw(req.userId);
  const photos = await users.getPhotos(req.userId);
  res.json({ user: users.toPublicProfile(raw, { photos }) });
});

router.patch('/me', async (req, res) => {
  const { name, bio, age, tags, lat, lng } = req.body || {};
  await users.updateUser(req.userId, { name, bio, age, tags, lat, lng });
  const raw = await users.getUserRaw(req.userId);
  const photos = await users.getPhotos(req.userId);
  res.json({ user: users.toPublicProfile(raw, { photos }) });
});

router.post('/me/photos', upload.single('photo'), async (req, res) => {
  if (!req.file) return res.status(400).json({ error: 'No image file under field "photo"' });
  const url = `/uploads/${req.file.filename}`;
  await users.addPhoto(req.userId, url);
  res.status(201).json({ url });
});

router.get('/discover', async (req, res) => {
  const [allIds, swipedIds] = await Promise.all([
    users.allUserIds(),
    swipes.swipedIds(req.userId),
  ]);
  const excluded = new Set([req.userId, ...swipedIds]);
  const candidateIds = allIds.filter((id) => !excluded.has(id));

  // Small deployments = small candidate pools; a plain shuffle is enough,
  // no need for cursor-based pagination yet.
  for (let i = candidateIds.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [candidateIds[i], candidateIds[j]] = [candidateIds[j], candidateIds[i]];
  }

  const chosen = candidateIds.slice(0, 30);
  const profiles = await Promise.all(
    chosen.map(async (id) => {
      const [raw, photos, distanceKm] = await Promise.all([
        users.getUserRaw(id),
        users.getPhotos(id),
        users.distanceKm(req.userId, id),
      ]);
      return raw ? users.toPublicProfile(raw, { photos, distance: distanceKm }) : null;
    })
  );
  res.json({ profiles: profiles.filter(Boolean) });
});

router.get('/search', async (req, res) => {
  const q = String(req.query.q || '').trim().toLowerCase();
  const allIds = await users.allUserIds();
  const candidateIds = allIds.filter((id) => id !== req.userId);

  const profiles = await Promise.all(
    candidateIds.map(async (id) => {
      const raw = await users.getUserRaw(id);
      if (!raw) return null;
      const tags = JSON.parse(raw.tags || '[]');
      const isMatch = !q || raw.name.toLowerCase().includes(q) || tags.some((t) => t.toLowerCase().includes(q));
      if (!isMatch) return null;
      const photos = await users.getPhotos(id);
      return users.toPublicProfile(raw, { photos });
    })
  );
  res.json({ profiles: profiles.filter(Boolean).slice(0, 50) });
});

module.exports = router;
