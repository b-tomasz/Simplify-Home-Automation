#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-vpn.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/vpn/install-vpn.sh &> /dev/null; bash install-vpn.sh

# Vergleich Openvpn und Wireguard:
# https://www.ipvanish.com/blog/wireguard-vs-openvpn/


# create Applikations folder
mkdir -p /var/homeautomation/bitwarden


# change to folder
cd /var/homeautomation/bitwarden

# downlod docker-compose.yml and run it
rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/bitwarden/docker-compose.yml &> /dev/null

docker-compose up -d