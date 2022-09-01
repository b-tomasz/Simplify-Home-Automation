#!/bin/bash
#Script ausführen mit:
#rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh

ARCH=$(uname -m)
echo Die Architektur ist: $ARCH

if [[ $ARCH == "aarch64" ]]
then
    echo Prüfung bestanden!
else
    echo Prüfung fehlgeschlagen!
fi


echo System wird upgedated!
apt-get update
apt-get upgrade -y
apt-get autoremove -y
apt-get clean -y


rm /tmp/installScript -r &> /dev/null
mkdir /tmp/installScript
cd /tmp/installScript

pwd
ls -lisa






