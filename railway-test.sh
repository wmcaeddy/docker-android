#!/bin/bash

# Test script to verify Android emulator is working

echo "=== Android Emulator Test Script ==="
echo "Testing basic functionality..."

# Check processes
echo -e "\n--- Running Processes ---"
ps aux | grep -E "(emulator|qemu|adb|vnc)" | grep -v grep

# Check ADB
echo -e "\n--- ADB Status ---"
if command -v adb &> /dev/null; then
    adb devices
else
    echo "ADB not found"
fi

# Check display
echo -e "\n--- Display Status ---"
echo "DISPLAY=$DISPLAY"
if [ -S /tmp/.X11-unix/X0 ]; then
    echo "X11 socket exists"
else
    echo "X11 socket NOT found"
fi

# Check VNC
echo -e "\n--- VNC Status ---"
if pgrep -x "x11vnc" > /dev/null; then
    echo "VNC server is running"
else
    echo "VNC server is NOT running"
fi

# Check device status
echo -e "\n--- Device Status ---"
if [ -f /home/androidusr/device_status ]; then
    echo "Status: $(cat /home/androidusr/device_status)"
else
    echo "Device status file not found"
fi

# Check emulator logs
echo -e "\n--- Recent Emulator Logs ---"
if [ -f /home/androidusr/.android/avd/*.avd/config.ini ]; then
    echo "AVD config found"
fi

echo -e "\n=== End of Test ==="