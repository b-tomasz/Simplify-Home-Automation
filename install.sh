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
# Script kontrolle:
# https://www.shellcheck.net/
#
#

### Exit Codes:

# 0 Finished without error
# 3 Finished without error, Reboot skipped
# 2 User Exited the Script
# 4 Script was startet as non root

# Check if Script was started as Root
if [ ! $(whoami) = root ]; then
    whiptail --title "No Root" --msgbox "The Script needs to be Run as root.\nPlease exit the Script, then enter \"sudo su\" and rerun to this Script." --ok-button "Exit" 10 80
    exit 4
fi

# Create Script/Config/Log Folder
mkdir -p /var/homeautomation/script/log
mkdir -p /var/homeautomation/script/config
cd /var/homeautomation/script

### Variables
SCRIPT_PWD=/tmp
SCRIPT_NAME=install.sh
LOG_PWD=/var/homeautomation/script/log
CFG_PWD=/var/homeautomation/script/config

# ContainerIDs
declare -A CONTAINER_IDS
CONTAINER_IDS[nginx]=01
CONTAINER_IDS[portainer]=02
CONTAINER_IDS[pihole]=03
CONTAINER_IDS[vpn]=04
CONTAINER_IDS[bitwarden]=05
CONTAINER_IDS[nodered]=06
CONTAINER_IDS[database]=07
CONTAINER_IDS[grafana]=08
CONTAINER_IDS[unifi]=09

# Decription for each Tool to use in the Selection
declare -A TOOL_DESCRIPTION
TOOL_DESCRIPTION[nginx]="Reverse Proxy with Certbot for SSL Certs"
TOOL_DESCRIPTION[portainer]="Manage Docker Container in a Webinterface"
TOOL_DESCRIPTION[pihole]="DNS filter for Ads and Tracking"
TOOL_DESCRIPTION[vpn]="Secure Access to your network from Everywhere"
TOOL_DESCRIPTION[bitwarden]="Password Safe"
TOOL_DESCRIPTION[nodered]="Manage and connect homautomation"
TOOL_DESCRIPTION[database]="Database to store Data"
TOOL_DESCRIPTION[grafana]="Visualize Data in a nice Gaph"
TOOL_DESCRIPTION[unifi]="Unifi Controller, for Managing Unifi Devices"

### Functions:

# Function for aborting Script.
exit_script () {
    #Remove all Files used by the Script
    
    # Enable needrestart again
    unset NEEDRESTART_SUSPEND
    
    # Restart Sevices, where needed
    needrestart -r a -q &>> $LOG_PWD/script.log
    
    # Remove the install Script and Exit
    rm $SCRIPT_PWD/$SCRIPT_NAME
    
    exit $1
    
}

# Update the Systen
update_system () {
    if (whiptail --title "Update System" --yesno "Do you want to Update Your System?" --yes-button "Update" --no-button "Skip" 8 80); then
        
        echo "Update Started at: " $(date) > $LOG_PWD/update.log
        
        {
            echo -e "\n\n----------Update Packages----------\n" >> $LOG_PWD/update.log
            apt-get update -y -q >> $LOG_PWD/update.log
            
            echo -e "XXX\n20\nUpgrade System...\nXXX"
            echo -e "\n\n----------Upgrade System----------\n" >> $LOG_PWD/update.log
            apt-get upgrade -y -q >> $LOG_PWD/update.log
            
            echo -e "XXX\n60\nCleanup System...\nXXX"
            echo -e "\n\n----------Cleanup System----------\n" >> $LOG_PWD/update.log
            apt-get autoremove -y -q >> $LOG_PWD/update.log
            
            echo -e "XXX\n100\nFinished...\nXXX"
            sleep 0.5
            
        } | whiptail --gauge "Update packages..." 6 80 0
        
    else
        echo "System update skipped by user" >> $LOG_PWD/script.log
        return
    fi
    
}

