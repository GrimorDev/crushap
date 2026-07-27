const express = require('express');
const users = require('../store/users');
const moderation = require('../store/moderation');
const { requireAuth } = require('../auth');
const { asyncHandler } = require('../asyncHandler');

const router = express.Router();
router.use(requireAuth);

router.get('/block', asyncHandler(async (req, res) => {
  const ids = await moderation.listBlocked(req.userId);
  const profiles = await Promise.all(
    ids.map(async (id) => {
      const raw = await users.getUserRaw(id);
      if (!raw) return null;
      const photos = await users.getPhotos(id);
      return users.toPublicProfile(raw, { photos });
    })
  );
  res.json({ blocked: profiles.filter(Boolean) });
}));

router.post('/block', asyncHandler(async (req, res) => {
  const { targetId } = req.body || {};
  if (!targetId) return res.status(400).json({ error: 'targetId is required' });
  if (targetId === req.userId) return res.status(400).json({ error: "Can't block yourself" });
  await moderation.block(req.userId, targetId);
  res.status(201).json({ ok: true });
}));

router.delete('/block/:targetId', asyncHandler(async (req, res) => {
  await moderation.unblock(req.userId, req.params.targetId);
  res.json({ ok: true });
}));

const VALID_REPORT_REASONS = new Set(['spam', 'inappropriate', 'fake_profile', 'other']);

router.post('/reports', asyncHandler(async (req, res) => {
  const { targetId, reason } = req.body || {};
  if (!targetId || !VALID_REPORT_REASONS.has(reason)) {
    return res.status(400).json({ error: 'targetId and a valid reason (spam/inappropriate/fake_profile/other) are required' });
  }
  await moderation.fileReport({ reporterId: req.userId, targetId, reason, ts: Date.now() });
  res.status(201).json({ ok: true });
}));

module.exports = router;
