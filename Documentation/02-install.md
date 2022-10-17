# How to install the Containers

- [How to install the Containers](#how-to-install-the-containers)
  - [Check Prerequisits](#check-prerequisits)
  - [Start the Installationscript](#start-the-installationscript)

## Check Prerequisits

Please check all prerequisits from [Readme.md](../README.md)

To begin, Log-in to your Raspberry Pi via ssh. 

Elevate yourself to superuser using the command "sudo su"

<br>

## Start the Installationscript
Copy the following Code into your Bash Command Line
> cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh

After the script started select Install and press Enter
  <img src="Images/install/Install001.png" alt="Chose OS" width="500"/>
The System will now chek a few parameters. Like the following:
- archictecture of your System
- Is your System up-to-date

If one or multiple fail you will get notified like this:
  <img src="Images/install/Install002.png" alt="Chose OS" width="500"/>

In the next Promt you will be asked to update the System.

As soon the update is finished the script Continues with some essential Promts.

Please enter Fixed IP, IP of your Router.
  <img src="Images/install/Install007.png" alt="Chose OS" width="500"/>

