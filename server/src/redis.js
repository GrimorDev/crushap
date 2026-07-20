const Redis = require('ioredis');
const { redisUrl } = require('./config');

// ioredis requires a dedicated connection for pub/sub mode (a subscribed
// connection can't run normal commands), so chat.js/ws.js get separate
// clients from the general-purpose one used by the store/* modules.
const redis = new Redis(redisUrl);
const publisher = new Redis(redisUrl);
const subscriber = new Redis(redisUrl);

redis.on('error', (err) => console.error('[redis]', err.message));
publisher.on('error', (err) => console.error('[redis:pub]', err.message));
subscriber.on('error', (err) => console.error('[redis:sub]', err.message));

module.exports = { redis, publisher, subscriber };
