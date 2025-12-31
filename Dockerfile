FROM node:18-alpine

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci --only=production && npm cache clean --force

COPY . .

EXPOSE 3030

USER node

CMD ["node", "server.js"]
