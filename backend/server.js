'use strict';

const express = require('express');
const os = require('os');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  console.log('Root endpoint');
  res.end('I am: ' + os.hostname() + '\n');
});

app.get('/health', (req, res) => {
  res.writeHead(200, { "Content-Type": "text/html" });
  console.log('Health check endpoint');
  res.end("Service status: RUNNING\n");
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
