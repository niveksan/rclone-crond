#!/bin/sh

THROTTLE="--transfers 2 --checkers 2 --bwlimit 15M"

#Bitwarden
rclone sync -v --stats-one-line $THROTTLE Local:/data/bitwarden_rs-local-backup/backups Nextcloud:/Bitwarden >> /proc/1/fd/1 2>&1

#Home Assistant
rclone sync -v --stats-one-line $THROTTLE Local:/data/homeassistant/backups Nextcloud:/Home_Assistant >> /proc/1/fd/1 2>&1

#Nextcloud
#rclone move -v --stats-one-line --bwlimit=800k:off Local:/data/nextcloud/backups Nextcloud:/Nextcloud >> /proc/1/fd/1 2>&1
#ohne Limit
rclone move -v --stats-one-line $THROTTLE Local:/data/nextcloud/backups Nextcloud:/Nextcloud >> /proc/1/fd/1 2>&1