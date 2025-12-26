FROM node:18-alpine

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm install

COPY server.js server.test.js ./

EXPOSE 3030

CMD ["node", "server.js"]

