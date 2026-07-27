const express = require('express');
const users = require('../store/users');
const swipesStore = require('../store/swipes');
const chatStore = require('../store/chat');
const moderation = require('../store/moderation');
const { requireAuth } = require('../auth');
const { asyncHandler } = require('../asyncHandler');

const router = express.Router();
router.use(requireAuth);

router.get('/', asyncHandler(async (req, res) => {
  const [ids, blockedIds] = await Promise.all([
    swipesStore.listMatches(req.userId),
    moderation.exclusionSet(req.userId),
  ]);
  const profiles = await Promise.all(
    ids.filter((id) => !blockedIds.has(id)).map(async (id) => {
      const chatId = chatStore.pairKey(req.userId, id);
      const [raw, photos, lastMessage, lastReadAt] = await Promise.all([
        users.getUserRaw(id),
        users.getPhotos(id),
        chatStore.lastMessage(chatId),
        chatStore.lastReadAt(chatId, req.userId),
      ]);
      if (!raw) return null;
      const unread = !!(lastMessage && lastMessage.fromUserId !== req.userId && lastMessage.ts > lastReadAt);
      return { ...users.toPublicProfile(raw, { photos }), lastMessage, unread };
    })
  );
  res.json({ matches: profiles.filter(Boolean) });
}));

module.exports = router;
