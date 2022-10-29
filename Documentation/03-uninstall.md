# How to uninstall a Container from the System

- [How to uninstall a Container from the System](#how-to-uninstall-a-container-from-the-system)
  - [Connect to Raspberry Pi](#connect-to-raspberry-pi)
  - [Start the Script](#start-the-script)

## Connect to Raspberry Pi
1. To begin, Log-in to your Raspberry Pi via ssh. 
      - If you use Windows, open PowerShell
      - If you use Linux or macOS open Terminal
2. Enter the following command:
   - change the "pi" to your Username, if you changed it during installation
   - replace "home-server" with the hostname you set during installation
  
```
ssh pi@home-server.local
```

3. On the first connection, you will get a warning, that you're connecting to an unknown Device. To confirm that, enter "yes" and confirm by pressing Enter
4. Enter your Password and confirm by pressing Enter. **Note: you will not see any input, when you enter your Password**
5. If the Connection was successfully, you should see the following line in your command prompt:

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

2. After the script started, select Remove and press Enter

<img src="Images/remove/Remove001.png" alt="Choose remove" width="500"/>
  
3. You will get asked which of the installed tools you want to remove. Choose the tools with your space bar and arrows on the keyboard.

<img src="Images/remove/Remove002.png" alt="Choose Product to remove" width="500"/>

4. If you hit Enter, you will get asked if you want to delete the persistent data. If you need the data or plan to reinstall the tool, you can select Keep Settings. Otherwise, we recommend deleting them.

<img src="Images/remove/Remove003.png" alt="Select file removal" width="500"/>

5. Now the removal begins.

<img src="Images/remove/Remove004.png" alt="removeing" width="500"/>

After successful removal, you are done and can close the command line.
