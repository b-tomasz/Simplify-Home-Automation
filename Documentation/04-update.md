# How to update the system and all containers

- [How to update the system and all containers](#how-to-update-the-system-and-all-containers)
  - [Connect to Raspberry Pi](#connect-to-raspberry-pi)
  - [Start the script](#start-the-script)

## Connect to Raspberry Pi
1. To begin, log-in to your Raspberry Pi via ssh. 
      - If you use Windows, open PowerShell
      - If you use Linux or macOS open Terminal
2. Enter the following command:
   - change the "pi" to your username, if you changed it during installation
   - replace "home-server" with the hostname you set during installation
  
```
ssh pi@home-server.local
```

3. On the first connection, you will get a warning, that you're connecting to an unknown device. To confirm this, enter "yes" and confirm by pressing Enter
4. Type in your password and confirm by pressing Enter. **Note: you will not see any input, when you enter your password**
5. If the Connection was successful, you should see the following line in your command prompt:

```
pi@home-server:~ $
```

6. If you connected successfully to the Raspberry Pi, elevate yourself to superuser using the following command:
```
sudo su
```

## Start the script
1. Copy the following code into your Bash command line
```
cd /tmp; rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh
```

2. After the script started, select "Update" and press Enter

<img src="Images/update/Update001.png" alt="Choose update" width="500"/>
  
3. The system will now check your architecture.

<img src="Images/update/Update002.png" alt="Choose Continue" width="500"/>

4. The script asks you now if you want to install updates or exit. Choose update.

<img src="Images/update/Update003.png" alt="Choose update" width="500"/>

5. The system and all containers will be updated. 

<img src="Images/update/Update004.png" alt="System is updating" width="500"/>

After a successful update, you are finished and can close the command line.

