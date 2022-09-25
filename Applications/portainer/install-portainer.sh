#!/bin/bash
#Script ausführen mit:
#rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/portainer/install-portainer.sh &> /dev/null; bash install-portainer.sh

# create Applikations folder
mkdir -p /var/homeautomation/portainer


# change to folder
cd /var/homeautomation/portainer

# downlod docker-compose.yml and run it
rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/portainer/docker-compose.yml &> /dev/null

docker-compose up -d