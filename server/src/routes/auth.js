const express = require('express');
const bcrypt = require('bcryptjs');
const users = require('../store/users');
const { signToken } = require('../auth');

const router = express.Router();

const VALID_GENDERS = new Set(['woman', 'man', 'nonbinary']);

router.post('/register', async (req, res) => {
  const { name, email, password, age, bio, tags, gender } = req.body || {};
  if (!name || !email || !password || !age) {
    return res.status(400).json({ error: 'name, email, password, age are required' });
  }
  if (String(password).length < 6) {
    return res.status(400).json({ error: 'Password must be at least 6 characters' });
  }
  if (gender != null && !VALID_GENDERS.has(gender)) {
    return res.status(400).json({ error: 'gender must be one of woman, man, nonbinary' });
  }
  if (await users.findIdByEmail(email)) {
    return res.status(409).json({ error: 'An account with that email already exists' });
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const id = await users.createUser({ name, email, passwordHash, age, bio, tags, gender });
  const token = signToken(id);
  const raw = await users.getUserRaw(id);
  res.status(201).json({ token, user: users.toPublicProfile(raw) });
});

router.post('/login', async (req, res) => {
  const { email, password } = req.body || {};
  if (!email || !password) return res.status(400).json({ error: 'email and password are required' });

  const id = await users.findIdByEmail(email);
  if (!id) return res.status(401).json({ error: 'Invalid email or password' });

  const raw = await users.getUserRaw(id);
  const ok = raw && (await bcrypt.compare(password, raw.passwordHash));
  if (!ok) return res.status(401).json({ error: 'Invalid email or password' });

  const token = signToken(id);
  const photos = await users.getPhotos(id);
  res.json({ token, user: users.toPublicProfile(raw, { photos }) });
});

module.exports = router;
