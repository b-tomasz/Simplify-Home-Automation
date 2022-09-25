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


apt-get install dialog -y

DIALOG_RESULT=result

# Generate the dialog box
dialog --title "INPUT BOX" \
  --clear  \
  --inputbox \
"Hi, this is an input dialog box. You can use \n
this to ask questions that require the user \n
to input a string as the answer. You can \n
input strings of length longer than the \n
width of the input box, in that case, the \n
input field will be automatically scrolled. \n
You can use BACKSPACE to correct errors. \n\n
Try entering your name below:" \
16 51 2> $DIALOG_RESULT

clear

DIALOG_RESULT=result
##Test Checklist
dialog --title "INPUT BOX" \
  --clear  \
  --checklist \
"Hi, this is an input dialog box. You can use \n
this to ask questions that require the user \n
to input a string as the answer. You can \n
input strings of length longer than the \n
width of the input box, in that case, the \n
input field will be automatically scrolled. \n
You can use BACKSPACE to correct errors. \n\n
Try entering your name below:" \
16 51 2 Ttest Test1 TEst2 TEst3 Test4> $DIALOG_RESULT


pizza=`dialog --checklist "Pizza mit ..." 0 0 4 \
 Käse "" on\
 Salami "" off\
 Schinken "" off\
 Thunfisch "" off 3>&1 1>&2 2>&3`
dialog --clear
clear
echo "Ihre Bestellung: Pizza mit $pizza"

echo Test: $?
echo $DIALOG_RESULT




# install docker

apt install docker.io docker-compose
