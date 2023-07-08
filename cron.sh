#!/bin/bash

# Prepare cronjob

# https://crontab.guru/#0_*/12_*_*_*, Use this website to modify the time, right now it's config to run every 12 hours.

CRON_TIME="0 */12 * * *"
CRON_CMD="bash /var/wp-backup/backup.sh >> /var/wp-backup/backup.log 2>&1"
CRON_JOB="$CRON_TIME $CRON_CMD"

# Backup Current cronjobs to file

crontab -l >> /root/cron.jobs.list

# Add cron rule in crontab without any duplicate

( crontab -l | grep -v -F "$CRON_CMD" ; echo "$CRON_JOB" ) | crontab -
