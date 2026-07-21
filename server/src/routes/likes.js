const express = require('express');
const users = require('../store/users');
const swipesStore = require('../store/swipes');
const { requireAuth } = require('../auth');
const { asyncHandler } = require('../asyncHandler');

const router = express.Router();
router.use(requireAuth);

// A liker counts as "new" for this long before just being part of "all" —
// there's no read/seen tracking, so this is the simplest stand-in for it.
const NEW_WINDOW_MS = 48 * 60 * 60 * 1000;

router.get('/', asyncHandler(async (req, res) => {
  const entries = await swipesStore.listLikedBy(req.userId);
  const now = Date.now();
  const profiles = await Promise.all(
    entries.map(async ({ id, likedAt }) => {
      const [raw, photos] = await Promise.all([users.getUserRaw(id), users.getPhotos(id)]);
      if (!raw) return null;
      return { ...users.toPublicProfile(raw, { photos }), likedAt, isNew: now - likedAt < NEW_WINDOW_MS };
    })
  );
  res.json({ likes: profiles.filter(Boolean) });
}));

module.exports = router;
