#!/bin/bash

# Assign values to parameters that will be used in Script
DATE="$(date +%Y-%m-%d)"
BACKUP_DIR=/var/backup
SERVER_HOSTNAME=wp-backup.com
NODE=swift

# Create fresh backup directory
mkdir -p "$BACKUP_DIR/$DATE"

echo "Starting BACKUP Creation and Upload to Selected Storage"
echo $DATE
start=$SECONDS
ls -1 /var/www/ -Ihtml -I22222 | while read user; do
    cd /var/www/$user
    wp db export --allow-root --path=/var/www/$user/htdocs/
    wait
    tar -cf $BACKUP_DIR/$DATE/$user.tar -X /var/wp-backup/exclude.txt .
    wait
    rm -f /var/www/$user/*.sql
    wait
    rclone copy $BACKUP_DIR/$DATE remote:backup/$SERVER_HOSTNAME/$DATE
    wait
    rm -f $BACKUP_DIR/$DATE/*
    wait
done
echo "Backup Creation and Upload to Selected Storage Finished"
duration=$((SECONDS - start))
echo "Total Time Taken $duration Seconds"

# Remove backup directory
rm -rf $BACKUP_DIR/$DATE

exit
