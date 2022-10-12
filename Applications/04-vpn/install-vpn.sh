#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-vpn.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/04-vpn/install-vpn.sh &> /dev/null; bash install-vpn.sh

# Vergleich Openvpn und Wireguard:
# https://www.ipvanish.com/blog/wireguard-vs-openvpn/

# Open VPN mit Docker Compose:
# https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md

CONTAINER_ID=04
CONTAINER_NAME=vpn

source /var/homeautomation/script/config/ip.conf

install (){
    
    # create Applikations folder
    mkdir -p /var/homeautomation/$CONTAINER_NAME
    
    
    # change to folder
    cd /var/homeautomation/$CONTAINER_NAME

        # ask User for Pihole Password
    while true
    do
        PASSWORD=$(whiptail --title "VPN GUI Password" --nocancel --passwordbox "Please Enter a password for your VPN GUI:" 8 78  3>&1 1>&2 2>&3)
        if [ $(whiptail --title "VPN GUI Password" --nocancel --passwordbox "Please Confirm your Password:" 8 78  3>&1 1>&2 2>&3) = $PASSWORD ];then
            break
        else
            whiptail --title "VPN GUI Password" --msgbox "The Passwords you entred do not match.\nPlease Try it again." 8 78
        fi
    done
    
    # downlod docker-compose.yml and run it
    rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_ID-$CONTAINER_NAME/docker-compose.yml &> /dev/null
    
    
    # Start openvpn
    EXTERNAL_DOMAIN=$EXTERNAL_DOMAIN PASSWORD=$PASSWORD docker-compose up -d
    
}

# Upgrade Tools
upgrade (){
    #### ToDo
    echo upgrade
}

uninstall (){
    # Stop container
    cd /var/homeautomation/$CONTAINER_NAME
    docker-compose down
}

remove_data (){
    # Remove Application Folder
    rm -rv /var/homeautomation/$CONTAINER_NAME
}

# Get the options
while getopts "urg" option; do
    case $option in
        u) # uninstall
        UNINSTALL=true;;
        r) # remove Data
        REMOVE_DATA=true;;
        g) # upgrade
        UPGRADE=true;;
        \?) # Invalid option
            echo "Error: Invalid option"
        exit;;
    esac
done


if [ $UNINSTALL ] ;then
    # Uninstall Tools
    uninstall
    elif [ $UPGRADE ] ;then
    # Upgrade Tools
    upgrade
else
    if [ $REMOVE_DATA ] ;then
        # Invalid Option
        echo "Error: Invalid option"
        exit 1
    else
        # Install Tools
        install
    fi
fi

if [ $REMOVE_DATA ] ;then
    # Uninstall Tools and remove data
    remove_data
fi