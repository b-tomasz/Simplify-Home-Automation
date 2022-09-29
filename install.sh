#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh

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

# Create Script/Log Folder
mkdir -p /var/homeautomation/script/log
cd /var/homeautomation/script

### Variables

$SCRIPT_PWD=/tmp
$SCRIPT_NAME=install.sh
$LOG_PWD=/var/homeautomation/script/log


### Functions:

# Function for aborting Script.
exit_script () {
    #Remove all Files used by the Script
    
    # Remove Log Folder
    rm -r $LOG_PWD
    
    
    
    
    
    # Remove the install Script
    rm $SCRIPT_PWD/$SCRIPT_NAME
    printf finish!!
    
    exit 1
}

# Update the Systen
update_system () {
    
    {
        printf "\n----------Update System----------\n" >> $LOG_PWD/update.log
        apt-get update  -y -q >> $LOG_PWD/update.log
        printf 20
        
        printf "\n----------Upgrade System----------\n" >> $LOG_PWD/update.log
        apt-get upgrade -y -q >> $LOG_PWD/update.log
        printf 60
        
        printf "\n----------Cleanup System----------\n" >> $LOG_PWD/update.log
        apt-get autoremove -y -q >> $LOG_PWD/update.log
        apt-get clean -y -q >> $LOG_PWD/update.log
        printf 100
        
        sleep 0.5
        
    } | whiptail --gauge "Install Updates..." 6 50 0
    
}

# Install Docker
check_docker_installation () {
    
    DIALOG_RESULT=result
    
    
    if (whiptail --title "Install Docker" --yesno "Docker is not installed yet. Do you want to install Docker now?" --yes-button "Install" --no-button "Exit" 8 78); then
        printf "User selected Yes, exit status was $?."
    else
        printf "Install of Docker aborted"
        exit_script
    fi
    
    printf Test: $?
    printf $DIALOG_RESULT
    
    
    # install docker
    
    apt install docker.io docker-compose
    
    
}




### Script


ARCH=$(uname -m)
printf The Architecture is: $ARCH

if [[ $ARCH == "aarch64" ]]
then
    printf Prüfung bestanden!
else
    printf Prüfung fehlgeschlagen!
fi

#Update the System
update_system

# Install Docker
# check_docker_installation










# Finished all without Error
printf "\\n\\n\\nScript finished Succesfuly"
exit_script