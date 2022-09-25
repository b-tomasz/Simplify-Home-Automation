#!/bin/bash
#Script ausführen mit:
#rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/pihole/install-pihole.sh &> /dev/null; bash install-pihole.sh

# create Applikations folder
mkdir -p /var/homeautomation/pihole


# change to folder
cd /var/homeautomation/pihole

# downlod docker-compose.yml and run it
rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/pihole/docker-compose.yml &> /dev/null

docker-compose up -d