# How to update the System and all Containers

- [How to update the System and all Containers](#how-to-update-the-system-and-all-containers)
  - [Connect to Raspberry Pi](#connect-to-raspberry-pi)
  - [Start the Script](#start-the-script)

## Connect to Raspberry Pi
To begin, Log-in to your Raspberry Pi via ssh. 
- If you use Windows open Powershell
- If you use Linux or MacOS open Terminal

Type in the following:
>ssh pi@home-server.local

If you connected Successfully to the Raspberry Pi, elevate yourself to superuser using the following command:
>sudo su

## Start the Script
Copy the following Code into your Bash Command Line
> cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh

After the script started select Update and press Enter

<img src="Images/update/Update001.png" alt="Choose update" width="500"/>
  
The System will now check your architecture.

<img src="Images/update/Update002.png" alt="Choose Continue" width="500"/>

The script asks you no if you want to install updates or exit. Choose update.

<img src="Images/update/Update003.png" alt="Choose update" width="500"/>

The system and all containers will be updated. 

<img src="Images/update/Update004.png" alt="System is updating" width="500"/>

After successfull update you are done and can close the commandline.

