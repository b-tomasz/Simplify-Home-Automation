#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-paperless.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/13-paperless/install-paperless.sh &> /dev/null; bash install-paperless.sh

CONTAINER_ID=13
CONTAINER_NAME=paperless
PASSWORD=$1

install (){
    
    # create Applikations folder
    mkdir -p /var/homeautomation/$CONTAINER_NAME
    
    
    # change to folder
    cd /var/homeautomation/$CONTAINER_NAME
       
    # downlod docker-compose.yml and run it
    rm docker-compose.yml &> /dev/null; wget ttps://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_ID-$CONTAINER_NAME/docker-compose.yml &> /dev/null
    
    
    # Start Container
    INFLUXDB_PASSWORD=$PASSWORD docker-compose up -d

    
}

# Upgrade Tools
upgrade (){
    # Upgrade Container
    cd /var/homeautomation/$CONTAINER_NAME
    docker-compose pull
    docker-compose up -d
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