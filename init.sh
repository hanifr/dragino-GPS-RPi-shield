#!/bin/bash
# Colors
_RED=`tput setaf 1`
_GREEN=`tput setaf 2`
_YELLOW=`tput setaf 3`
_BLUE=`tput setaf 4`
_MAGENTA=`tput setaf 5`
_CYAN=`tput setaf 6`
_RESET=`tput sgr0`
# printing greetings

echo "${_MAGENTA}Installation Progress....setup for for Dragino GPS data acquisition protocol :: started${_RESET}"
echo
sleep 5
chmod +x initnodered.sh
chmod +x primary.sh
chmod +x hciuartdisable.sh
chmod +x lora.sh
chmod +x loradaemon.sh
chmod +x loraControl.sh
chmod +x reboot.sh
echo "${_MAGENTA}Installation Progress....set local time to Kuala Lumpur${_RESET}"
echo
sudo timedatectl set-timezone Asia/Kuala_Lumpur
# Installation of Python Dependencies and GPS Libaries
echo "${_MAGENTA}Installation Progress...installation of GPS Python Library${_RESET}"
echo
sudo pip3 install adafruit-circuitpython-gps
sudo pip3 install board

echo "${_MAGENTA}Installation Progress....installation of MQTT PAHO: Started${_RESET}"
echo
git clone https://github.com/eclipse/paho.mqtt.python.git
cd ./paho.mqtt.python
sudo python setup.py install
sleep 5
echo "${_MAGENTA}Installation Progress....installation of MQTT PAHO: Completed${_RESET}"
echo
. loradaemon.sh