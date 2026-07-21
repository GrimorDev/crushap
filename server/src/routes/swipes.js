const express = require('express');
const users = require('../store/users');
const swipes = require('../store/swipes');
const { requireAuth } = require('../auth');
const { asyncHandler } = require('../asyncHandler');

const router = express.Router();
router.use(requireAuth);

const VALID_ACTIONS = new Set(['pass', 'like', 'superlike']);

router.post('/', asyncHandler(async (req, res) => {
  const { targetId, action } = req.body || {};
  if (!targetId || !VALID_ACTIONS.has(action)) {
    return res.status(400).json({ error: 'targetId and a valid action (pass/like/superlike) are required' });
  }
  if (targetId === req.userId) {
    return res.status(400).json({ error: "Can't swipe on yourself" });
  }
  if (await swipes.hasSwiped(req.userId, targetId)) {
    return res.status(409).json({ error: 'Already swiped on this profile' });
  }

  const matched = await swipes.recordSwipe(req.userId, targetId, action);
  if (!matched) return res.json({ matched: false });

  const raw = await users.getUserRaw(targetId);
  const photos = await users.getPhotos(targetId);
  res.json({ matched: true, profile: users.toPublicProfile(raw, { photos }) });
}));

router.post('/undo', asyncHandler(async (req, res) => {
  const { targetId } = req.body || {};
  if (!targetId) return res.status(400).json({ error: 'targetId is required' });
  const undone = await swipes.undoSwipe(req.userId, targetId);
  if (!undone) return res.status(409).json({ error: 'Nothing to undo (already matched, or no prior swipe)' });
  res.json({ ok: true });
}));

module.exports = router;
