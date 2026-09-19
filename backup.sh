#!/bin/sh

THROTTLE="--transfers 2 --checkers 2 --bwlimit 15M"

#Bitwarden
rclone sync -v --stats-one-line $THROTTLE Local:/data/bitwarden_rs-local-backup/backups Nextcloud:/Kevin/Backup/Bitwarden >> /proc/1/fd/1 2>&1

#Home Assistant
rclone sync -v --stats-one-line $THROTTLE Local:/data/homeassistant/backups Nextcloud:/Kevin/Backup/Home_Assistant >> /proc/1/fd/1 2>&1

#Nextcloud
#rclone move -v --stats-one-line --bwlimit=800k:off Local:/data/nextcloud/backups Nextcloud:/Nextcloud >> /proc/1/fd/1 2>&1

rclone move -v --stats-one-line --webdav-nextcloud-chunk-size 100M $THROTTLE Local:/data/nextcloud/backups Nextcloud:/Kevin/Backup/Nextcloud >> /proc/1/fd/1 2>&1