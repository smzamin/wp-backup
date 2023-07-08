#!/bin/bash

# Assign values to parameters that will be used in Script
DATE="$(date +%Y-%m-%d)"
BACKUP_DIR=/var/backup
SERVER_HOSTNAME=""
NODE=
REMOTE=""

# Create fresh backup directory
mkdir -p "$BACKUP_DIR/$DATE"

echo "Starting BACKUP Creation and Upload to Selected Storage"
echo $DATE
start=$SECONDS
# ls -1 /var/www/ -Ihtml -I22222 | while read user; do
    webinoly -backup=local -export -destination=$BACKUP_DIR/$DATE
    wait
    echo $BACKUP_DIR/$DATE
    echo $REMOTE/$SERVER_HOSTNAME/$DATE
    rclone copy --progress $BACKUP_DIR/$DATE $REMOTE/$SERVER_HOSTNAME/$DATE
    wait
    rm -f $BACKUP_DIR/*
    wait
    rclone delete $REMOTE/$SERVER_HOSTNAME --min-age 30d
    wait
# done
echo "Backup Creation and Upload to Selected Storage Finished"
duration=$((SECONDS - start))
echo "Total Time Taken $duration Seconds"

# Remove backup directory
rm -rf $BACKUP_DIR/$DATE

exit