# Install Docker
check_docker_installation () {
    
    # Check if Docker is installed completly
    
    if (dpkg -s docker.io docker-compose &>> /dev/null); then
        # Docker is already installed
        
        echo "Docker is already installed" >> $LOG_PWD/script.log
        whiptail --title "Docker Installation" --msgbox "Docker ist already installed on this System" --ok-button "Continue" 8 80
        
    else
        echo "Docker is not installed" >> $LOG_PWD/script.log
        if (whiptail --title "Install Docker" --yesno "Docker is not installed yet. Do you want to install Docker now?" --yes-button "Install" --no-button "Exit" 8 80); then
            # Install Docker
            
            # Todo: needrestart can interrupt the install process. Possible solution: https://github.com/liske/needrestart/issues/71
            
            {
                echo -e "\n\n----------Update Packages----------\n" >> $LOG_PWD/script.log
                apt-get update  -y -q >> $LOG_PWD/script.log
                
                echo -e "XXX\n20\nInstall docker.io...\nXXX"
                echo -e "\n\n----------Install docker.io----------\n" >> $LOG_PWD/script.log
                apt-get install docker.io -y -q >> $LOG_PWD/script.log
                
                echo -e "XXX\n50\nInstall docker-compose...\nXXX"
                echo -e "\n\n----------Install docker-compose----------\n" >> $LOG_PWD/script.log
                apt-get install docker-compose -y -q >> $LOG_PWD/script.log
                
                echo -e "XXX\n80\nCleanup System...\nXXX"
                echo -e "\n\n----------Cleanup System----------\n" >> $LOG_PWD/script.log
                apt-get autoremove -y -q >> $LOG_PWD/script.log
                
                echo -e "XXX\n100\nFinished...\nXXX"
                sleep 0.5
                
            } | whiptail --gauge "Update Packages..." 6 80 0
            
        else
            # Exit Script
            echo "Install of Docker aborted by the User" >> $LOG_PWD/script.log
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
    echo "The Architecture is: $ARCH" >> $LOG_PWD/script.log
    
    if [ $ARCH == "aarch64" ]
    then
        whiptail --title "System Architecture" --msgbox "Your Architecture is $ARCH" --ok-button "Continue" 8 80
    else
        if (whiptail --title "System Architecture" --yesno "Your Architecture is $ARCH\nYour Platform is not Supported\nIgnor this at your own risk" --yes-button "Ignore" --no-button "Exit" 10 80); then
            return
        else
            # Exit Script
            echo "Installscript aborted by the User" >> $LOG_PWD/script.log
            exit_script 2
        fi
    fi
}

