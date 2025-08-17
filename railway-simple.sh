#!/bin/bash

# Railway provides PORT environment variable
export PORT=${PORT:-8080}
echo "Starting Docker Android on Railway with PORT=$PORT"

# Force environment variables
export EMULATOR_DEVICE="${EMULATOR_DEVICE:-Nexus 5}"
export WEB_VNC=true
export EMULATOR_NO_BOOT_ANIM=true
export EMULATOR_ADDITIONAL_ARGS="-gpu swiftshader_indirect -no-audio -no-boot-anim -memory 1024"
export DISPLAY=:0

echo "=== Environment Variables ==="
echo "EMULATOR_DEVICE: $EMULATOR_DEVICE"
echo "WEB_VNC: $WEB_VNC"
echo "EMULATOR_NO_BOOT_ANIM: $EMULATOR_NO_BOOT_ANIM"
echo "EMULATOR_ADDITIONAL_ARGS: $EMULATOR_ADDITIONAL_ARGS"
echo "=========================="

# Generate nginx config
sed "s/\${PORT}/$PORT/g" /etc/nginx/nginx.conf.template > /tmp/nginx.conf

# Start nginx first
echo "Starting nginx on port $PORT..."
/usr/sbin/nginx -c /tmp/nginx.conf -g "daemon off;" &
NGINX_PID=$!

# Give nginx time to start
sleep 5

# Now start the emulator
echo "Starting Android emulator..."
cd /home/androidusr
exec /home/androidusr/docker-android/mixins/scripts/run.sh