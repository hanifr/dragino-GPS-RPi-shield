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
sudo rm -rf /boot/cmdline.txt

sudo cat >/tmp/cmdline.txt <<EOL
dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait
EOL
sudo mv /tmp/cmdline.txt /boot/cmdline.txt

echo

