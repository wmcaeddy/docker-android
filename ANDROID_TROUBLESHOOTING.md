# Android Emulator Troubleshooting on Railway

## If you can access VNC but don't see Android:

### 1. Check Environment Variables
Make sure these are set in Railway's Variables tab:
```
EMULATOR_DEVICE=Samsung Galaxy S10
WEB_VNC=true
EMULATOR_NO_BOOT_ANIM=true
EMULATOR_ADDITIONAL_ARGS=-gpu swiftshader_indirect -no-audio -no-boot-anim
```

### 2. Wait for Boot
The Android emulator takes 3-5 minutes to boot on Railway. You should see:
- First: Black screen with VNC connected
- Then: Android boot animation (if not disabled)
- Finally: Android home screen

### 3. Check Logs
In Railway dashboard, check the Deploy Logs for:
- "Device status: booted" - emulator is ready
- "Device status: booting" - still starting
- Any error messages about the emulator

### 4. Common Issues:

**Black Screen in VNC:**
- Emulator is still booting (wait 3-5 minutes)
- Check if environment variables are set correctly

**Connection Refused:**
- Service is still starting
- Check health status in Railway dashboard

**Emulator Crashes:**
- Railway might not have enough resources
- Try a lighter device profile (Nexus 5 instead of Samsung Galaxy S10)

### 5. Alternative Device Profiles
If Samsung Galaxy S10 doesn't work, try:
```
EMULATOR_DEVICE=Nexus 5
EMULATOR_DEVICE=Nexus 4
EMULATOR_DEVICE=Nexus S
```

### 6. Debug Commands
To check emulator status, look for these in logs:
- "emulator: INFO: boot completed"
- "Boot completed in X ms"
- Device status file contents

### 7. Resource Limits
Railway free tier has limited resources. The Android emulator needs:
- At least 2GB RAM
- Significant CPU resources
- Consider upgrading to a paid plan for better performance