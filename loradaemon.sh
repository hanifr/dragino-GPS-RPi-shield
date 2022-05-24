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

./lora.sh
echo "${_MAGENTA}Setup Progress....Creating LoRa startup service:: started${_RESET}"
echo
sudo cat >/tmp/startlora.sh <<EOL
#!/bin/bash

# cd /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/
sudo python /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/LoRaRX.py

EOL

sudo mv /tmp/startlora.sh /home/pi/dragino-GPS-RPi-shield/startlora.sh
sudo chmod 744 /home/pi/dragino-GPS-RPi-shield/startlora.sh
sudo chmod +x /home/pi/dragino-GPS-RPi-shield/startlora.sh

# Create daemon service at boot up
sudo cat >/tmp/loradragino.service <<EOL
[Unit]
Description=LoRa module service
After=network.target
[Service]
Type=simple
ExecStart=/home/pi/dragino-GPS-RPi-shield/startlora.sh
Restart=on-failure
User=pi
[Install]
WantedBy=multi-user.target
EOL
sudo mv /tmp/loradragino.service /etc/systemd/system/loradragino.service
echo "${_YELLOW}[*] Starting loradragino systemd service${_RESET}"
sudo chmod 664 /etc/systemd/system/loradragino.service
sudo systemctl daemon-reload
sudo systemctl enable loradragino.service
sudo systemctl start loradragino.service



echo "${_YELLOW}To see LoRa startup service logs run \"sudo journalctl -u loradragino -f\" command${_RESET}"
echo
echo "${_MAGENTA}Setup Progress....Creating LoRa startup service:: finished${_RESET}"
echo
 