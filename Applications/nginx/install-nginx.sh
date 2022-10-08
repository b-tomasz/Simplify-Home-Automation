#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-nginx.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/nginx/install-nginx.sh &> /dev/null; bash install-nginx.sh


# create Applikations folder
mkdir -p /var/homeautomation/nginx


# change to folder
cd /var/homeautomation/nginx

# downlod docker-compose.yml and run it
rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/nginx/docker-compose.yml &> /dev/null

docker-compose up -d