# How to install the Containers

- [How to install the Containers](#how-to-install-the-containers)
  - [Check Prerequisits](#check-prerequisits)
  - [Connect to Raspberry Pi](#connect-to-raspberry-pi)
  - [Start the Installationscript](#start-the-installationscript)

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

<img src="Images/install/Install001.png" alt="Choose install" width="500"/>
  
The System will now chek a few parameters. Like the following:
- your systems architecture
- if your System is up-to-date

If one or multiple fail you will get notified like this:

<img src="Images/install/Install002.png" alt="failed prerequisite" width="500"/>

In the next Promt you will be asked to update the System.
Select "Update" to start the Process

<img src="Images/install/Install004.png" alt="Update system" width="500"/>

As soon the update is finished the script Continues with some essential Promts.

- Please enter Fixed IP and IP of your Router.

<img src="Images/install/Install006.png" alt="Fixed ip pi" width="400"/><img src="Images/install/Install007.png" alt="Fixed ip router" width="400"/>

- The next Promt is about the External Domain

<img src="Images/install/Install008.png" alt="Domain info" width="500"/>

If you choose yes, you will get asked to type in your External Domain and your E-Mail address. Otherwise this part will get skiped.

<img src="Images/install/Install009.png" alt="External domain" width="400"/><img src="Images/install/Install010.png" alt="E-Mail address" width="400"/>

Now the Raspberry Pi needs to reboot, to apply the configured Settings. Reconnect to the Pi as described earlier.

After you successfull reconnected to the pi, you need to restart the script using the following command:
> cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh

Choose install. Now the Docker installation begins. This is the Prerequisit for all of the following.

<img src="Images/install/Install012.png" alt="Docker installation" width="400"/><img src="Images/install/Install013.png" alt="Docker is installing" width="400"/>

As soon as Docker is installed the next Promt will ask what Applications to install. You can sellect them via Space bar and Arrows on the keyboard. Confirm your selection with Enter.

<img src="Images/install/Install014.png" alt="Chose Products" width="500"/>

If you choose either Portainer, Grafana, VPN or PiHole you will get promted to type in a default Password. It will be the same for all Applications and you can change it on the Webinterface after installation.

If you complete this task successfully the installation begins. Please be paitient this could take a while. As soon as the installation is completed you will get notified.

<img src="Images/install/Install017.png" alt="Products are installing" width="400"/><img src="Images/install/Install018.png" alt="Successfully installed" width="400"/>

You can now close the Terminal or Powershell. The installation is now finished.

All Products are now availible as described in [README.md](../README.md)