# Chsck if Pi has fixed IP and offer to set an fixed IP
check_ip (){
    
    # Check is interface eth0 is up
    until [ $(cat /sys/class/net/eth0/operstate) == "up" ]; do
        if ( whiptail --title "IP-address" --yesno "Your eth0 interface is not connected.\nPlease connect an Ethernet Cable and reload, or Exit the Script" --yes-button "reload" --no-button "Exit" 8 80); then
            sleep 2
        else
            # Exit Script
            echo "eth0 is not connected" >> $LOG_PWD/script.log
            exit_script 2
        fi
    done
    
    # Check if the Pi has an Fixed IP
    if (cat /etc/dhcpcd.conf | grep -Pzo 'interface eth0\nstatic ip_address')
    then
        whiptail --title "IP-address" --msgbox "You allready have a fixed IP on eth0" --ok-button "Continue" 8 80
        return
    else
        
        # Ask the User to enter an Fixed IP.
        while true
        do
            
            if FIXED_IP=$(whiptail --title "IP-address" --inputbox "Which IP you want to set as Fixed IP for your Raspberry Pi?" 8 80 3>&1 1>&2 2>&3); then
                echo "Fixed IP Set to $FIXED_IP" >> $LOG_PWD/script.log
                
                if ( grep -E "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$" <<< "$FIXED_IP" > /dev/null); then
                    break
                else
                    whiptail --title "IP-address" --msgbox "The entered IP is not valid" 8 80
                fi
            else
                echo "No Fixed IP was set for eth0" >> $LOG_PWD/script.log
                exit_script 2
            fi
            
            
        done
        
        
        while true
        do
            
            if FIXED_IP_GW=$(whiptail --title "IP-address" --inputbox "Enter the IP from the Router" 8 80 3>&1 1>&2 2>&3); then
                echo "Gateway Set to $FIXED_IP_GW" >> $LOG_PWD/script.log
                
                if ( grep -E "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$" <<< "$FIXED_IP_GW" > /dev/null); then
                    break
                else
                    whiptail --title "IP-address" --msgbox "The entered IP is not valid" 8 80
                fi
            else
                echo "No Fixed IP was set for eth0" >> $LOG_PWD/script.log
                exit_script 2
            fi
            
            
        done
        
        
        
        
        if (whiptail --title "Domain" --yesno "We reccomend to use an external Domain. The Script can generat a valid SSL Certificate and make the Tools accessible over HTTPS.

If you use an external Domain, it ist necessary, that \"YOUR-DOMAIN.ch\" and \"*.YOUR-DOMAIN.ch\" resolves to your IP and that the Following Ports redirecting to your Raspberry Pi under $FIXED_IP:

HTTP: 80 /tcp
HTTPS: 443 /tcp
VPN: 10000 /udp - Only necessary, if you use the VPN.

These Services are only working with an external Domain: VPN, Bitwarden

Do you haven an external Domain and configured the DNS and Portforwarding?
            " --yes-button "Yes" --no-button "No" 20 80); then
            
            
            # Continue with external Domain
            
            while true
            do
                
                if EXTERNAL_DOMAIN=$(whiptail --title "Domain" --inputbox "Enter your external Domain to use with this Project" 8 80 3>&1 1>&2 2>&3); then
                    echo "Domain Set to $EXTERNAL_DOMAIN" >> $LOG_PWD/script.log
                    
                    if ( grep -E "^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}$" <<< "$EXTERNAL_DOMAIN" > /dev/null); then
                        break
                    else
                        whiptail --title "Domain" --msgbox "The entered Domain is not valid" 8 80
                    fi
                else
                    echo "No Domain was set" >> $LOG_PWD/script.log
                    exit_script 2
                fi
            done
            
            # Continue with E-Mail
            
            while true
            do
                if EMAIL=$(whiptail --title "E-Mail" --inputbox "Enter your E-Mail address to use for Certificate Creation" 8 80 3>&1 1>&2 2>&3); then
                    echo "E-Mail Set to $EMAIL" >> $LOG_PWD/script.log
                    
                    if ( grep -E "^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$" <<< "$EMAIL" > /dev/null); then
                        break
                    else
                        whiptail --title "E-Mail" --msgbox "The entered E-Mail is not valid" 8 80
                    fi
                else
                    echo "No E-Mail was set" >> $LOG_PWD/script.log
                    exit_script 2
                fi
            done
            
            echo -e "FIXED_IP=$FIXED_IP\nFIXED_IP_GW=$FIXED_IP_GW\nNO_EXTERNAL_DOMAIN=false\nEXTERNAL_DOMAIN=$EXTERNAL_DOMAIN\nEMAIL=$EMAIL" > $CFG_PWD/ip.conf
        else
            # Continue without external Domain
            echo -e "FIXED_IP=$FIXED_IP\nFIXED_IP_GW=$FIXED_IP_GW\nEXTERNAL_DOMAIN=example.com\nNO_EXTERNAL_DOMAIN=true" > $CFG_PWD/ip.conf
        fi
        
        # Different Solution with Patch instead of sed:
        # https://man7.org/linux/man-pages/man1/patch.1.html
        # https://www.thegeekstuff.com/2014/12/patch-command-examples/
        
        
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
        
        
        
        # Write Patch File to Script Folder
        if ( whiptail --title "Reboot" --msgbox "After Setting an new IP-address you have to reboot your Raspbery Pi. You have set the following Settings:\nIP: $FIXED_IP\nGateway: $FIXED_IP_GW\nExternal Domain: $EXTERNAL_DOMAIN" --ok-button "Reboot" 11 80); then
            patch -d /etc -b < $CFG_PWD/dhcpcd.conf.patch >> $LOG_PWD/script.log
            echo "System Reboot after setting fixed IP-address" >> $LOG_PWD/script.log
            shutdown -r now
            exit_script 0
        fi
        
    fi
    
    
}

# Select Tools to install
select_for_installation () {
    
    source /var/homeautomation/script/config/ip.conf
    
    SELECTION_ARRAY=()
    for val in ${!TOOL_DESCRIPTION[*]};
    do
        if [ $NO_EXTERNAL_DOMAIN = true ] && ( [[ $val = vpn ]] || [[ $val = bitwarden ]] ); then
            continue
        fi
        if ! grep -s $val $CFG_PWD/installed_tools.txt &> /dev/null && [[ ! $val = nginx ]]
        then
            SELECTION_ARRAY+=($val)
            SELECTION_ARRAY+=("${TOOL_DESCRIPTION[$val]}")
            SELECTION_ARRAY+=(OFF)
        fi
        
    done
    
    if [[ ${#SELECTION_ARRAY[@]} -eq 0 ]]; then
        
        # All Tools already installed
        whiptail --title "Installation" --msgbox "You have already all Tools installed" --ok-button "Exit" 8 80
        
        exit_script 2
        
    else
        
        
        if (whiptail --title "Install Tools" --checklist \
            "Which Tools do you want to Install.\nUse SPACE to select/unselect a Tool.\nNginx as reverse Proxy with Certbot for LetsEncrypt certificates will also get installed, if not already installed." 20 80 $((${#SELECTION_ARRAY[@]} / 3)) \
            "${SELECTION_ARRAY[@]}"  2> $CFG_PWD/tools_to_install.txt) ; then
            
            # Remove the " to use it as Array
            sed -i 's/"//g' $CFG_PWD/tools_to_install.txt
            echo "User selected:" >> $LOG_PWD/script.log
            cat $CFG_PWD/tools_to_install.txt >> $LOG_PWD/script.log
            
        else
            echo "User Canceled at Tool selection" >> $LOG_PWD/script.log
            exit_script 2
        fi
    fi
}

# Select Tools to uninstall
select_for_uninstallation () {
    
    SELECTION_ARRAY=()
    for val in ${!TOOL_DESCRIPTION[*]};
    do
        
        if  grep -s $val $CFG_PWD/installed_tools.txt &> /dev/null;
        then
            
            SELECTION_ARRAY+=($val)
            SELECTION_ARRAY+=("${TOOL_DESCRIPTION[$val]}")
            SELECTION_ARRAY+=(OFF)
        fi
        
    done
    
    if [[ ${#SELECTION_ARRAY[@]} -eq 0 ]]; then
        
        # All Tools already installed
        whiptail --title "Uninstall" --msgbox "No Tools found to uninstall" --ok-button "Continue" 8 80
        
        exit_script 2
        
    else
        
        if (whiptail --title "Remove Tools" --checklist \
            "Which Tools do you want to remove.\nUse SPACE to select/unselect a Tool." 20 80 $((${#SELECTION_ARRAY[@]} / 3)) \
            "${SELECTION_ARRAY[@]}"  2> $CFG_PWD/tools_to_uninstall.txt) ; then
            
            # Remove the " to use it as Array
            sed -i 's/"//g' $CFG_PWD/tools_to_uninstall.txt
            echo "User selected:" >> $LOG_PWD/script.log
            cat $CFG_PWD/tools_to_uninstall.txt >> $LOG_PWD/script.log
            
        else
            echo "User Canceled at Tool for uninstall selection" >> $LOG_PWD/script.log
            exit_script 2
        fi
        
    fi
}

# Install Container
install_container () {
    CONTAINER_NAME=$1
    CONTAINER_PASSWORD=$2
    echo -e "\n\n----------Install $CONTAINER_NAME----------\n" >> $LOG_PWD/script.log
    cd $SCRIPT_PWD
    rm install-$CONTAINER_NAME.sh &> /dev/null
    wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/${CONTAINER_IDS[$CONTAINER_NAME]}-$CONTAINER_NAME/install-$CONTAINER_NAME.sh &> /dev/null
    bash install-$CONTAINER_NAME.sh $CONTAINER_PASSWORD >> $LOG_PWD/script.log
    
}

# Upgrade Container
upgrade_container () {
    CONTAINER_NAME=$1
    echo -e "\n\n----------Upgrade $CONTAINER_NAME----------\n" >> $LOG_PWD/script.log
    cd $SCRIPT_PWD
    rm install-$CONTAINER_NAME.sh &> /dev/null
    wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/${CONTAINER_IDS[$CONTAINER_NAME]}-$CONTAINER_NAME/install-$CONTAINER_NAME.sh &> /dev/null
    bash install-$CONTAINER_NAME.sh -g >> $LOG_PWD/script.log
    
}

# Uninstall Container
uninstall_container () {
    CONTAINER_NAME=$1
    REMOVE_DATA=$2
    echo -e "\n\n----------Uninstall $CONTAINER_NAME----------\n" >> $LOG_PWD/script.log
    cd $SCRIPT_PWD
    rm install-$CONTAINER_NAME.sh &> /dev/null
    wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/${CONTAINER_IDS[$CONTAINER_NAME]}-$CONTAINER_NAME/install-$CONTAINER_NAME.sh &> /dev/null
    if [ $REMOVE_DATA = true ]; then
        # Uninstall Container and remove all Data
        bash install-$CONTAINER_NAME.sh -ur >> $LOG_PWD/script.log
    else
        # Uninstall Container
        bash install-$CONTAINER_NAME.sh -u >> $LOG_PWD/script.log
    fi
}

# Check installed Containers
check_installation (){
    CONTAINER_NAME=$1
    if [[ $CONTAINER_NAME = nginx ]]; then
        CONTAINER_DNS_NAME=localhost
    else
        CONTAINER_DNS_NAME=$CONTAINER_NAME.home
    fi
    
    echo -e "\n\n----------Check install Status of $CONTAINER_NAME----------\n" >> $LOG_PWD/script.log
    
    # Check if the Container is Running
    if [ "$( docker container inspect -f '{{.State.Status}}' $CONTAINER_NAME )" == "running" ]; then
        echo "Container $CONTAINER_NAME is running" >> $LOG_PWD/script.log
    else
        echo "Container $CONTAINER_NAME has failed" >> $LOG_PWD/script.log
        echo -n "$CONTAINER_NAME " >> $CFG_PWD/failed_installations.txt
        return 1
    fi
    
    # Check if the Webinterface is reachable
    
    if (wget -O /dev/null -S --no-check-certificate -q $CONTAINER_DNS_NAME 2>&1 |  grep -E '(HTTP).+(200)'); then
        echo "Webinterface of $CONTAINER_NAME is up" >> $LOG_PWD/script.log
    else
        echo "Webinterface of $CONTAINER_NAME has failed" >> $LOG_PWD/script.log
        echo -n "$CONTAINER_NAME " >> $CFG_PWD/failed_installations.txt
        return 1
    fi
    
    
    
    
    #Todo Check for each Container
    case $CONTAINER_NAME in
        pihole)
            # Check if the Container is Running
            if [ "$( docker container inspect -f '{{.State.Status}}' bind9 )" == "running" ]; then
                echo "Container bind9 is running" >> $LOG_PWD/script.log
            else
                echo "Container bind9 has failed" >> $LOG_PWD/script.log
                echo -n "pihole " >> $CFG_PWD/failed_installations.txt
                return 1
        fi;;
        database)
            # Check if the Container is Running
            if [ "$( docker container inspect -f '{{.State.Status}}' adminer )" == "running" ]; then
                echo "Container adminer is running" >> $LOG_PWD/script.log
            else
                echo "Container adminer has failed" >> $LOG_PWD/script.log
                echo -n "database " >> $CFG_PWD/failed_installations.txt
                return 1
        fi;;
    esac
    
    
    echo -n "$CONTAINER_NAME " >> $CFG_PWD/installed_tools.txt
    
}

# Update the System
update () {
    # Disable needrestart during Script
    export NEEDRESTART_SUSPEND=1
    
    # Check Architecture
    check_arch
    
    # Set Locale
    update_locale
    
    #Update the System
    echo "Start Update" >> $LOG_PWD/script.log
    update_system
    
    # Update Containers
    if [ -f "$CFG_PWD/installed_tools.txt" ]; then
        if (whiptail --title "Update Container" --yesno "Do you want to Update Your Containers?" --yes-button "Update" --no-button "Skip" 8 80); then
            read -a TOOLS < $CFG_PWD/installed_tools.txt
            {
                PROGRESS=0
                CONTAINER_PROGRESS=$(( 100 / ( ${#TOOLS[@]}) ))
                
                # Loop trough TOOLS and Upgrade all installed Tools
                for TOOL in "${TOOLS[@]}"
                do
                    
                    echo -e "XXX\n$PROGRESS\nUpgrade $TOOL...\nXXX"
                    PROGRESS=$(( $PROGRESS + $CONTAINER_PROGRESS ))
                    upgrade_container $TOOL &>> $LOG_PWD/script.log
                    
                done
                
                docker image prune -f
                echo -e "XXX\n100\nFinished...\nXXX"
                sleep 0.5
                
                
            } | whiptail --title "Uninstall" --gauge "Uninstall ..." 6 80 0
        fi
    fi
    
    whiptail --title "Update" --msgbox "Your System is up to date." --ok-button "Continue" 8 80
}

# Install Tools
install () {
    # Disable needrestart during Script
    export NEEDRESTART_SUSPEND=1
    
    update
    
    # Check if Pi has fixed IP and offer to set an fixed IP
    check_ip
    
    # Install Docker
    check_docker_installation
    
    # Select Tools to install
    select_for_installation
    
    read -a TOOLS < $CFG_PWD/tools_to_install.txt
    
    # Ask the User fot the Passwords of the Tools to be installed
    if [[ " ${TOOLS[*]} " =~ "portainer" ]] || [[ " ${TOOLS[*]} " =~ "database" ]] || [[ " ${TOOLS[*]} " =~ "pihole" ]] || [[ " ${TOOLS[*]} " =~ "grafana" ]] || [[ " ${TOOLS[*]} " =~ "vpn" ]]; then
        # ask User for Default Webinterface Passwords
        while true
        do
            PASSWORD=$(whiptail --title "Default Webinterface Passwords" --nocancel --passwordbox "Please Enter a password for Portainer, Pihole, VPN GUI, Grafana and Database:" 8 80  3>&1 1>&2 2>&3)
            if [ $(whiptail --title "Default Webinterface Passwords" --nocancel --passwordbox "Please Confirm your Password:" 8 80  3>&1 1>&2 2>&3) = $PASSWORD ];then
                break
            else
                whiptail --title "Default Webinterface Passwords" --msgbox "The Passwords you entred do not match.\nPlease Try it again." 8 80
            fi
        done
    fi
    
    # Add hostnames to /etc/hosts
    
		cat > $CFG_PWD/hosts.patch << EOT
--- /etc/hosts  2022-10-17 21:16:38.981733164 +0200
+++ /etc/hosts_new      2022-10-17 21:16:29.137905998 +0200
@@ -4,3 +4,23 @@
 ff02::2                ip6-allrouters

 127.0.1.1      $(hostname)
+
+## Entrys for ckeching Webinterface availability
+127.0.0.1      nginx.home
+127.0.0.1      portainer.home
+127.0.0.1      pihole.home
+127.0.0.1      vpn.home
+127.0.0.1      bitwarden.home
+127.0.0.1      nodered.home
+127.0.0.1      database.home
+127.0.0.1      grafana.home
+127.0.0.1      unifi.home
+127.0.0.1      nginx.$EXTERNAL_DOMAIN
+127.0.0.1      portainer.$EXTERNAL_DOMAIN
+127.0.0.1      pihole.$EXTERNAL_DOMAIN
+127.0.0.1      vpn.$EXTERNAL_DOMAIN
+127.0.0.1      bitwarden.$EXTERNAL_DOMAIN
+127.0.0.1      nodered.$EXTERNAL_DOMAIN
+127.0.0.1      database.$EXTERNAL_DOMAIN
+127.0.0.1      grafana.$EXTERNAL_DOMAIN
+127.0.0.1      unifi.$EXTERNAL_DOMAIN
EOT
    
    patch -l -d /etc -b < $CFG_PWD/hosts.patch >> $LOG_PWD/script.log
    
    # Install Containers
    
    {
        PROGRESS=0
        CONTAINER_PROGRESS=$(( 95 / ( (${#TOOLS[@]} + 1) * 2 ) ))
        

        if [ -f "$CFG_PWD/failed_installations.txt" ];then
            rm $CFG_PWD/failed_installations.txt &>> $LOG_PWD/script.log
        fi

        # Install nginx as base for the other Containers
        if ! grep -s $val $CFG_PWD/installed_tools.txt &> /dev/null ; then
            install_container nginx &>> $LOG_PWD/script.log
            sleep 10
        
            PROGRESS=$(( $PROGRESS + $CONTAINER_PROGRESS ))
            echo -e "XXX\n$PROGRESS\nCheck nginx...\nXXX"

        # Check installation of nginx
        check_installation nginx &>> $LOG_PWD/script.log
        else
            PROGRESS=$(( $PROGRESS + $CONTAINER_PROGRESS ))
        fi

        # Loop trough TOOLS and Install all selected Tools
        for TOOL in "${TOOLS[@]}"
        do
            PROGRESS=$(( $PROGRESS + $CONTAINER_PROGRESS ))
            echo -e "XXX\n$PROGRESS\nInstall $TOOL...\nXXX"
            
            case $TOOL in
                portainer)
                install_container $TOOL $PASSWORD &>> $LOG_PWD/script.log;;
                pihole)
                install_container $TOOL $PASSWORD &>> $LOG_PWD/script.log;;
                vpn)
                install_container $TOOL $PASSWORD &>> $LOG_PWD/script.log;;
                database)
                install_container $TOOL $PASSWORD &>> $LOG_PWD/script.log;;
                grafana)
                install_container $TOOL $PASSWORD &>> $LOG_PWD/script.log;;
                *)
                install_container $TOOL &>> $LOG_PWD/script.log;;
            esac
            
        done
        
        # Wait for the Containers to start up
        for (( c=1; c<=10; c++ ))
        do
            echo -e "XXX\n$PROGRESS\nWait for Startup of the Container $(( 10 - $c ))...\nXXX"
            sleep 1
        done
        
        
        # Loop trough TOOLS and Check if the Container was installed Sucessfully
        for TOOL in "${TOOLS[@]}"
        do
            PROGRESS=$(( $PROGRESS + $CONTAINER_PROGRESS ))
            echo -e "XXX\n$PROGRESS\nCheck $TOOL...\nXXX"
            check_installation $TOOL &>> $LOG_PWD/script.log
            sleep 0.5
        done
        
        cat $CFG_PWD/failed_installations.txt >> $LOG_PWD/script.log
        
        # Check faild installation again. Try it 10 times every 10s
        for (( c=1; c<=10; c++ ))
        do
            if [ -f "$CFG_PWD/failed_installations.txt" ]; then
                echo -e "XXX\n95\nCheck failed installation again. Attempt $c of 10...\nXXX"
                echo -e "\n\n----------Check failed installations again. Attempt $c of 10 ----------\n" >> $LOG_PWD/script.log
                
                read -a TOOLS < $CFG_PWD/failed_installations.txt
                echo -e "Failed Installations: ${TOOLS[@]}" >> $LOG_PWD/script.log
                rm $CFG_PWD/failed_installations.txt &>> $LOG_PWD/script.log
                
                if [ ! -z "$TOOLS" ];then
                    for TOOL in "${TOOLS[@]}"
                    do
                        check_installation $TOOL &>> $LOG_PWD/script.log
                    done
                else
                    break
                fi
            else
                break
            fi
            
            for (( i=1; i<=20; i++ ))
            do
                echo -e "XXX\n95\nCheck failed installation again. Attempt $c of 10 Next attempt: $(( 20 - $i ))...\nXXX"
                sleep 1
            done
        done
        
        
        echo -e "XXX\n100\nFinished...\nXXX"
        sleep 0.5
        
        
    } | whiptail --title "Install Containers" --gauge "Install nginx..." 6 80 0
    
    
    
    if [ -f "$CFG_PWD/failed_installations.txt" ]; then
        whiptail --title "Failed Installation" --msgbox "The following Installation(s) has failed:\n$(cat $CFG_PWD/failed_installations.txt)\n\nConsult the install Log under /var/homeautomation/script/log for further informations.\n\nThe failed Installations will be removed now." --ok-button "Remove" 22 80
        remove
    else
        whiptail --title "Sucessful Installation" --msgbox "All Tools were installed sucessfully and have Passed all Tests" --ok-button "Exit" 8 80
    fi
    
}

# Remove Tools
remove () {
    if [ -f "$CFG_PWD/failed_installations.txt" ]; then
        read -a TOOLS < $CFG_PWD/failed_installations.txt
    else
        select_for_uninstallation
        read -a TOOLS < $CFG_PWD/tools_to_uninstall.txt
    fi
    
    if (whiptail --title "Uninstall $CONTAINER_NAME" --yesno "Do you want to keep your Data of the following Container(s):\n${TOOLS[*]}" --yes-button "Keep data" --no-button "delete data" 8 80); then
        REMOVE_DATA=false
    else
        REMOVE_DATA=true
    fi
    
    {
        PROGRESS=0
        CONTAINER_PROGRESS=$(( 100 / ( ${#TOOLS[@]}) ))
        
        # Loop trough TOOLS and Uninstall all selected Tools
        for TOOL in "${TOOLS[@]}"
        do
            
            echo -e "XXX\n$PROGRESS\nUninstall $TOOL...\nXXX"
            PROGRESS=$(( $PROGRESS + $CONTAINER_PROGRESS ))
            if uninstall_container $TOOL $REMOVE_DATA &>> $LOG_PWD/script.log; then
                sed -i "s/$TOOL//g" $CFG_PWD/installed_tools.txt
            fi
        done
        
        if [ -f "$CFG_PWD/failed_installations.txt" ]; then
        rm $CFG_PWD/failed_installations.txt &>> $LOG_PWD/script.log
        fi
        echo -e "XXX\n100\nFinished...\nXXX"
        sleep 0.5
        
        
    } | whiptail --title "Uninstall" --gauge "Uninstall ..." 6 80 0
}

### Script

# Initialize Log File
echo "Script Started at: " $(date) > $LOG_PWD/script.log

# Chose, what to do:
MENU=$(whiptail --title "Install Script" --menu "What do you want to do?" --nocancel 20 80 4 \
    "Update" "Update the System and the installed tools" \
    "Install" "Install Tools" \
    "Remove" "Remove Tools" \
"Exit" "Leave this Script" 3>&1 1>&2 2>&3)

if [ $MENU = "Update" ] ;then
    update
    elif [ $MENU = "Install" ] ;then
    install
    elif [ $MENU = "Remove" ] ;then
    remove
    elif [ $MENU = "Exit" ] ;then
    exit 2
    
fi


