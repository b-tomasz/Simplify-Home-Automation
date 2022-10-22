# How to uninstall a Container from the System

- [How to uninstall a Container from the System](#how-to-uninstall-a-container-from-the-system)
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

After the script started select Remove and press Enter

<img src="Images/remove/Remove001.png" alt="Choose remove" width="500"/>
  
You will get asked which of the installed tools you want to remove. Choos the tools with your spacebar and arrows on the keyboard.

<img src="Images/remove/Remove002.png" alt="Choose Product to remove" width="500"/>

If you hit Enter you will get asked if you want to delet the persistent data. If you need the data or plan to reinstall the tool you can select Keep Settings, otherwise we recommend to delete them.

<img src="Images/remove/Remove003.png" alt="Select file removal" width="500"/>
Now the removal begins.

<img src="Images/remove/Remove004.png" alt="removeing" width="500"/>

After successfull removal you are done and can close the commandline.
