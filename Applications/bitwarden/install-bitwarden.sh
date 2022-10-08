#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-bitwarden.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/bitwarden/install-bitwarden.sh &> /dev/null; bash install-bitwarden.sh

# create Applikations folder
mkdir -p /var/homeautomation/bitwarden


# change to folder
cd /var/homeautomation/bitwarden

# downlod docker-compose.yml and run it
rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/bitwarden/docker-compose.yml &> /dev/null

docker-compose up -d