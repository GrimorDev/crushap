const jwt = require('jsonwebtoken');
const { jwtSecret } = require('./config');

function signToken(userId) {
  return jwt.sign({ sub: userId }, jwtSecret, { expiresIn: '30d' });
}

function verifyToken(token) {
  const payload = jwt.verify(token, jwtSecret);
  return payload.sub;
}

function requireAuth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return res.status(401).json({ error: 'Missing bearer token' });
  try {
    req.userId = verifyToken(token);
    next();
  } catch {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
}

module.exports = { signToken, verifyToken, requireAuth };
