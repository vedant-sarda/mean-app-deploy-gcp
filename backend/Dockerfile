cat > backend/Dockerfile <<'EOF'
# Use official Node image
FROM node:18

# Create app directory
WORKDIR /usr/src/app

# Copy package files first (for cache)
COPY package*.json ./

# Install dependencies (use npm ci when package-lock exists)
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

# Copy app source
COPY . .

# If a build script exists in package.json, run it; otherwise skip.
# This handles TypeScript builds while not breaking pure JS apps.
RUN if npm run | grep -q " build"; then echo "Running build script" && npm run build; else echo "No build script - skipping build step"; fi

# Make entrypoint executable
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV PORT=3000
EXPOSE 3000

# Use the entrypoint which decides how to start the app
CMD ["docker-entrypoint.sh"]
EOF
