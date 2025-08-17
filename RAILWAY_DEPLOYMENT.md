# Railway Deployment Guide for Docker-Android

This guide will help you deploy your Docker-Android application to Railway with minimal effort.

## Important: Port Configuration

**Railway only exposes ONE port** (provided via `$PORT` environment variable). We use NGINX to route all services through this single port:

- `/` - Information page
- `/vnc/` - VNC Web Interface (access Android emulator)
- `/adb` - ADB WebSocket proxy
- `/health` - Health check endpoint
- `/logs` - Application logs

## Prerequisites

1. Railway account - Sign up at [railway.app](https://railway.app)
2. Railway CLI installed (optional but recommended)
   ```bash
   npm install -g @railway/cli
   ```

## Quick Deployment Steps

### Option 1: Deploy via GitHub (Recommended)

1. **Push your code to GitHub**
   ```bash
   git add .
   git commit -m "Add Railway deployment configuration"
   git push origin master
   ```

2. **Connect to Railway**
   - Go to [Railway Dashboard](https://railway.app/dashboard)
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Connect your GitHub account and select your repository
   - Railway will automatically detect the Dockerfile

3. **Configure Environment Variables**
   - In Railway dashboard, go to your project
   - Click on "Variables" tab
   - Add the following variables:
     ```
     EMULATOR_DEVICE=Samsung Galaxy S10
     WEB_VNC=true
     EMULATOR_NO_BOOT_ANIM=true
     ```

### Option 2: Deploy via Railway CLI

1. **Login to Railway**
   ```bash
   railway login
   ```

2. **Initialize Railway project**
   ```bash
   railway init
   ```

3. **Deploy**
   ```bash
   railway up
   ```

4. **Set environment variables**
   ```bash
   railway variables set EMULATOR_DEVICE="Samsung Galaxy S10"
   railway variables set WEB_VNC=true
   railway variables set EMULATOR_NO_BOOT_ANIM=true
   ```

## Accessing Your Android Emulator

Once deployed, you can access your Android emulator:

1. **Get your deployment URL**
   - In Railway dashboard, click on your deployment
   - Copy the domain: `docker-android-production.up.railway.app`

2. **Access VNC Web Interface**
   - Open browser: `https://docker-android-production.up.railway.app/vnc/`
   - You'll see the Android emulator interface

3. **Connect via ADB (WebSocket)**
   - Direct ADB connections are NOT supported on Railway
   - Use WebSocket endpoint: `wss://docker-android-production.up.railway.app/adb`
   - Or use tools that support ADB over WebSocket

## Important Notes

### Resource Limits
- Railway has memory and CPU limits on free tier
- Android emulator requires significant resources
- Consider upgrading to a paid plan for better performance

### Performance Optimization
The deployment is configured with:
- GPU software rendering for better cloud performance
- No boot animation to speed up startup
- No audio to reduce resource usage

### Security
- Consider setting a VNC password in production:
  ```bash
  railway variables set VNC_PASSWORD=your_secure_password
  ```

### Troubleshooting

1. **Emulator not starting?**
   - Check Railway logs: `railway logs`
   - Increase health check timeout in railway.json

2. **Connection refused?**
   - Ensure ports 6080 and 5555 are exposed
   - Check Railway's port configuration

3. **Performance issues?**
   - Upgrade Railway plan for more resources
   - Try different emulator device profiles
   - Adjust EMULATOR_ADDITIONAL_ARGS

## Useful Commands

```bash
# View logs
railway logs

# Restart deployment
railway restart

# Update deployment
git push origin master  # Railway auto-deploys

# Check deployment status
railway status
```

## Support

For issues specific to:
- Docker-Android: Check the [GitHub repository](https://github.com/budtmo/docker-android)
- Railway deployment: Visit [Railway documentation](https://docs.railway.app)

Happy deployment! 🚀