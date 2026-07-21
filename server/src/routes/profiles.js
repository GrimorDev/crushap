const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs/promises');
const { v4: uuid } = require('uuid');
const users = require('../store/users');
const swipes = require('../store/swipes');
const { requireAuth } = require('../auth');
const { uploadDir } = require('../config');
const { asyncHandler } = require('../asyncHandler');

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

router.get('/me', asyncHandler(async (req, res) => {
  const raw = await users.getUserRaw(req.userId);
  const photos = await users.getPhotos(req.userId);
  res.json({ user: users.toPublicProfile(raw, { photos }) });
}));

const VALID_GENDERS = new Set(['woman', 'man', 'nonbinary']);
const VALID_LOOKING_FOR = new Set(['relationship', 'casual', 'friends', 'unsure']);

router.patch('/me', asyncHandler(async (req, res) => {
  const { name, bio, age, tags, gender, lookingFor, lat, lng } = req.body || {};
  if (gender != null && !VALID_GENDERS.has(gender)) {
    return res.status(400).json({ error: 'gender must be one of woman, man, nonbinary' });
  }
  if (lookingFor != null && !VALID_LOOKING_FOR.has(lookingFor)) {
    return res.status(400).json({ error: 'lookingFor must be one of relationship, casual, friends, unsure' });
  }
  await users.updateUser(req.userId, { name, bio, age, tags, gender, lookingFor, lat, lng });
  const raw = await users.getUserRaw(req.userId);
  const photos = await users.getPhotos(req.userId);
  res.json({ user: users.toPublicProfile(raw, { photos }) });
}));

const MAX_PHOTOS = 6;

router.post('/me/photos', upload.single('photo'), asyncHandler(async (req, res) => {
  if (!req.file) return res.status(400).json({ error: 'No image file under field "photo"' });
  const existing = await users.getPhotos(req.userId);
  if (existing.length >= MAX_PHOTOS) {
    await fs.unlink(path.join(uploadDir, req.file.filename)).catch(() => {});
    return res.status(400).json({ error: `You can have up to ${MAX_PHOTOS} photos` });
  }
  const url = `/uploads/${req.file.filename}`;
  await users.addPhoto(req.userId, url);
  res.status(201).json({ url });
}));

router.delete('/me/photos', asyncHandler(async (req, res) => {
  const { url } = req.body || {};
  if (!url) return res.status(400).json({ error: 'url is required' });
  await users.removePhoto(req.userId, url);
  const filename = path.basename(url);
  await fs.unlink(path.join(uploadDir, filename)).catch(() => {});
  res.status(204).end();
}));

const GENDER_SHOW_ME = { women: 'woman', men: 'man' }; // 'everyone' (or absent) = no filter

// Discovery is meant to prioritize real proximity, but a strict filter
// combination can easily leave someone staring at an empty deck in a
// smaller deployment. Rather than fail that way, /discover relaxes
// "soft" preferences one at a time — cheapest-to-give-up first — until
// there are enough candidates, or there's nothing left to relax.
// `showMe` (gender preference) is never auto-relaxed: it's a deliberate
// choice, not a nice-to-have, so it stays a hard filter throughout.
// `maxDistanceKm` is relaxed last, since "mainly by location" is the
// point of the feature — everything else gives way before that does.
const MIN_RESULTS = 5;
const RELAX_ORDER = ['hasPhoto', 'tags', 'verifiedOnly', 'maxAge', 'maxDistanceKm'];

router.get('/discover', asyncHandler(async (req, res) => {
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
  const hasPhotoOnly = req.query.hasPhoto === 'true';
  const wantGender = GENDER_SHOW_ME[req.query.showMe] || null;
  // 'friends' mode is a distinct discovery intent, not a preference to
  // relax away from — same treatment as gender: a hard filter throughout.
  const friendsMode = req.query.mode === 'friends';
  const wantTags = String(req.query.tags || '')
    .split(',')
    .map((t) => t.trim().toLowerCase())
    .filter(Boolean);

  // Fetched once per candidate, up front — filtering has to happen before
  // the 30-profile cap (we can't know who'll pass without checking), and
  // the relaxation ladder below re-evaluates the same data multiple times.
  // Fine at the "small deployment" scale this endpoint already assumes.
  const enriched = (
    await Promise.all(
      candidateIds.map(async (id) => {
        const [raw, photos, distanceKm] = await Promise.all([
          users.getUserRaw(id),
          users.getPhotos(id),
          users.distanceKm(req.userId, id),
        ]);
        if (!raw) return null;
        if (!Number.isFinite(parseInt(raw.age, 10))) return null; // hard filter — broken/legacy data, not swipeable
        if (wantGender && raw.gender !== wantGender) return null; // hard filter
        if (friendsMode && raw.lookingFor !== 'friends') return null; // hard filter
        const tags = users.parseTags(raw).map((t) => t.toLowerCase());
        return {
          raw,
          photos,
          distanceKm,
          passes: {
            hasPhoto: photos.length > 0,
            tags: wantTags.some((t) => tags.includes(t)),
            verifiedOnly: raw.verified === '1',
            maxAge: maxAge == null || parseInt(raw.age, 10) <= maxAge,
            // Only enforce a distance cap when we actually know the distance
            // — a candidate who hasn't shared their location shouldn't just
            // vanish from discovery because it can't be measured.
            maxDistanceKm: distanceKm == null || (maxDistanceKm != null && distanceKm <= maxDistanceKm),
          },
        };
      })
    )
  ).filter(Boolean);

  const active = new Set();
  if (hasPhotoOnly) active.add('hasPhoto');
  if (wantTags.length) active.add('tags');
  if (verifiedOnly) active.add('verifiedOnly');
  if (maxAge != null) active.add('maxAge');
  if (maxDistanceKm != null) active.add('maxDistanceKm');

  const dropped = [];
  const evaluate = () => {
    const required = [...active].filter((f) => !dropped.includes(f));
    return enriched.filter((c) => required.every((f) => c.passes[f]));
  };

  let matched = evaluate();
  while (matched.length < MIN_RESULTS) {
    const next = RELAX_ORDER.find((f) => active.has(f) && !dropped.includes(f));
    if (!next) break; // nothing left we're allowed to relax
    dropped.push(next);
    matched = evaluate();
  }

  const profiles = matched.slice(0, 30).map((c) => users.toPublicProfile(c.raw, { photos: c.photos, distance: c.distanceKm }));
  res.json({ profiles, relaxedFilters: dropped });
}));

router.get('/search', asyncHandler(async (req, res) => {
  const q = String(req.query.q || '').trim().toLowerCase();
  const allIds = await users.allUserIds();
  const candidateIds = allIds.filter((id) => id !== req.userId);

  const profiles = await Promise.all(
    candidateIds.map(async (id) => {
      const raw = await users.getUserRaw(id);
      if (!raw) return null;
      const tags = users.parseTags(raw);
      const isMatch = !q || raw.name.toLowerCase().includes(q) || tags.some((t) => t.toLowerCase().includes(q));
      if (!isMatch) return null;
      const photos = await users.getPhotos(id);
      return users.toPublicProfile(raw, { photos });
    })
  );
  res.json({ profiles: profiles.filter(Boolean).slice(0, 50) });
}));

module.exports = router;
