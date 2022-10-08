#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-vpn.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/vpn/install-vpn.sh &> /dev/null; bash install-vpn.sh

# Vergleich Openvpn und Wireguard:
# https://www.ipvanish.com/blog/wireguard-vs-openvpn/

# Open VPN mit Docker Compose:
# https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md


UNINSTALL=false
REMOVE_DATA=false


install (){
    echo install
    return
    
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
    
    echo uninstall
    
}

remove_data (){
    
    echo remove_data
}

# Get the options
while getopts ":ur:" option; do
    case $option in
        u) # uninstall
        $UNINSTALL=true;;
        r) # remove Data
        $REMOVE_DATA=true;;
        \?) # Invalid option
            echo "Error: Invalid option"
        exit;;
    esac
done


if [[ $UNINSTALL -eq true ]] ;then

    # Uninstall Tools
    uninstall
    
    elif [[ $REMOVE_DATA -eq true ]] ;then
    
    # Uninstall Tools and remove data
    uninstall
    remove_data

else
    # Install Tools
    install
fi