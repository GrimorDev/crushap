require('dotenv').config();

function required(name, fallback) {
  const v = process.env[name] ?? fallback;
  if (v === undefined) throw new Error(`Missing required env var: ${name}`);
  return v;
}

module.exports = {
  port: parseInt(process.env.PORT || '3000', 10),
  redisUrl: required('REDIS_URL', 'redis://127.0.0.1:6379'),
  jwtSecret: required('JWT_SECRET', 'dev-only-secret-change-me'),
  uploadDir: required('UPLOAD_DIR', './uploads'),
  corsOrigin: process.env.CORS_ORIGIN || '*',
};
