const express = require('express');
const logger = require('./logger/logger');
const httpLogger = require('./logger/httpLogger');

const app = express();
const PORT = process.env.PORT || 3030;

app.use(express.json());
app.use(httpLogger);

app.get('/health', (req, res) => {
  req.log.info({ route: '/health' }, 'Health check');
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

app.get('/data', (req, res) => {
  req.log.info({ route: '/data' }, 'Data endpoint called');
  res.status(200).json({
    message: 'Hello from EC2!',
    data: {
      server: 'ec2-bootstrap',
      environment: process.env.NODE_ENV || 'development',
      timestamp: new Date().toISOString(),
      uptimeSec: process.uptime()
    }
  });
});

app.get('/', (req, res) => {
  req.log.info({ route: '/' }, 'Root endpoint called');
  res.status(200).json({
    message: 'Welcome to EC2 Bootstrap API',
    endpoints: ['/health', '/data']
  });
});

if (require.main === module) {
  app.listen(PORT, '0.0.0.0', () => {
    logger.info({ port: PORT }, 'Server started');
  });
}

process.on('uncaughtException', (err) => {
  logger.fatal({ err }, 'Uncaught exception');
  process.exit(1);
});

module.exports = app;