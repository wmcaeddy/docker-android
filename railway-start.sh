#!/bin/bash

# Railway provides PORT environment variable
export PORT=${PORT:-8080}
echo "Starting Docker Android on Railway with PORT=$PORT"

# Create required directories
mkdir -p /tmp/nginx /tmp/supervisor

# Generate nginx config from template - replace PORT placeholder
sed "s/\${PORT}/$PORT/g" /etc/nginx/nginx.conf.template > /tmp/nginx.conf

# Debug: Show the generated config
echo "Generated nginx config:"
head -n 35 /tmp/nginx.conf

# Start the original emulator script in background
/home/androidusr/docker-android/mixins/scripts/run.sh &
EMULATOR_PID=$!

# Wait a bit for emulator to start
sleep 10

# Start nginx
/usr/sbin/nginx -c /tmp/nginx.conf -g "daemon off;" &
NGINX_PID=$!

# Function to handle shutdown
cleanup() {
    echo "Shutting down..."
    kill $NGINX_PID $EMULATOR_PID 2>/dev/null
    wait $NGINX_PID $EMULATOR_PID
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Wait for any process to exit
wait -n

# If we get here, something died
cleanup