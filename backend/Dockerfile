FROM node:18 AS build
WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install --production

COPY . .
RUN npm run build
FROM node:18
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=build /usr/src/app/dist ./dist

ENV PORT=3000
EXPOSE 3000
CMD ["node","dist/server.js"]
