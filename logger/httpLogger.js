const pinoHttp = require('pino-http');
const logger = require('./logger');

module.exports = pinoHttp({
  logger,
  genReqId: (req) => req.headers['x-request-id'] || undefined
});