#!/bin/sh

THROTTLE="--transfers 2 --checkers 2 --bwlimit 15M"

# Die Ausgabeumleitung (>> /proc/1/fd/1 2>&1) erfolgt in der Crontab im Root-Kontext,
# da /proc/1/fd/1 als appuser (uid=1000) nicht beschreibbar ist.

#Bitwarden
rclone sync -v --stats-one-line $THROTTLE Local:/data/bitwarden_rs-local-backup/backups Nextcloud:/Kevin/Backup/Bitwarden

#Home Assistant
rclone sync -v --stats-one-line $THROTTLE Local:/data/homeassistant/backups Nextcloud:/Kevin/Backup/Home_Assistant

#Nextcloud
rclone move -v --stats-one-line --webdav-nextcloud-chunk-size 100M $THROTTLE Local:/data/nextcloud/backups Nextcloud:/Kevin/Backup/Nextcloud
