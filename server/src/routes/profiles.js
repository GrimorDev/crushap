const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs/promises');
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

const VALID_GENDERS = new Set(['woman', 'man', 'nonbinary']);

router.patch('/me', async (req, res) => {
  const { name, bio, age, tags, gender, lat, lng } = req.body || {};
  if (gender != null && !VALID_GENDERS.has(gender)) {
    return res.status(400).json({ error: 'gender must be one of woman, man, nonbinary' });
  }
  await users.updateUser(req.userId, { name, bio, age, tags, gender, lat, lng });
  const raw = await users.getUserRaw(req.userId);
  const photos = await users.getPhotos(req.userId);
  res.json({ user: users.toPublicProfile(raw, { photos }) });
});

const MAX_PHOTOS = 6;

router.post('/me/photos', upload.single('photo'), async (req, res) => {
  if (!req.file) return res.status(400).json({ error: 'No image file under field "photo"' });
  const existing = await users.getPhotos(req.userId);
  if (existing.length >= MAX_PHOTOS) {
    await fs.unlink(path.join(uploadDir, req.file.filename)).catch(() => {});
    return res.status(400).json({ error: `You can have up to ${MAX_PHOTOS} photos` });
  }
  const url = `/uploads/${req.file.filename}`;
  await users.addPhoto(req.userId, url);
  res.status(201).json({ url });
});

router.delete('/me/photos', async (req, res) => {
  const { url } = req.body || {};
  if (!url) return res.status(400).json({ error: 'url is required' });
  await users.removePhoto(req.userId, url);
  const filename = path.basename(url);
  await fs.unlink(path.join(uploadDir, filename)).catch(() => {});
  res.status(204).end();
});

const GENDER_SHOW_ME = { women: 'woman', men: 'man' }; // 'everyone' (or absent) = no filter

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

  const maxAge = req.query.maxAge != null ? parseInt(req.query.maxAge, 10) : null;
  const maxDistanceKm = req.query.maxDistanceKm != null ? parseFloat(req.query.maxDistanceKm) : null;
  const verifiedOnly = req.query.verifiedOnly === 'true';
  const wantGender = GENDER_SHOW_ME[req.query.showMe] || null;

  // Filtering has to happen before the 30-profile cap, not after (we can't
  // know which candidates will pass without checking), so this fetches
  // every remaining candidate rather than just the first 30 — fine at the
  // "small deployment" scale this shuffle-based approach already assumes.
  const candidates = await Promise.all(
    candidateIds.map(async (id) => {
      const [raw, photos, distanceKm] = await Promise.all([
        users.getUserRaw(id),
        users.getPhotos(id),
        users.distanceKm(req.userId, id),
      ]);
      if (!raw) return null;
      if (maxAge != null && parseInt(raw.age, 10) > maxAge) return null;
      if (verifiedOnly && raw.verified !== '1') return null;
      if (wantGender && raw.gender !== wantGender) return null;
      // Only enforce a distance cap when we actually know the distance —
      // a user who hasn't shared their location shouldn't just vanish
      // from everyone's discovery because we can't measure it.
      if (maxDistanceKm != null && distanceKm != null && distanceKm > maxDistanceKm) return null;
      return users.toPublicProfile(raw, { photos, distance: distanceKm });
    })
  );
  res.json({ profiles: candidates.filter(Boolean).slice(0, 30) });
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
