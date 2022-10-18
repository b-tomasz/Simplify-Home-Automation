# How to install the Containers

- [How to install the Containers](#how-to-install-the-containers)
  - [Check Prerequisits](#check-prerequisits)
  - [Start the Installationscript](#start-the-installationscript)
    - [The System will now chek a few parameters. Like the following:](#the-system-will-now-chek-a-few-parameters-like-the-following)
    - [In the next Promt you will be asked to update the System.](#in-the-next-promt-you-will-be-asked-to-update-the-system)
    - [As soon the update is finished the script Continues with some essential Promts.](#as-soon-the-update-is-finished-the-script-continues-with-some-essential-promts)

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
  
### The System will now chek a few parameters. Like the following:
- archictecture of your System
- Is your System up-to-date

If one or multiple fail you will get notified like this:

<img src="Images/install/Install002.png" alt="Chose OS" width="500"/>

### In the next Promt you will be asked to update the System.
Select "Update" to start the Process

<img src="Images/install/Install004.png" alt="Chose OS" width="500"/>

### As soon the update is finished the script Continues with some essential Promts.

- Please enter Fixed IP, IP of your Router.

<img src="Images/install/Install006.png" alt="Chose OS" width="400"/><img src="Images/install/Install007.png" alt="Chose OS" width="400"/>

- The next Promt is about the External Domain

<img src="Images/install/Install008.png" alt="Chose OS" width="500"/>

If you choose yes, you will get asked to type in your External Domain and your E-Mail address.

<img src="Images/install/Install009.png" alt="Chose OS" width="400"/><img src="Images/install/Install010.png" alt="Chose OS" width="400"/>

