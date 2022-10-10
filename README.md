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
|Container  |IP address  |Ports|
|---|---|---|
|Pihole     |10.0.10.10  |53,80 |
|DNS        |10.0.10.11  |- | 
|Bitwarden  |10.0.40.10  |8080, 8443| 
|Wireguard  |10.0.30.10  |   |
|nginx      |10.0.50.10  |80, 443|
|Unifi      |10.0.60.10  ||


## [Setup your Raspberry Pi](Documentation/setup.md)