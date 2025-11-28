set -e
if npm run | grep -q " start"; then
  echo "Starting via 'npm start'..."
  exec npm start
fi

if [ -f ./server.js ]; then
  echo "Starting server.js"
  exec node server.js
fi

if [ -f ./index.js ]; then
  echo "Starting index.js"
  exec node index.js
fi
if [ -f ./app.js ]; then
  echo "Starting app.js"
  exec node app.js
fi
echo "ERROR: No start script and no server.js/index.js/app.js found. Please add a start script to package.json or add server.js/index.js/app.js"
exit 1
