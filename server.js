const express = require('express');
const app = express();
const PORT = process.env.PORT || 3030;

app.use(express.json());

// TODO: CloudWatch Logs + EC2 worker

app.get('/health', (req, res) => {
  console.log('[INFO] route: /health');
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

app.get('/data', (req, res) => {
  console.log('[INFO] route: /data');
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
  console.log('[INFO] route: /data');
  res.status(200).json({
    message: 'Welcome to EC2 Bootstrap API',
    endpoints: ['/health', '/data']
  });
});

if (require.main === module) {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
  });
}

module.exports = app;

