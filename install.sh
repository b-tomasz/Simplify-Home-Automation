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

SCRIPT_PWD=/tmp
SCRIPT_NAME=install.sh
LOG_PWD=/var/homeautomation/script/log


### Functions:

# Function for aborting Script.
exit_script () {
    #Remove all Files used by the Script
    
    
    
    
    
    
    # Enable needrestart again
    unset NEEDRESTART_SUSPEND
    
    # Restart Sevices, where needed
    needrestart -r a  >> $LOG_PWD/install.log
    
    
    # Remove the install Script and Exit
    rm $SCRIPT_PWD/$SCRIPT_NAME
    exit $1
}

# Update the Systen
update_system () {
    if (whiptail --title "Update System" --yesno "Do you want to Update Your System?" --yes-button "Update" --no-button "Skip" 8 78); then
        
        echo "Update Started at: " $(date) > $LOG_PWD/update.log
        
        {
            printf "\n\n----------Update Packages----------\n" >> $LOG_PWD/update.log
            apt-get update -y -q >> $LOG_PWD/update.log
            
            echo -e "XXX\n20\nUpgrade System...\nXXX"
            printf "\n\n----------Upgrade System----------\n" >> $LOG_PWD/update.log
            apt-get upgrade -y -q >> $LOG_PWD/update.log
            
            echo -e "XXX\n60\nCleanup System...\nXXX"
            printf "\n\n----------Cleanup System----------\n" >> $LOG_PWD/update.log
            apt-get autoremove -y -q >> $LOG_PWD/update.log
            
            echo -e "XXX\n100\nFinished...\nXXX"
            sleep 0.5
            
        } | whiptail --gauge "Update Packages..." 6 50 0
        
    else
        echo "System update Skipped by User" >> $LOG_PWD/install.log
        return
    fi
    
}

# Install Docker
check_docker_installation () {
    
    # Check if Docker is installed completly
    
    if (dpkg -s docker.io docker-compose); then
        # Docker is already installed
        
        echo "Docker is already installed" >> $LOG_PWD/install.log
        whiptail --title "Docker Installation" --msgbox "Docker ist already installed on this System" --ok-button "Continue" 8 78
        
    else
        
        if (whiptail --title "Install Docker" --yesno "Docker is not installed yet. Do you want to install Docker now?" --yes-button "Install" --no-button "Exit" 8 78); then
            # Install Docker
            
            # Todo: needrestart can interrupt the install process. Possible solution: https://github.com/liske/needrestart/issues/71
            
            {
                printf "\n\n----------Update Packages----------\n" >> $LOG_PWD/install.log
                apt-get update  -y -q >> $LOG_PWD/install.log
                
                echo -e "XXX\n20\nInstall docker.io...\nXXX"
                printf "\n\n----------Install docker.io----------\n" >> $LOG_PWD/install.log
                apt-get install docker.io -y -q >> $LOG_PWD/install.log
                
                echo -e "XXX\n50\nInstall docker-compose...\nXXX"
                printf "\n\n----------Install docker-compose----------\n" >> $LOG_PWD/install.log
                apt-get install docker-compose -y -q >> $LOG_PWD/install.log
                
                echo -e "XXX\n80\nCleanup System...\nXXX"
                printf "\n\n----------Cleanup System----------\n" >> $LOG_PWD/install.log
                apt-get autoremove -y -q >> $LOG_PWD/install.log
                
                echo -e "XXX\n100\nFinished...\nXXX"
                sleep 0.5
                
            } | whiptail --gauge "Update Packages..." 6 50 0
            
        else
            # Exit Script
            echo "Install of Docker aborted by the User" >> $LOG_PWD/install.log
            exit_script 2
        fi
        
    fi
    
    
    
}

# update Locale
update_locale () {
    echo "#  File generated by update-locale
    LANG=en_GB.UTF-8
    LC_CTYPE=en_GB.UTF-8
    LC_MESSAGES=en_GB.UTF-8
    LC_ALL=en_GB.UTF-8" > /etc/default/locale
    export LC_CTYPE LC_MESSAGES LC_ALL
    . /etc/default/locale
}

# Set needrestart to automaticali to prevent Dialoges iterrupting Script
disable_needrestart (){
    
    
    
    
    
    #  echo "# Restart services (l)ist only, (i)nteractive or (a)utomatically.
    # $nrconf{restart} = 'a';
    # # Disable hints on pending kernel upgrades.
    #$nrconf{kernelhints} = 0;" > /etc/needrestart/conf.d/disable.conf
    
}


# check arch
check_arch () {
    
    ARCH=$(uname -m)
    echo "The Architecture is: $ARCH" >> $LOG_PWD/install.log
    
    if [[ $ARCH == "aarch64" ]]
    then
        whiptail --title "System Architecture" --msgbox "Your Architecture is $ARCH" --ok-button "Continue" 8 78
    else
        if (whiptail --title "System Architecture" --yesno "Your Architecture is $ARCH\n Your Platform is not Supported\n Ignor this at your own risk" --yes-button "Ignore" --no-button "Exit" 8 78); then
            return
        else
            # Exit Script
            echo "Installscript aborted by the User" >> $LOG_PWD/install.log
            exit_script 2
        fi
    fi
}

### Script


# Initialize Log File
echo "Script Started at: " $(date) > $LOG_PWD/install.log

# Disable needrestart during Script
export NEEDRESTART_SUSPEND=1

# Check Architecture
check_arch

#Update the System
echo "Start Update" >> $LOG_PWD/install.log
update_locale
update_system

# Install Docker
check_docker_installation










# Finished all without Error
printf "\n\n\nScript finished Succesfuly\n\n"
exit_script 0