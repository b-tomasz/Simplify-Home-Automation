# How to setup your Raspberry Pi

- [How to setup your Raspberry Pi](#how-to-setup-your-raspberry-pi)
  - [What you need to start](#what-you-need-to-start)
  - [Installation of the operating system](#installation-of-the-operating-system)
  - [Start up Raspberry Pi](#start-up-raspberry-pi)

## What you need to start

You should prepare the following items, before you continue:
> - Raspberry Pi 4B (at least 4 GB of RAM are recommended)
>   - Power supply
>   - Micro SD card
> - Computer with SD card reader
> - Ethernet cable

## Installation of the operating system

To flash the operating system to the SD card, we are using the [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

1. Download and install the Raspberry Pi Imager on your computer
2. Start the Raspberry Pi Imager
3. Click on "Choose OS"

    <img src="Images/Setup001.png" alt="Choose OS" width="500"/>

4. Select "Raspberry Pi (Other)"

    <img src="Images/Setup002.png" alt="Select Raspberry Pi (Other)" width="500"/>

5. Select "Raspberry Pi OS Lite (64-bit)" **Be sure, that you choose the 64-bit Version** 

    <img src="Images/Setup003.png" alt="Select Raspberry Pi OS Lite (64-bit)" width="500"/>

6. Click on "Choose Storage"
   
   <img src="Images/Setup008.png" alt="Click on Choose Storage" width="500"/>
   
7. Select your SD card. **Be sure, that you select the correct card, as all data of this SD card will be erased during this process**

    <img src="Images/Setup009.png" alt="Select your SD Card" width="500"/>

8. Click on the gearbox on the bottom right, to change some additional settings

    <img src="Images/Setup004.png" alt="Open Settings" width="500"/>

9. Change the following settings:
   - Hostname: Set your preferred hostname
   - Username: Select a username for your Raspberry Pi (we recommend using "pi")
   - Password: Select a password for your Raspberry Pi
   - SSID and Password: Enter the SSID and password of your Wi-Fi network (Optional)
   - Country, Time Zone and Keyboard: Change this to your preferred settings
   
    <img src="Images/Setup005.png" alt="Change Settings" width="500"/>

10. Click on "Write"
    
    <img src="Images/Setup006.png" alt="Click on Write" width="500"/>

11. Confirm, that you have selected the correct SD card and that all data on this SD card will be erased.

    <img src="Images/Setup007.png" alt="Confirm Write to SD Card" width="500"/>
    
12. As soon as the flashing is finished, remove the SD card from your computer
    
---

## Start up Raspberry Pi

1. Insert the SD card in to your Raspberry Pi
2. Connect the Raspberry Pi with the ethernet cable to your router or switch
3. Plug in the power supply
4. Wait until the first boot has completed. This can take up to 5 minutes

Now you can continue with the [Install Documentation](02-install.md)
