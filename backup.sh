#!/bin/bash
#

#
# Inspired BY:
# rsync:
# https://linux.die.net/man/1/rsync
# https://jumpcloud.com/blog/how-to-backup-linux-system-rsync
#


LOG_PWD=/var/homeautomation/script/log
BACKUP_PWD=/mnt/backup/share

if ( df | grep "$BACKUP_PWD" &> /dev/null); then
    
    echo -e "\n\n----------Start Backup----------\n" >> $LOG_PWD/backup.log
    # Stop contaienrs
    RUNNING_CONTAINER="$(docker ps -q)"
    
    docker container stop $RUNNING_CONTAINER
    
    # Backup Data:
    rsync -aAXv /var/homeautomation/ –-delete /mnt/backup/share
    
    
    
    
    # Start caontainers
    docker container stop $RUNNING_CONTAINER
    
else
    echo -e "Backup Path not found" >> $LOG_PWD/backup.log
fi