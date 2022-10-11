# Simplify-Home-Automation

- [Simplify-Home-Automation](#simplify-home-automation)
  - [Prerequisits:](#prerequisits)
  - [Folder Configuration](#folder-configuration)
  - [Networks](#networks)
  - [Application List with IPaddress](#application-list-with-ipaddress)
  - [Setup your Raspberry Pi](#setup-your-raspberry-pi)

## Prerequisits:
> - Raspberry Pi
>    - Power Supply
>    - SD Card
>    - Ethernet Cable   
> - Home Network

## Folder Configuration

All Folder get created in   /var/homeautomation \
Scriptfolder                /var/homeautomation/script \
Apllicationfolder           /var/homeautomation/$Applicationname

## Networks
- Default homeautomation

For each Application a seprate network is created


## Application List with IPaddress
| Container | IP address | Ports                                       |
| --------- | ---------- | ------------------------------------------- |
| Nginx     | 10.0.10.1  | 80:80,443:443                               |
| Certbot   | 10.0.10.2  | -                                           |
| Portainer | 10.0.20.1  | (9000:9443)                                 |
| Pihole    | 10.0.30.1  | 53:53,(8000:80)                             |
| DNS       | 10.0.30.2  | -                                           |
| VPN       | 10.0.40.1  | 10000:51820                                 |
| Bitwarden | 10.0.50.1  | (8001:80,9001:443)                          |
| Nodered   | 10.0.60.1  | (8002:1880)                                 |
| Database  | 10.0.70.1  | (10002:3306)                                |
| Adminer   | 10.0.70.2  | (8003:8080)                                 |
| Grafana   | 10.0.80.1  | (8004:3000)                                 |
| Unifi     | 10.0.90.1  | (9002:8443),3478:3478,8080:8080,10001:10001 |


## [Setup your Raspberry Pi](Documentation/setup.md)