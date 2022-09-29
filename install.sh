#!/bin/bash
#Script ausführen mit:
#rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh

#
# Inspired BY:
# Grafisches Menu:
# https://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail
# https://linux.die.net/man/1/whiptail
#
#
#
#
#
#
#
#
#

### Variables

LOG_PWD = /var/homeautomation/script/log


### Functions:

# Function for aborting Script.
exit_script () {
    #Remove all Files used by the Script

    # Remove Log Folder
    rm -r $LOG_PWD
    
    
    exit 1
}

update_system () {
    
    mkdir -p $LOG_PWD
    
    {
        
        echo "\n----------Update System----------\n" >> $LOG_PWD/update.log
        apt-get update  -y -q >> $LOG_PWD/update.log
        echo 20
        
        echo "\n----------Upgrade System----------\n" >> $LOG_PWD/update.log
        apt-get upgrade -y -q >> $LOG_PWD/update.log
        echo 60
        
        echo "\n----------Cleanup System----------\n" >> $LOG_PWD/update.log
        apt-get autoremove -y -q >> $LOG_PWD/update.log
        apt-get clean -y -q >> $LOG_PWD/update.log
        echo 100
        
        sleep 0.5
        
    } | whiptail --gauge "Install Updates..." 6 50 0
    
}




### Script


ARCH=$(uname -m)
echo Die Architektur ist: $ARCH

if [[ $ARCH == "aarch64" ]]
then
    echo Prüfung bestanden!
else
    echo Prüfung fehlgeschlagen!
fi


update_system



rm /tmp/installScript -r &> /dev/null
mkdir /tmp/installScript
cd /tmp/installScript

pwd
ls -lisa




DIALOG_RESULT=result


if (whiptail --title "Install Docker" --yesno "Docker is not installed yet. Do you want to install Docker now?" --yes-button "Install" --no-button "Exit" 8 78); then
    echo "User selected Yes, exit status was $?."
else
    echo "Install of Docker aborted"
    exit_script
fi

echo Test: $?
echo $DIALOG_RESULT




# install docker

apt install docker.io docker-compose


