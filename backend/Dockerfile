# backend/Dockerfile (robust: works with or without package-lock.json and with/without build script)

FROM node:18 AS build
WORKDIR /usr/src/app

# 1) copy package manifest and optional lockfile first for layer caching
COPY package*.json ./
COPY package-lock*.json ./

# 2) install dependencies: prefer npm ci when lockfile exists, otherwise fall back to npm install
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

# 3) copy source
COPY . .

# 4) run build only if a "build" script exists in package.json
#    This avoids failing when project is plain JS (no build step).
RUN if node -e "process.exit(typeof(require('./package.json').scripts?.build)==='string' ? 0 : 1)"; then \
      echo 'build script found — running npm run build' && npm run build; \
    else \
      echo 'no build script found — skipping build step'; \
    fi

########### Production stage ############
FROM node:18
WORKDIR /usr/src/app

# copy package manifests & lockfile to install prod deps
COPY package*.json ./
COPY package-lock*.json ./

# install production deps (prefer npm ci when lockfile exists)
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

# copy built artifacts and other files from build stage
COPY --from=build /usr/src/app ./

ENV PORT=3000
EXPOSE 3000

# Start command:
# - prefer running built artifact at dist/server.js if present (TypeScript builds),
# - otherwise fallback to npm start (ensure package.json has start script).
CMD ["sh", "-lc", "if [ -f dist/server.js ]; then exec node dist/server.js; else exec npm start; fi"]
