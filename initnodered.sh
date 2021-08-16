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

echo "${_CYAN}Setup Progress....Upgrading Node-Red 2.x :: started${_RESET}"
echo
sleep 5

sudo apt install build-essential git curl
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered) --node14
sleep 5

# node-red admin init
sudo systemctl enable nodered.service 
node-red-start

echo "${_CYAN}Now change settings in the hciuart.service according to the following${_RESET}"
echo

echo "${_CYAN}Setup Progress....Upgrading Node-Red 2.x :: Finished${_RESET}"