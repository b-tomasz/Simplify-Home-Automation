# Simplify-Home-Automation

- [Simplify-Home-Automation](#simplify-home-automation)
  - [Overview](#overview)
  - [Setup your Raspberry Pi](#setup-your-raspberry-pi)
  - [Prerequisites:](#prerequisites)
  - [Application List with IP-addresses](#application-list-with-ip-addresses)
  - [Networks](#networks)
  - [Ports that need to be forwarded to Raspberry Pi](#ports-that-need-to-be-forwarded-to-raspberry-pi)
  - [DNS Configuration](#dns-configuration)
  - [Folder Configuration](#folder-configuration)
  - [Application default Username's](#application-default-usernames)
  - [Start the Installation script](#start-the-installation-script)

## Overview

This Repository

## [Setup your Raspberry Pi](Documentation/01-setup.md)

## Prerequisites:

> - Raspberry Pi
>    - Power Supply
>    - SD Card / SD Card Reader
>    - Ethernet Cable   
> - (DynDNS)

## Application List with IP-addresses

| Container | IP address | Ports                                             | Web address                              |
| --------- | ---------- | ------------------------------------------------- | ---------------------------------------- |
| Nginx     | 10.10.10.1 | 80:80, 443:443                                    | -                                        |
| - Certbot | 10.10.10.2 | -                                                 | -                                        |
| Portainer | 10.10.20.1 | (9000:9443)                                       | portainer.home / portainer.[your Domain] |
| Pihole    | 10.10.30.1 | 53:53, (8000:80)                                  | pihole.home / pihole.[your Domain]       |
| - DNS     | 10.10.30.2 | -                                                 | -                                        |
| VPN       | 10.10.40.1 | 10000:51820                                       | vpn.[your Domain]                        |
| Bitwarden | 10.10.50.1 | (8001:80, 9001:443)                               | bitwarden.home / bitwarden.[your Domain] |
| Nodered   | 10.10.60.1 | (8002:1880)                                       | nodered.home / nodered.[your Domain]     |
| Database  | 10.10.70.1 | (10002:3306)                                      | -                                        |
| - Adminer | 10.10.70.2 | (8003:8080)                                       | database.home / database.[your Domain]   |
| Grafana   | 10.10.80.1 | (8004:3000)                                       | grafana.home / grafana.[your Domain]     |
| Unifi     | 10.10.90.1 | 8443:8443, 3478:3478,<br />8080:8080, 10001:10001 | unifi.home / unifi.[your Domain]         |

All Ports marked with brackets () are not active, but can be activated in the docker-compose.yml File of each container. These are only required if you want to access the Container directly.

## Networks

- Default homeautomation
- Network is defined in Nginx Container

## Ports that need to be forwarded to Raspberry Pi

If you use an external Domain to use SSL Certificates (what we strongly reccomend) then it is necessary that you forward the follwing Ports to Your Raspberry Pi 

- HTTP: 80 (tcp)
  - Used to generate SSL certificates and redirert http to https
- HTTPS: 443 (tcp)
  - Used to Access Bitwarden from Outside your Network
- VPN: 10000 (udp)
  - Used to connect to your Homenetwork via a VPN

Further Information and example configuration is listed in the [install documentation](Documentation/02-install.md#ports-that-need-to-be-forwarded-to-raspberry-pi)

## DNS Configuration

After successfully installed PiHole you need to set your DNS Setting pointing to the Raspberry Pi.
Further information discribed in the [install documentation](Documentation/02-install.md#change-dns-server)

## Folder Configuration

All folders get created in  /var/homeautomation \
Script folder               /var/homeautomation/script \
Apllicationfolder           /var/homeautomation/$Applicationname

## Application default Username's

During installation you enter an Password. That Password will be set for all containers as default Password. You can change the Passwords after installation in the Webinterface of each Container.

| Container | Username |
| --------- | -------- |
| Portainer | admin    |
| Pihole    | admin    |
| VPN       | admin    |
| Database  | root     |
| Grafana   | admin    |

## Start the Installation script
```
cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh
```