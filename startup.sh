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
echo "${_MAGENTA}Setup Progress....Creating GPS and LoRa startup service:: started${_RESET}"
echo
sudo cat >/tmp/startlora.sh <<EOL
#!/bin/bash

# cd /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/
sudo python /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/LoRaRX.py

EOL
sudo mv /tmp/startlora.sh /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startlora.sh
sudo chmod 744 /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startlora.sh

sudo cat >/tmp/startgps.sh <<EOL
#!/bin/bash

# cd /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/
sudo python3 /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/gps_simple.py

EOL
sudo mv /tmp/startgps.sh /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startgps.sh
sudo chmod 744 /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startgps.sh

sudo cat >/tmp/startdragino.service <<EOL
[Unit]
Description=GPS module service
[Service]
Type=simple
# WorkingDirectory=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples
ExecStartPre=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startlora.sh
ExecStart=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startgps.sh
Restart=on-failure
# User=do-user
[Install]
WantedBy=multi-user.target
EOL
sudo mv /tmp/startdragino.service /etc/systemd/system/startdragino.service
echo "${_YELLOW}[*] Starting startdragino systemd service${_RESET}"
sudo chmod 664 /etc/systemd/system/startdragino.service
sudo systemctl daemon-reload
sudo systemctl enable startdragino.service
sudo systemctl start startdragino.service
echo "${_YELLOW}To see GPS startup service logs run \"sudo journalctl -u startdragino -f\" command${_RESET}"

echo "${_MAGENTA}Setup Progress....Creating GPS and LoRa startup service:: finished${_RESET}"
echo
 