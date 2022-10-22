# Simplify-Home-Automation

- [Simplify-Home-Automation](#simplify-home-automation)
  - [Prerequisits:](#prerequisits)
  - [Ports that neet to be forwarded to Raspberry Pi](#ports-that-neet-to-be-forwarded-to-raspberry-pi)
  - [Folder Configuration](#folder-configuration)
  - [Networks](#networks)
  - [Application List with IP-address](#application-list-with-ip-address)
  - [Application default Username's](#application-default-usernames)
  - [Setup your Raspberry Pi](#setup-your-raspberry-pi)
  - [Install Documentation](#install-documentation)
  - [Start the Installationscript](#start-the-installationscript)

## Prerequisits:
> - Raspberry Pi
>    - Power Supply
>    - SD Card
>    - Ethernet Cable   
> - Home Network
> - DynDNS

## Ports that neet to be forwarded to Raspberry Pi
- 80
- 443
- 10000

## Folder Configuration

All Folder get created in   /var/homeautomation \
Scriptfolder                /var/homeautomation/script \
Apllicationfolder           /var/homeautomation/$Applicationname

## Networks
- Default homeautomation
- Network is defined in Nginx Container

## Application List with IP-address
| Container | IP address | Ports                                           | Web address                        |
| --------- | ---------- | ----------------------------------------------- | ---------------------------------- |
| Nginx     | 10.10.10.1 | 80:80,443:443                                   | -                                  |
| - Certbot | 10.10.10.2 | -                                               | -                                  |
| Portainer | 10.10.20.1 | (9000:9443)                                     | portainer.home / portainer.$Domain |
| Pihole    | 10.10.30.1 | 53:53,(8000:80)                                 | pihole.home / pihole.$Domain       |
| - DNS     | 10.10.30.2 | -                                               | -                                  |
| VPN       | 10.10.40.1 | 10000:51820                                     | vpn.$Domain                        |
| Bitwarden | 10.10.50.1 | (8001:80,9001:443)                              | bitwarden.home / bitwarden.$Domain |
| Nodered   | 10.10.60.1 | (8002:1880)                                     | nodered.home / nodered.$Domain     |
| Database  | 10.10.70.1 | (10002:3306)                                    | -                                  |
| - Adminer | 10.10.70.2 | (8003:8080)                                     | database.home / database.$Domain   |
| Grafana   | 10.10.80.1 | (8004:3000)                                     | grafana.home / grafana.$Domain     |
| Unifi     | 10.10.90.1 | 8443:8443,3478:3478,<br />8080:8080,10001:10001 | unifi.home / unifi.$Domain         |

All Ports marked with brackets () are not activ but can be activated in the docker-compose.yml File of each container. These are only required if you want to access the Container directly.

## Application default Username's
| Container | Username |
| --------- | -------- |
| Portainer | admin    |
| Pihole    | admin    |
| VPN       | admin    |
| Database  | root     |
| Grafana   | admin    |

## [Setup your Raspberry Pi](Documentation/01-setup.md)

## [Install Documentation](Documentation/02-install.md)

## Start the Installationscript
> cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh
