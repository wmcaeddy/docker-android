FROM budtmo/docker-android:emulator_11.0

ENV EMULATOR_DEVICE="Samsung Galaxy S10" \
    WEB_VNC=true \
    EMULATOR_NO_BOOT_ANIM=true \
    EMULATOR_ADDITIONAL_ARGS="-gpu swiftshader_indirect -no-audio -no-boot-anim"

USER root

# Install nginx and supervisor for port routing
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    gettext-base \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY railway-start.sh /railway-start.sh
RUN chmod +x /railway-start.sh

# Create necessary directories and fix permissions
RUN mkdir -p /var/log/nginx /var/cache/nginx /var/run /tmp/nginx /tmp/supervisor \
    && chown -R 1300:1301 /var/log/nginx /var/cache/nginx /var/run /etc/nginx /tmp/nginx /tmp/supervisor \
    && chmod -R 755 /tmp/nginx /tmp/supervisor

USER 1300:1301

# Railway will set PORT env variable
EXPOSE ${PORT:-8080}

HEALTHCHECK --interval=30s --timeout=30s --start-period=300s --retries=3 \
  CMD curl -f http://localhost:${PORT:-8080}/health || exit 1

CMD ["/railway-start.sh"]