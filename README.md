# Simplify-Home-Automation

<img src="Documentation/Images/Readme000.png" alt="title"/>

- [Simplify-Home-Automation](#simplify-home-automation)
  - [Overview](#overview)
  - [Prerequisites:](#prerequisites)
  - [Application List with IP-addresses](#application-list-with-ip-addresses)
  - [Networks](#networks)
  - [Ports that need to be forwarded to Raspberry Pi](#ports-that-need-to-be-forwarded-to-raspberry-pi)
  - [Folder configuration](#folder-configuration)
  - [Application default username's](#application-default-usernames)
  - [Start the installation script](#start-the-installation-script)
  - [Used Docker images](#used-docker-images)

## Overview

This repository is designed to get easy access to homeautomation and homenetwork management.

## Prerequisites:

> - Raspberry Pi 4 (RaspbianOS 64-Bit)
>    - Power supply
>    - SD card / SD card reader
>    - Ethernet cable
> - (DynDNS)

[Start installation with your Raspberry Pi](Documentation/01-setup.md)

## Application List with IP-addresses

| Container | IP address | Ports                                               | Web address                              |
| --------- | ---------- | --------------------------------------------------- | ---------------------------------------- |
| Nginx     | 10.10.10.1 | 80:80, 443:443                                      | -                                        |
| - Certbot | 10.10.10.2 | -                                                   | -                                        |
| Portainer | 10.10.20.1 | (9000:9443)                                         | portainer.home / portainer.[your Domain] |
| Pi-hole   | 10.10.30.1 | 53:53, (8000:80)                                    | pihole.home / pihole.[your Domain]       |
| - DNS     | 10.10.30.2 | -                                                   | -                                        |
| VPN       | 10.10.40.1 | 10000:51820                                         | vpn.[your Domain]                        |
| Bitwarden | 10.10.50.1 | (8001:80, 9001:443)                                 | bitwarden.home / bitwarden.[your Domain] |
| Node-RED  | 10.10.60.1 | (8002:1880)                                         | nodered.home / nodered.[your Domain]     |
| Database  | 10.10.70.1 | (10002:3306)                                        | -                                        |
| - Adminer | 10.10.70.2 | (8003:8080)                                         | database.home / database.[your Domain]   |
| Grafana   | 10.10.80.1 | (8004:3000)                                         | grafana.home / grafana.[your Domain]     |
| Unifi     | 10.10.90.1 | (8443:8443), 3478:3478,<br />8080:8080, 10001:10001 | unifi.home / unifi.[your Domain]         |

All ports marked with brackets () are not active, but can be activated in the docker-compose.yml File of each container. These are only required if you want to access the container directly.

## Networks

- Default homeautomation
- Network is defined in Nginx container

## Ports that need to be forwarded to Raspberry Pi

If you use an external domain to use SSL-Certificates (what we strongly recommend) it is necessary that you forward the follwing ports to your Raspberry Pi 

- HTTP: 80 (tcp)
  - Used to generate SSL-Certificates and redirect http to https
- HTTPS: 443 (tcp)
  - Used to access Bitwarden from outside your network
- VPN: 10000 (udp)
  - Used to connect to your homenetwork via a VPN

Further information and example configuration is listed in the [install documentation](Documentation/02-install.md#ports-that-need-to-be-forwarded-to-raspberry-pi)

## Folder configuration

All folders get created in  /var/homeautomation \
Script folder               /var/homeautomation/script \
Applicationfolder           /var/homeautomation/$Applicationname

## Application default username's

During installation you enter a password. That password will be set for all containers as default password. You can change the passwords after installation in the webinterface of each container.

| Container | Username |
| --------- | -------- |
| Portainer | admin    |
| Pi-hole   | admin    |
| VPN       | admin    |
| Database  | root     |
| Grafana   | admin    |

## Start the installation script
```
cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh
```

## Used Docker images
| Application | Link                                                  |
| ----------- | ----------------------------------------------------- |
| Nginx:      | https://hub.docker.com/_/nginx                        |
| Certbot:    | https://hub.docker.com/r/certbot/certbot              |
| Portainer:  | https://hub.docker.com/r/portainer/portainer-ce       |
| Pi-hole:    | https://hub.docker.com/r/pihole/pihole                |
| Bind9:      | https://hub.docker.com/r/ubuntu/bind9                 |
| WireGuard:  | https://hub.docker.com/r/weejewel/wg-easy             |
| Bitwarden:  | https://hub.docker.com/r/vaultwarden/server           |
| Node-RED:   | https://hub.docker.com/r/nodered/node-red             |
| Database:   | https://hub.docker.com/_/mysql                        |
| Adminer:    | https://hub.docker.com/_/adminer                      |
| Grafana:    | https://hub.docker.com/r/grafana/grafana-oss          |
| Unifi:      | https://hub.docker.com/r/linuxserver/unifi-controller |