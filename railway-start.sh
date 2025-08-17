#!/bin/bash

# Railway provides PORT environment variable
export PORT=${PORT:-3000}
echo "Starting Docker Android on Railway with PORT=$PORT"

# Generate nginx config from template
envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /tmp/nginx.conf

# Create required directories
mkdir -p /tmp/nginx /var/log/supervisor

# Create supervisord config
cat > /tmp/supervisord.conf << EOF
[supervisord]
nodaemon=true
user=androidusr
logfile=/var/log/supervisor/supervisord.log
pidfile=/tmp/supervisord.pid

[program:nginx]
command=/usr/sbin/nginx -c /tmp/nginx.conf -g "daemon off;"
priority=10
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
autorestart=true

[program:emulator]
command=/home/androidusr/docker-android/mixins/scripts/run.sh
priority=20
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
autorestart=true
environment=DISPLAY=":0"

[program:wait_for_boot]
command=/bin/bash -c 'sleep 30 && echo "Emulator boot wait complete"'
priority=30
autorestart=false
startsecs=0
exitcodes=0
EOF

# Start supervisord with our config
exec /usr/bin/supervisord -c /tmp/supervisord.conf