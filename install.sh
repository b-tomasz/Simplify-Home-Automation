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
# Functions with Parameters:
# https://www.redhat.com/sysadmin/arguments-options-bash-scripts
#
#
#
#
#

### Exit Codes:

# 0 Finished without error
# 3 Finished without error, Reboot skipped
# 2 User Exited the Script


# Create Script/Config/Log Folder
mkdir -p /var/homeautomation/script/log
mkdir -p /var/homeautomation/script/config
cd /var/homeautomation/script

### Variables

SCRIPT_PWD=/tmp
SCRIPT_NAME=install.sh
LOG_PWD=/var/homeautomation/script/log
CFG_PWD=/var/homeautomation/script/config


### Functions:

# Function for aborting Script.
exit_script () {
    #Remove all Files used by the Script
    
    
    
    
    
    
    # Enable needrestart again
    unset NEEDRESTART_SUSPEND
    
    # Restart Sevices, where needed
    needrestart -r a -q >> $LOG_PWD/install.log
    
    
    # Remove the install Script and Exit
    rm $SCRIPT_PWD/$SCRIPT_NAME
    
    if [ $1 -eq 0 ] ; then
        shutdown -r now
        exit $1
        
    else
        exit $1
    fi
    
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
    
    if (dpkg -s docker.io docker-compose >> $LOG_PWD/install.log); then
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


# check arch
check_arch () {
    
    ARCH=$(uname -m)
    echo "The Architecture is: $ARCH" >> $LOG_PWD/install.log
    
    if [ $ARCH == "aarch64" ]
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


# Chsck if Pi has fixed IP and offer to set an fixed IP
check_ip (){
    
    # Check is interface eth0 is up
    until [ $(cat /sys/class/net/eth0/operstate) == "up" ]; do
        if ( whiptail --title "IP Address" --yesno "Your eth0 interface is not connected.\nPlease connect an Ethernet Cable and reload, or Exit the Script" --yes-button "reload" --no-button "Exit" 8 78); then
            sleep 2
        else
            # Exit Script
            echo "eth0 is not connected" >> $LOG_PWD/install.log
            exit_script 2
        fi
    done
    
    # Check if the Pi has an Fixed IP
    if (cat /etc/dhcpcd.conf | grep -Pzo 'interface eth0\nstatic ip_address')
    then
        whiptail --title "IP Address" --msgbox "You allready have a fixed IP on eth0" --ok-button "Continue" 8 78
        return
    else
        
        # Ask the User to enter an Fixed IP.
        FIXED_IP=$(whiptail --title "IP Address" --inputbox "Which IP you want to set as Fixed IP for your Raspberry Pi?" 8 78 3>&1 1>&2 2>&3)
        if [ $? = 0 ]; then
            echo "Fixed IP Set to $FIXED_IP" >> $LOG_PWD/install.log
        else
            echo "No Fixed IP was set for eth0" >> $LOG_PWD/install.log
            exit_script 2
        fi
        FIXED_IP_GW=$(whiptail --title "IP Address" --inputbox "Enter the IP from the Router" 8 78 3>&1 1>&2 2>&3)
        if [ $? = 0 ]; then
            echo "Gateway Set to $FIXED_IP_GW" >> $LOG_PWD/install.log
        else
            echo "No Fixed IP was set for eth0" >> $LOG_PWD/install.log
            exit_script 2
        fi
        
        
        # Different Solution with Patch instead of sed:
        # https://man7.org/linux/man-pages/man1/patch.1.html
        # https://www.thegeekstuff.com/2014/12/patch-command-examples/
        
        
        # Write Patch File to Script Folder
		cat > $CFG_PWD/dhcpcd.conf.patch << EOT
--- dhcpcd.conf 2022-07-25 17:48:05.000000000 +0200
+++ dhcpcd.conf.2       2022-10-02 12:07:36.564904885 +0200
@@ -41,10 +41,10 @@
 slaac private

 # Example static IP configuration:
-#interface eth0
-#static ip_address=192.168.0.10/24
+interface eth0
+static ip_address=$FIXED_IP/24
 #static ip6_address=fd51:42f8:caae:d92e::ff/64
-#static routers=192.168.0.1
+static routers=$FIXED_IP_GW
 #static domain_name_servers=192.168.0.1 8.8.8.8 fd51:42f8:caae:d92e::1

 # It is possible to fall back to a static IP if DHCP fails:
EOT
        
        
        
        patch -d /etc -b < $CFG_PWD/dhcpcd.conf.patch
        
        
        
    fi
    
    
}

# Select Tools to install
select_for_installation () {
    whiptail --title "Install Tools" --checklist \
    "Which Tools do you want to Install.\nUse SPACE to select/unselect a Tool." 20 78 4 \
    "Portainer" "Manage Docker Container with GUI" ON \
    "Pihole" "DNS filter for Ads and Tracking" ON \
    "VPN" "Secure Acces to your network from Everywhere" ON \
    "Unifi Controller" "Managing Unifi Devices in your Network" OFF 2> $CFG_PWD/tools_to_install
    
    if [ $? -eq 0 ] ; then
        echo "User selected:" >> $LOG_PWD/install.log
        cat $CFG_PWD/tools_to_install >> $LOG_PWD/install.log
        
    else
        echo "User Canceled at Tool selection" >> $LOG_PWD/install.log
        exit_script 2
    fi
}

# Install Portainer
install_container () {
    CONTAINER_NAME=$1
    printf "\n\n----------Install $CONTAINER_NAME----------\n" >> $LOG_PWD/install.log
    cd $SCRIPT_PWD
    rm install-$CONTAINER_NAME.sh &> /dev/null
    wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_NAME/install-$CONTAINER_NAME.sh &> /dev/null
    bash install-$CONTAINER_NAME.sh >> $LOG_PWD/install.log
}

# Uninstall Portainer
uninstall_container () {
    CONTAINER_NAME=$1
    printf "\n\n----------Uninstall $CONTAINER_NAME----------\n" >> $LOG_PWD/install.log
    cd $SCRIPT_PWD
    rm install-$CONTAINER_NAME.sh &> /dev/null
    wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_NAME/install-$CONTAINER_NAME.sh &> /dev/null
    if (whiptail --title "Uninstall $CONTAINER_NAME" --yesno "Do you want to keep your Settings of $CONTAINER_NAME?" --yes-button "Keep Settings" --no-button "Delete" 8 78); then
        bash install-$CONTAINER_NAME.sh -u >> $LOG_PWD/install.log
    else
        bash install-$CONTAINER_NAME.sh -ur >> $LOG_PWD/install.log
    fi
}


# Install Portainer
install_portainer () {
    printf "\n\n----------Install Portainer----------\n" >> $LOG_PWD/install.log
    cd $SCRIPT_PWD
    rm install-portainer.sh &> /dev/null
    wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/portainer/install-portainer.sh &> /dev/null
    bash install-portainer.sh
}

# Uninstall Portainer
install_portainer () {
    printf "\n\n----------Uninstall Portainer----------\n" >> $LOG_PWD/install.log
    cd $SCRIPT_PWD
    rm install-portainer.sh &> /dev/null
    wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/portainer/install-portainer.sh &> /dev/null
    bash install-portainer.sh
}


# Install Pihole
install_pihole () {
    printf "\n\n----------Install Pihole----------\n" >> $LOG_PWD/install.log
    cd $SCRIPT_PWD
    rm install-pihole.sh &> /dev/null
    wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/pihole/install-pihole.sh &> /dev/null
    bash install-pihole.sh
}


# Install Portainer
install_vpn () {
    printf "\n\n----------Install VPN----------\n" >> $LOG_PWD/install.log
    cd $SCRIPT_PWD
    rm install-vpn.sh &> /dev/null
    wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/vpn/install-vpn.sh &> /dev/null
    bash install-vpn.sh
}

# Update the System
update () {
    # Disable needrestart during Script
    export NEEDRESTART_SUSPEND=1
    
    #Update the System
    echo "Start Update" >> $LOG_PWD/install.log
    update_locale
    update_system
    
}

# Install Tools
install () {
    # Disable needrestart during Script
    export NEEDRESTART_SUSPEND=1
    
    # Check Architecture
    check_arch
    
    # Chsck if Pi has fixed IP and offer to set an fixed IP
    check_ip
    
    # Install Docker
    check_docker_installation
    
    # Select Tools to install
    select_for_installation
    
    # Install Portainer if selected
    if (grep "Portainer" $CFG_PWD/tools_to_install  1> /dev/null);then
        install_container portainer
    fi
    
    # Install Pihole if selected
    if (grep "Pihole" $CFG_PWD/tools_to_install  1> /dev/null);then
        install_container pihole
    fi
    
    # Install VPN if selected
    if (grep "VPN" $CFG_PWD/tools_to_install  1> /dev/null);then
        install_container vpn
    fi
    
}

# Remove Tools
remove () {
    echo test
}


### Script


# Initialize Log File
echo "Script Started at: " $(date) > $LOG_PWD/install.log

# Chose, what to do:
MENU=$(whiptail --title "Install Script" --menu "What do you want to do?" --nocancel 20 78 4 \
    "Update" "Update the System and the installed tools" \
    "Install" "Install Tools" \
    "Remove" "Remove Tools" \
"Exit" "Leave this Script" 3>&1 1>&2 2>&3)

echo $Menu

if [[$Menu -eq "Update"]] ;then
    echo update
    elif [[$MENU -eq "Install"]] ;then

    echo isntall
fi















# Finished all without Error
if ( whiptail --title "Reboot" --yesno "The Script finished succesfuly. Do you want to restart your Raspberry Pi?\nWarning: If you set a new Fixed IP, then a reboot is required." --yes-button "Reboot" --no-button "Exit" 8 78); then
    exit_script 0
else
    # Exit Script
    echo "Exited, without reboot" >> $LOG_PWD/install.log
    exit_script 3
fi
