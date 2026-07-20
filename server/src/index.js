const express = require('express');
const cors = require('cors');
const fs = require('fs');
const http = require('http');
const { port, uploadDir, corsOrigin } = require('./config');
const { attachWebSocketServer } = require('./ws');

fs.mkdirSync(uploadDir, { recursive: true });

const app = express();
app.use(cors({ origin: corsOrigin === '*' ? true : corsOrigin.split(',') }));
app.use(express.json());
app.use('/uploads', express.static(uploadDir));

app.get('/health', (req, res) => res.json({ ok: true }));

app.use('/api/auth', require('./routes/auth'));
app.use('/api', require('./routes/profiles'));
app.use('/api/swipes', require('./routes/swipes'));
app.use('/api/matches', require('./routes/matches'));
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
