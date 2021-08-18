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

sudo cat >/tmp/loradragino.service <<EOL
[Unit]
Description=LoRa module service
After=network.target
[Service]
Type=simple
# WorkingDirectory=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples
ExecStart=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startlora.sh
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

sudo cat >/tmp/gpsdragino.service <<EOL
[Unit]
Description=GPS module service
Wants=network.target
After=loradragino.service
[Service]
Type=simple
# WorkingDirectory=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples
ExecStart=/home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/startgps.sh
Restart=on-failure
User=pi
[Install]
WantedBy=multi-user.target
EOL
sudo mv /tmp/gpsdragino.service /etc/systemd/system/gpsdragino.service
echo "${_YELLOW}[*] Starting gpsdragino systemd service${_RESET}"
sudo chmod 664 /etc/systemd/system/gpsdragino.service
sudo systemctl daemon-reload
sudo systemctl enable gpsdragino.service
sudo systemctl start gpsdragino.service

echo "${_YELLOW}To see GPS startup service logs run \"sudo journalctl -u loradragino -f\" command${_RESET}"
echo "${_YELLOW}To see LoRa startup service logs run \"sudo journalctl -u gpsdragino -f\" command${_RESET}"
echo
echo "${_MAGENTA}Setup Progress....Creating GPS and LoRa startup service:: finished${_RESET}"
echo
 