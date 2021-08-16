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

echo "${_CYAN}Setup Progress....SPI and Serial port :: started${_RESET}"
echo
sleep 5
echo "${_CYAN}Now change settings in the hciuart.service according to the following${_RESET}"
echo
echo "${_CYAN}\"[Unit]
Description=Configure Bluetooth Modems connected by UART
ConditionFileNotEmpty=/proc/device-tree/soc/gpio@7e200000/bt_pins/brcm,pins
After=dev-serial1.device

[Service]
Type=forking
ExecStart=/usr/bin/btuart

[Install]
WantedBy=multi-user.target\"${_RESET}"
echo "${_CYAN}Use the following command to access the file"${_RESET}"
echo "${_CYAN}\"sudo nano /lib/systemd/system/hciuart.service\"${_RESET}"
echo
