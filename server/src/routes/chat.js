const express = require('express');
const swipesStore = require('../store/swipes');
const chatStore = require('../store/chat');
const { requireAuth } = require('../auth');

const router = express.Router();
router.use(requireAuth);

router.get('/:otherUserId/messages', async (req, res) => {
  const { otherUserId } = req.params;
  if (!(await swipesStore.isMatch(req.userId, otherUserId))) {
    return res.status(403).json({ error: 'Not matched with this user' });
  }
  const chatId = chatStore.pairKey(req.userId, otherUserId);
  const messages = await chatStore.listMessages(chatId);
  res.json({ messages });
});

module.exports = router;
