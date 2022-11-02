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

# Initialize Log File
echo "Backup Started at: " $(date) > $LOG_PWD/backup.log

if ( df | grep "$BACKUP_PWD" &> /dev/null); then
    
    echo -e "\n\n----------Start Backup----------\n" >> $LOG_PWD/backup.log
    # Stop contaienrs
    RUNNING_CONTAINER="$(docker ps -q)"
    
    docker container stop $RUNNING_CONTAINER

    # on monday remove timestamp.dat so that the next Backup is a Full Backup
    if [ $(date +%u) = 1 ]; then
        rm /mnt/backup/share/timestamp.dat &>> $LOG_PWD/backup.log
    fi
    
    # Backup Data:
    mkdir -p /mnt/backup/share/backup
    tar -cvpzf /mnt/backup/share/backup/$(date +%Y-%m-%d-%H%M%S).tar.gz -g /mnt/backup/share/timestamp.dat /var/homeautomation/ &>> $LOG_PWD/backup.log
    
    
    
    
    # Start caontainers
    docker container start $RUNNING_CONTAINER
    
else
    echo -e "Backup Path not found" >> $LOG_PWD/backup.log
fi

