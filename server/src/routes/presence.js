const express = require('express');
const users = require('../store/users');
const presence = require('../presence');
const { requireAuth } = require('../auth');
const { asyncHandler } = require('../asyncHandler');

const router = express.Router();
router.use(requireAuth);

router.get('/', asyncHandler(async (req, res) => {
  const ids = String(req.query.ids || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);

  const online = [];
  for (const id of ids) {
    if (!presence.isOnline(id)) continue;
    const raw = await users.getUserRaw(id);
    // Respect the account's own "show online status" preference — presence
    // is only ever reported for someone who opted into it.
    if (raw && raw.showOnlineStatus !== '0') online.push(id);
  }
  res.json({ online });
}));

module.exports = router;
