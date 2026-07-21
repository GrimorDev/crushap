const express = require('express');
const cors = require('cors');
const fs = require('fs');
const http = require('http');
const { port, uploadDir, corsOrigin } = require('./config');
const { attachWebSocketServer } = require('./ws');

fs.mkdirSync(uploadDir, { recursive: true });

// Last-resort net: every route and the WS message handler now catches its
// own errors (see asyncHandler.js / ws.js), so this should rarely fire —
// but logging beats the default Node behavior of crashing the whole
// process (taking down every other in-flight request) over one bug.
process.on('unhandledRejection', (reason) => {
  console.error('[fatal] unhandled rejection', reason);
});
process.on('uncaughtException', (err) => {
  console.error('[fatal] uncaught exception', err);
});

const app = express();
app.use(cors({ origin: corsOrigin === '*' ? true : corsOrigin.split(',') }));
app.use(express.json());
app.use('/uploads', express.static(uploadDir));

app.get('/health', (req, res) => res.json({ ok: true }));

app.use('/api/auth', require('./routes/auth'));
app.use('/api', require('./routes/profiles'));
app.use('/api/swipes', require('./routes/swipes'));
app.use('/api/matches', require('./routes/matches'));
app.use('/api/likes', require('./routes/likes'));
app.use('/api/chat', require('./routes/chat'));

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

const server = http.createServer(app);
attachWebSocketServer(server);

server.listen(port, () => {
  console.log(`crushap-server listening on :${port}`);
});
