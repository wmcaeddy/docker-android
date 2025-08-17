#!/bin/bash

export PORT=${PORT:-8080}
echo "Starting Genymotion Cloud Android on Railway with PORT=$PORT"

# You need to set these in Railway environment variables
echo "GENYMOTION_CLOUD_EMAIL: $GENYMOTION_CLOUD_EMAIL"
echo "GENYMOTION_CLOUD_PASSWORD: [hidden]"
echo "GENYMOTION_CLOUD_DEVICE_ID: $GENYMOTION_CLOUD_DEVICE_ID"

# Generate nginx config
sed "s/\${PORT}/$PORT/g" /etc/nginx/nginx.conf.template > /tmp/nginx.conf

# Start nginx
/usr/sbin/nginx -c /tmp/nginx.conf -g "daemon off;" &
NGINX_PID=$!

# Start Genymotion connection
cd /root/docker-android
python3 ./cli/src/app.py \
    --genymotion_saas \
    --genymotion_saas_email "$GENYMOTION_CLOUD_EMAIL" \
    --genymotion_saas_password "$GENYMOTION_CLOUD_PASSWORD" \
    --genymotion_saas_device_id "$GENYMOTION_CLOUD_DEVICE_ID"

wait $NGINX_PID