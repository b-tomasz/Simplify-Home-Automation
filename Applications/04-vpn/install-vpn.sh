#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-vpn.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/vpn/install-vpn.sh &> /dev/null; bash install-vpn.sh

# Vergleich Openvpn und Wireguard:
# https://www.ipvanish.com/blog/wireguard-vs-openvpn/

# Open VPN mit Docker Compose:
# https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md

CONTAINER_ID=04
CONTAINER_NAME=vpn
URL=tcp://vpn.tomasz.app:443
DNS_SERVER=10.0.20.10

install (){
    
    # create Applikations folder
    mkdir -p /var/homeautomation/$CONTAINER_NAME
    
    
    # change to folder
    cd /var/homeautomation/$CONTAINER_NAME
    
    # downlod docker-compose.yml and run it
    rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_ID-$CONTAINER_NAME/docker-compose.yml &> /dev/null
    
    # Configure openvpn
    docker-compose run --rm $CONTAINER_NAME ovpn_genconfig -u $URL -n $DNS_SERVER
    docker-compose run --rm $CONTAINER_NAME ovpn_initpki
    
    # Start openvpn
    docker-compose up -d
    
    
    # Generate Client Certificate
    export CLIENTNAME="Test"
    # with a passphrase (recommended)
    docker-compose run --rm $CONTAINER_NAME easyrsa build-client-full $CLIENTNAME
    # without a passphrase (not recommended)
    # docker-compose run --rm $CONTAINER_NAME easyrsa build-client-full $CLIENTNAME nopass
    
    docker-compose run --rm $CONTAINER_NAME ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
    
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