#!/bin/bash
# check arch
check_arch () {
ARCH=$(uname -m)
echo "The Architecture is: $ARCH" >> $LOG_PWD/install.log

if [[ $ARCH == "aarch64" ]]
then
    whiptail --title "System Architecture" --msgbox "Your Architecture is $ARCH" --ok-button "Continue" 8 78
    echo "if Then" >> $LOG_PWD/install.log
else
    if (whiptail --title "System Architecture" --yesno "Your Architecture is $ARCH\n Your Platform is not Supported\n Ignor this at your own risk" --yes-button "Ignore" --no-button "Exit" 8 78); then
          return
    else
            # Exit Script
            echo "Installscript aborted by the User" >> $LOG_PWD/install.log
            exit_script 2
    fi
fi
}

# Check Architecture
check_arch