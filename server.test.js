const request = require('supertest');
const app = require('./server');

describe('API Endpoints', () => {
  describe('GET /', () => {
    it('should return welcome message and available endpoints', async () => {
      const response = await request(app).get('/');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('message');
      expect(response.body).toHaveProperty('endpoints');
      expect(response.body.endpoints).toContain('/health');
      expect(response.body.endpoints).toContain('/data');
    });
  });

  describe('GET /health', () => {
    it('should return healthy status', async () => {
      const response = await request(app).get('/health');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('status', 'healthy');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('uptime');
      expect(typeof response.body.uptime).toBe('number');
    });

    it('should return valid ISO timestamp', async () => {
      const response = await request(app).get('/health');
      const timestamp = new Date(response.body.timestamp);
      
      expect(timestamp.getTime()).not.toBeNaN();
    });
  });

  describe('GET /data', () => {
    it('should return data with correct structure', async () => {
      const response = await request(app).get('/data');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('message');
      expect(response.body).toHaveProperty('data');
      expect(response.body.data).toHaveProperty('server', 'ec2-bootstrap');
      expect(response.body.data).toHaveProperty('environment');
      expect(response.body.data).toHaveProperty('timestamp');
    });

    it('should return valid ISO timestamp in data', async () => {
      const response = await request(app).get('/data');
      const timestamp = new Date(response.body.data.timestamp);
      
      expect(timestamp.getTime()).not.toBeNaN();
    });
  });
});

