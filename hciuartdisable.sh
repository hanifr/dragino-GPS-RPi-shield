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

echo "${_MAGENTA}Setup Progress....SPI and Serial port :: started${_RESET}"
echo
sleep 5
echo "${_MAGENTA}hciuart.service will be reset${_RESET}"
echo
sudo systemctl disable hciuart
# setting up hciuart service
sudo rm /lib/systemd/system/hciuart.service
sudo cat >/tmp/hciuart.service <<EOL
[Unit]
Description=Configure Bluetooth Modems connected by UART
ConditionFileNotEmpty=/proc/device-tree/soc/gpio@7e200000/bt_pins/brcm,pins
Before=bluetooth.service
After=dev-ttyS0.device

[Service]
Type=forking
ExecStart=/usr/bin/hciattach /dev/ttyS0 bcm34xx noflow -

[Install]
WantedBy=multi-user.target
EOL
sudo mv /tmp/hciuart.service  /lib/systemd/system/hciuart.service
sleep 5
sudo apt-get update
sleep 5
sudo apt-get upgrade

echo "${_MAGENTA}Now reboot machine and do the following once booted${_RESET}"
echo
echo "${_MAGENTA}\"sudo reboot\"${_RESET}"
echo "${_MAGENTA}\"sudo cat /dev/ttyS0\"${_RESET}"
echo
