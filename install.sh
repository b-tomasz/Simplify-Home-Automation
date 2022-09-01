#!/bin/bash
#Script ausführen mit:
#rm install.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/install.sh &> /dev/null; bash install.sh

ARCH=$(uname -m)
echo Die Architektur ist: $ARCH

if [[ $ARCH == "aarch64" ]]
then
    echo Prüfung bestanden!
else
    echo Prüfung fehlgeschlagen!ysd
fi