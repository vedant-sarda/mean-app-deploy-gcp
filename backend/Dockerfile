# backend/Dockerfile
FROM node:18 AS build
WORKDIR /usr/src/app

# copy package manifests first for efficient caching
COPY package*.json ./
# copy lockfile if present
COPY package-lock*.json ./

# If package-lock.json exists, npm ci (reproducible). Otherwise npm install.
RUN if [ -f package-lock.json ]; then npm ci; else npm install --omit=dev; fi

# copy rest and build
COPY . .
RUN npm run build

FROM node:18
WORKDIR /usr/src/app

COPY package*.json ./
COPY package-lock*.json ./

# same conditional for production install
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

# copy built artifacts
COPY --from=build /usr/src/app/dist ./dist

ENV PORT=3000
EXPOSE 3000
CMD ["node", "dist/server.js"]
