# How to install the Containers

- [How to install the Containers](#how-to-install-the-containers)
  - [Check Prerequisits](#check-prerequisits)
  - [Connect to Raspberry Pi](#connect-to-raspberry-pi)
  - [Start the Installationscript](#start-the-installationscript)
    - [The System will now chek a few parameters. Like the following:](#the-system-will-now-chek-a-few-parameters-like-the-following)
    - [In the next Promt you will be asked to update the System.](#in-the-next-promt-you-will-be-asked-to-update-the-system)
    - [As soon the update is finished the script Continues with some essential Promts.](#as-soon-the-update-is-finished-the-script-continues-with-some-essential-promts)

## Check Prerequisits

Please check all prerequisits from [Readme.md](../README.md)


## Connect to Raspberry Pi
To begin, Log-in to your Raspberry Pi via ssh. 
- If you use Windows open Powershell
- If you use Linux or MacOS open Terminal

Type in the following:
>ssh pi@home-server.local

If you connected Successfully to the Raspberry Pi, elevate yourself to superuser using the following command:
>sudo su

## Start the Installationscript
Copy the following Code into your Bash Command Line
> cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh

After the script started select Install and press Enter

<img src="Images/install/Install001.png" alt="Chose OS" width="500"/>
  
### The System will now chek a few parameters. Like the following:
- your systems architecture
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

Now the Raspberry Pi needs to reboot, to apply the configured Settings. Reconnect to the Pi as described before.

After you successfull reconnected to the pi, you need to restart the script using the following command:
> cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh

Choose again install. Now the Docker installation begins. This is the Prerequisit for all the following.

<img src="Images/install/Install012.png" alt="Chose OS" width="400"/><img src="Images/install/Install013.png" alt="Chose OS" width="400"/>

As soon Docker is installed the next Promt will ask what Applications to install. you can sellect them via Space bar and Arrows on the keyboard. Confirm your selection with Enter.

<img src="Images/install/Install014.png" alt="Chose OS" width="500"/>

If you choose either Portainer, Grafana, VPN or PiHole you will get promted to type in a default Password. It will be the same for all Applications and you can change it on the Webinterface after installation.

If you complete this task successfully the installation begins. Please be paitient this could take a while. As soon as the installation completes you will get notified.

<img src="Images/install/Install017.png" alt="Chose OS" width="400"/><img src="Images/install/Install018.png" alt="Chose OS" width="400"/>

You can now close the Terminal or Powershell. The installation is finished.

All Products are now availible as described in [README.md](../README.md)