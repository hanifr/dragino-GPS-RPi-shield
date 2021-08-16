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

# start doing stuff: preparing boot script
# preparing script background work and work under reboot
echo "[*] Creating boot script"
sudo rm /boot/cmdline.txt

cat >/tmp/cmdline.txt <<EOL
console=serial0,115200 console=tty1 root=PARTUUID=b87affef-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consolespi
EOL
sudo mv /tmp/cmdline.txt /boot/cmdline.txt

echo "${_MAGENTA}Please do the following${_RESET}"
echo "${_CYAN}Go to configuration section by${_RESET}"
echo "${_CYAN}\"sudo raspi-config\"${_RESET}"
echo
echo "${_CYAN}Then enter activate SPI and Serial Port${_RESET}"
echo
sleep 5
echo "${_CYAN}Now execute the following command${_RESET}"
echo "${_CYAN}\"sudo systemctl disable hciuart\"${_RESET}"
echo
echo "${_CYAN}Setup Progress....SPI and Serial port :: finished${_RESET}"
echo
