const express = require('express');
const users = require('../store/users');
const swipesStore = require('../store/swipes');
const chatStore = require('../store/chat');
const { requireAuth } = require('../auth');

const router = express.Router();
router.use(requireAuth);

router.get('/', async (req, res) => {
  const ids = await swipesStore.listMatches(req.userId);
  const profiles = await Promise.all(
    ids.map(async (id) => {
      const chatId = chatStore.pairKey(req.userId, id);
      const [raw, photos, lastMessage] = await Promise.all([
        users.getUserRaw(id),
        users.getPhotos(id),
        chatStore.lastMessage(chatId),
      ]);
      return raw ? { ...users.toPublicProfile(raw, { photos }), lastMessage } : null;
    })
  );
  res.json({ matches: profiles.filter(Boolean) });
});

module.exports = router;
