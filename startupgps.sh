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

echo "${_MAGENTA}Setup Progress....Creating GPS startup service:: started${_RESET}"
echo
sudo cat >/tmp/startup.sh <<EOL
#!/bin/bash

# cd /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/
sudo python /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/LoRaRX.py
sudo python3 /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/gps_simple.py >> /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples.log 2>&1

EOL
sudo mv /tmp/startup.sh /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startup.sh

sudo cat >/tmp/startgps.service <<EOL
[Unit]
Description=GPS module service
[Service]
Type=simple
# WorkingDirectory=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/
ExecStart=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startupgps.sh
# User=do-user
[Install]
WantedBy=multi-user.target
EOL
sudo mv /tmp/startgps.service /etc/systemd/system/startgps.service
echo "${_YELLOW}[*] Starting startgps systemd service${_RESET}"
sudo chmod 664 /etc/systemd/system/startgps.service
sudo systemctl daemon-reload
sudo systemctl enable startgps.service
sudo systemctl start startgps.service
echo "${_YELLOW}To see GPS startup service logs run \"sudo journalctl -u startgps -f\" command${_RESET}"

echo "${_MAGENTA}Setup Progress....Creating GPS startup service:: finished${_RESET}"
echo
 