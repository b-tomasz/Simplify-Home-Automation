#!/bin/bash
#

#
# Inspired BY:
# rsync:
# https://linux.die.net/man/1/tar
# https://www.ionos.com/digitalguide/server/tools/tar-backup-how-to-create-an-archive-with-linux/
#


LOG_PWD=/var/homeautomation/script/log
BACKUP_PWD=/mnt/backup/share

mount -a
sleep 2

if ( df | grep "$BACKUP_PWD" &> /dev/null); then
    
    echo -e "\n\n----------Start Backup----------\n" >> $LOG_PWD/backup.log
    # Stop contaienrs
    RUNNING_CONTAINER="$(docker ps -q)"
    
    docker container stop $RUNNING_CONTAINER
    
    # Backup Data:
    tar -cvpzf /mnt/backup/share/level0.tar.gz -g /mnt/backup/share/timestamp.dat /var/homeautomation/
    
    
    
    
    # Start caontainers
    docker container start $RUNNING_CONTAINER
    
else
    echo -e "Backup Path not found" >> $LOG_PWD/backup.log
fi

WORKSPACE_NAME
