#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-nginx.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/01-nginx/install-nginx.sh &> /dev/null; bash install-nginx.sh

CONTAINER_ID=01
CONTAINER_NAME=nginx

install (){
    
    # create Applikations folder
    mkdir -p /var/homeautomation/$CONTAINER_NAME

    # create nginx config File
    mkdir -p /var/homeautomation/$CONTAINER_NAME/volumes/nginx/conf.d
    cd /var/homeautomation/$CONTAINER_NAME/volumes/nginx/conf.d
    echo "#Complete Nginx Docker reverse proxy config file
server {
  listen 80;
  listen [::]:80;
  server_name localhost;

  location / {
    root /usr/share/nginx/html;
    index index.html index.htm;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}
server {
  listen 80;
  server_name portainer.home;
  location / {
    proxy_pass https://10.0.10.1:9000;
  }
}
server {
  listen 80;
  server_name pihole.home;
  location / {
    proxy_pass http://10.0.10.:8000;
  }
}
server {
  listen 80;
  server_name grafana.home;
  location / {
    proxy_pass http://10.0.80.1:8004;
  }
}" > homeautomation.conf
    
    # change to folder
    cd /var/homeautomation/$CONTAINER_NAME
    
    # downlod docker-compose.yml and run it
    rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_ID-$CONTAINER_NAME/docker-compose.yml &> /dev/null
    
    # copy default.conf to folder
    rm ./volumes/conf.d/default.conf &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_ID-$CONTAINER_NAME/default.conf &> /dev/null
    mv default.conf ./volumes/conf.d/default.conf

    # Start Container
    docker-compose up -d
    
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