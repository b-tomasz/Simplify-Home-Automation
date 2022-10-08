#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-vpn.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/vpn/install-vpn.sh &> /dev/null; bash install-vpn.sh

# Vergleich Openvpn und Wireguard:
# https://www.ipvanish.com/blog/wireguard-vs-openvpn/

# Open VPN mit Docker Compose:
# https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md


install (){
   
    # create Applikations folder
    mkdir -p /var/homeautomation/vpn
    
    
    # change to folder
    cd /var/homeautomation/vpn
    
    # downlod docker-compose.yml and run it
    rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/vpn/docker-compose.yml &> /dev/null
    
    # Configure openvpn
    docker-compose run --rm openvpn ovpn_genconfig -u tcp://vpn.tomasz.app
    docker-compose run --rm openvpn ovpn_initpki
    
    # Start openvpn
    docker-compose up -d
    
    
    # Generate Client Certificate
    export CLIENTNAME="Test"
    # with a passphrase (recommended)
    docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
    # without a passphrase (not recommended)
    docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
    
    docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
    
}

uninstall (){
    # Stop container
    docker compose down
}

remove_data (){
    # Remove Application Folder
    rm -rv /var/homeautomation/vpn
}

# Get the options
while getopts "ur" option; do
    case $option in
        u) # uninstall
        UNINSTALL=true;;
        r) # remove Data
        REMOVE_DATA=true;;
        \?) # Invalid option
            echo "Error: Invalid option"
        exit;;
    esac
done


if [ $Uninstall ] ;then
    # Uninstall Tools
    uninstall
    elif [ $REMOVE_DATA ] ;then
    # Invalid Option
    echo "Error: Invalid option"
    exit 1
else
    # Install Tools
    install
fi

if [ $REMOVE_DATA ] ;then
    # Uninstall Tools and remove data
    remove_data
    
fi