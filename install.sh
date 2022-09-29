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

$SCRIPT_PWD = $(pwd)
$SCRIPT_NAME = install.sh
$LOG_PWD = /var/homeautomation/script/log
$WORKING_PWD = /var/homeautomation/script


### Functions:

# Function for aborting Script.
exit_script () {
    #Remove all Files used by the Script
    
    # Remove Log Folder
    rm -r $LOG_PWD
    
    
    
    
    
    # Remove the install Script
    rm $SCRIPT_PWD/$SCRIPT_NAME
    echo finish!!
    
    exit 1
}

# Update the Systen
update_system () {
    
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

# Install Docker
check_docker_installation () {
    
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
    
    
}




### Script


ARCH=$(uname -m)
echo The Architecture is: $ARCH

if [[ $ARCH == "aarch64" ]]
then
    echo Prüfung bestanden!
else
    echo Prüfung fehlgeschlagen!
fi

#create Script/Log Folder and change to script Folder
mkdir -p $LOG_PWD
cd $WORKING_PWD

#Update the System
update_system

# Install Docker
# check_docker_installation










# Finished all without Error
echo "\n\n\nScript finished Succesfuly"
exit_script