# How to install the containers

- [How to install the containers](#how-to-install-the-containers)
  - [Check prerequisites](#check-prerequisites)
  - [Connect to Raspberry Pi](#connect-to-raspberry-pi)
  - [Start the Script](#start-the-script)
  - [Ports that need to be forwarded to Raspberry Pi](#ports-that-need-to-be-forwarded-to-raspberry-pi)
  - [Continue with the Script](#continue-with-the-script)
  - [Change DNS Server](#change-dns-server)
    - [Localy](#localy)
    - [Network wide](#network-wide)

## Check prerequisites

Please check all prerequisites from [Readme.md](../README.md)

## Connect to Raspberry Pi

1. To begin, log-in to your Raspberry Pi via ssh
      - If you use Windows, open PowerShell
      - If you use Linux or macOS, open Terminal
2. Enter the following command:
   - change the "pi" to your Username, if you changed it during installation
   - replace "home-server" with the hostname you set during installation
  
```
ssh pi@home-server.local
```

3. On the first connection, you will get a warning, that you're connecting to an unknown device. To confirm that, enter "yes" and confirm by pressing Enter
4. Enter your password and confirm by pressing Enter. **Note: you will not see any input when you enter your Password**
5. If the connection was successfully, you should see the following line in your command prompt:

```
pi@home-server:~ $
```

6. If you connected Successfully to the Raspberry Pi, elevate yourself to superuser using the following command:
```
sudo su
```

## Start the Script

1. Copy the following Code into your Bash Command Line
```
cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh
```

2. After the script started, select Install and press Enter

<img src="Images/install/Install001.png" alt="Choose install" width="500"/>
  
3. The system will now check a few parameters. Like the following:
    - your systems architecture
    - if your system is up-to-date
  
<br>

4. If one or multiple fail, you will get notified like this:

<img src="Images/install/Install002.png" alt="failed prerequisite" width="500"/>

5. In the next prompt, you will be asked to update the system.
Select "Update" to start the process

<img src="Images/install/Install004.png" alt="Update system" width="500"/>

6. As soon as the update is finished, the script continues with some essential prompts.

    - Please enter fixed IP and IP of your router.

<img src="Images/install/Install006.png" alt="Fixed ip pi" width="400"/><img src="Images/install/Install007.png" alt="Fixed ip router" width="400"/>

7. The next prompt is about the external Domain, this will be used to connect to your system via this domain. If you select Yes, your port forwarding must be active to the Raspberry Pi as described in the script. Your external Domain must resolve to your public IP. For example, you can use Bitwarden from everywhere. If you select no, Bitwarden, VPN and SSL can't be installed.

<img src="Images/install/Install008.png" alt="Domain info" width="500"/>

8. If you choose yes, you will get asked to type in your external Domain and your E-Mail address. Otherwise, this part will be skipped.

<img src="Images/install/Install009.png" alt="external domain" width="400"/><img src="Images/install/Install010.png" alt="E-Mail address" width="400"/>

9. Now the Raspberry Pi needs to reboot, to apply the configured settings. Reconnect to the Raspberry Pi as described earlier.

## Ports that need to be forwarded to Raspberry Pi

If you use an external Domain to use SSL Certificates (what we strongly recommend) it is necessary that you forward the follwing ports to your Raspberry Pi 

- HTTP: 80 (tcp)
  - Used to generate SSL certificates and redirect http to https
- HTTPS: 443 (tcp)
  - Used to Access Bitwarden from outside your network
- VPN: 10000 (udp)
  - Used to connect to your homenetwork via a VPN

How you have to enable the portforwording strongly depends on your router. If you couln't find it, then search on Google, how you can add a portforwarding on your router modell.
Here we show how it is done with the Internet-Box routers of the provider Swisscom. On most routers it will work in a simmilar way.

>We recommend that you do these Steps after you set the fixed IP of your Raspberry Pi.

1. Open the Webinterface of your router by entering the IP address of your router in the webbrowser. If you didn't change the IP it will be 192.168.1.1
2. Enable the Expert mode on the left side and then navigate to **Network -> Settings -> Port forwarding**
3. Click on **Add new rule**

   <img src="Images/Readme001.png" alt="Portforwarding1" width="800"/>

4. Enter **HTTP** as Name and **80** as the Entry Port

   <img src="Images/Readme002.png" alt="Portforwarding2" width="200"/>

5. Select the Protocol, Under device select your Raspberry Pi. Make sure, that you select the Fixed IP you set during installation, otherwise it may not work correctly
   
   <img src="Images/Readme003.png" alt="Portforwarding3" width="200"/>

6. Repeate Step 3 - 5 for the **HTTPS** and **VPN Port**

## Continue with the Script

1.  After you successfully reconnected to the Raspberry Pi and added the portforwarding, you need to restart the script using the following command:
```
cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh
```

2. Choose install. Now the Docker installation begins. This is the prerequisite for all the following steps.

<img src="Images/install/Install012.png" alt="Docker installation" width="400"/><img src="Images/install/Install013.png" alt="Docker is installing" width="400"/>

3.   As soon as Docker is installed, the next prompt will ask what Applications to install. You can navigate with the arrows and select with the space bar on the keyboard. Confirm your selection with Enter.

<img src="Images/install/Install014.png" alt="Choose Products" width="500"/>

4. If you choose either Portainer, Grafana, Database, VPN or Pi-hole you will get prompted to type in a default Password. It will be the same for all applications, and you can change it on the webinterface after installation.

5. If you complete this task successfully, the installation begins. Please be patient, this could take a while. As soon as the installation is completed, you will get notified.

<img src="Images/install/Install017.png" alt="Products are installing" width="400"/><img src="Images/install/Install018.png" alt="Successfully installed" width="400"/>

6. You can now close the Terminal or PowerShell. The installation is now finished.

## Change DNS Server

To access all tools with their DNS name, it is necessary that you change the DNS server to your Raspberry Pi. There are two options for doing this. You can either change the DNS setting localy on your computer or you change the DNS on your router. If you change this localy, it applies only for your computer, or you have to change this on every device.

### Localy

>This method applies only for the device you change it on. It is fine for testing purposes. For a final installation we recommend using the [Network wide](#network-wide) setting.

1. Press the **Windows Key + R**
2. Enter **ncpa.cpl** and presse Enter
   
   <img src="Images/Readme004.png" alt="Local DNS 1" width="400"/>

3. Click right on your used network connection and select **Preferences** 
   
   <img src="Images/Readme005.png" alt="Local DNS 2" width="300"/>
   
4. Double click on **Internet Protokoll Version 4** to open your IP settings
   
   <img src="Images/Readme006.png" alt="Local DNS 3" width="300"/>
   
5. Change to **Folgende DNS-Serveradressen verwenden** and enter the IP of your Raspberry Pi
   
   <img src="Images/Readme007.png" alt="Local DNS 4" width="300"/>

6. Click on **OK** to close the dialog boxes.

### Network wide

>This method applies for all devices connected to your network and is the best option for a final installation.

1. Open the webinterface of your router by entering the IP address of your router in the webbrowser. If you didn't change the IP it will be 192.168.1.1
2. Enable the Expert mode on the left side and then navigate to **Network -> Settings -> IP setting**
3. Scroll down to **IP address distribution (DHCP)**
4. Enable the checkbox **DNS servers advertised via DHCP options 6** and enter the IP address of your Raspberry Pi

    <img src="Images/Readme008.png" alt="DNS over DHCP" width="800"/>

5. You have to reconnect your device that this change applies to your device 

<b>All products are now available as described in the [README](../README.md)</b>