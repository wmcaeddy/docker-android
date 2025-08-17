#!/bin/bash

# Railway provides PORT environment variable
export PORT=${PORT:-8080}
echo "Starting Docker Android on Railway with PORT=$PORT"

# Show all environment variables for debugging
echo "=== Environment Variables ==="
echo "EMULATOR_DEVICE: $EMULATOR_DEVICE"
echo "WEB_VNC: $WEB_VNC"
echo "EMULATOR_NO_BOOT_ANIM: $EMULATOR_NO_BOOT_ANIM"
echo "EMULATOR_ADDITIONAL_ARGS: $EMULATOR_ADDITIONAL_ARGS"
echo "DISPLAY: $DISPLAY"
echo "=========================="

# Create required directories
mkdir -p /tmp/nginx /tmp/supervisor

# Generate nginx config from template - replace PORT placeholder
sed "s/\${PORT}/$PORT/g" /etc/nginx/nginx.conf.template > /tmp/nginx.conf

# Debug: Show the generated config
echo "Generated nginx config:"
head -n 35 /tmp/nginx.conf

# Check if KVM is available
if [ -e /dev/kvm ]; then
    echo "KVM is available"
else
    echo "WARNING: KVM is NOT available - emulator will run very slowly"
fi

# Start the original emulator script in background
echo "Starting emulator script..."
/home/androidusr/docker-android/mixins/scripts/run.sh &
EMULATOR_PID=$!

# Wait a bit for emulator to start initializing
sleep 20

# Start nginx
/usr/sbin/nginx -c /tmp/nginx.conf -g "daemon off;" &
NGINX_PID=$!

# Show emulator status
echo "Checking emulator status..."
for i in {1..20}; do
    if [ -f /home/androidusr/device_status ]; then
        echo "Device status: $(cat /home/androidusr/device_status)"
    fi
    
    # Check if emulator process is running
    if pgrep -f "qemu-system" > /dev/null; then
        echo "Emulator process is running"
    else
        echo "WARNING: Emulator process not found!"
    fi
    
    # Check VNC
    if pgrep -x "x11vnc" > /dev/null; then
        echo "VNC server is running on port 5900"
    else
        echo "WARNING: VNC server not running!"
    fi
    
    # Check for Android boot completion
    if [ -f /home/androidusr/device_status ] && grep -q "booted" /home/androidusr/device_status; then
        echo "Android has booted successfully!"
        break
    fi
    
    echo "Waiting for Android to boot... ($i/20)"
    sleep 15
done

# Show final status
echo "=== Final Status Check ==="
ps aux | grep -E "(emulator|qemu|x11vnc|websockify)" | grep -v grep || echo "No emulator processes found!"

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