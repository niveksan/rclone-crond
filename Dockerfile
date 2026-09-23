FROM rclone/rclone:1.75.1

# ENV LABEL_MAINTAINER="niveksan" \
#     LABEL_VENDOR="mimalike.de" \
#     LABEL_IMAGE_NAME="niveksan/rclone-cron" \
#     LABEL_DESCRIPTION="Docker rclone/rclone image using crond as default entrypoint." \
#     LABEL_LICENSE="GPL-3.0"

# install bash (for script)
RUN apk add --no-cache \
  bash

# non-root user for the rclone jobs (uid/gid 1000 = kevin on the host).
# busybox crond itself must stay root (it cannot drop privileges as non-root),
# so the cron jobs switch to appuser via su instead.
RUN addgroup -g 1000 appuser && \
    adduser -D -H -u 1000 -G appuser appuser

# copy backup script to crond daily folder
COPY backup.sh /

# copy entrypoint to usr bin
COPY entrypoint.sh /

# give execution permission to scripts
RUN chmod +x /entrypoint.sh && \
    chmod +x /backup.sh

# crond runs as root; the jobs run as appuser (uid=1000) via su.
# The output redirect lives here (root context) - /proc/1/fd/1 is not writable
# by appuser, so the scripts themselves must not redirect.
# NOTE: single RUN with printf - a second "RUN echo ... >" would overwrite
# the first entry (that bug existed before, killing the backup.sh cron).
RUN printf '0 */12 * * * su -s /bin/sh appuser -c /backup.sh >> /proc/1/fd/1 2>&1\n0 * * * * su -s /bin/sh appuser -c /md-sync.sh >> /proc/1/fd/1 2>&1\n' > /etc/crontabs/root

ENTRYPOINT ["/entrypoint.sh"]

# docker build --network=host --no-cache -t rclone-crond:arm .
