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

echo "${_MAGENTA}Setup Progress....LoRa installation :: started${_RESET}"
echo
sleep 5
echo "${_MAGENTA}Downloading PyLoRa Library${_RESET}"
echo
mkdir LoRaRX
git clone https://github.com/hanifr/PyLora.git
cd ./PyLora
python setup.py build
sudo python setup.py install
# setting up LoRa service
sudo cat >/tmp/Receiver.py <<EOL
import PyLora
import time
import json

PyLora.init()
PyLora.set_frequency(917700000)
PyLora.enable_crc()

while True:
    PyLora.receive()   # put into receive mode
    while not PyLora.packet_available():
        # wait for a package
        time.sleep(0)
    rec = PyLora.receive_packet()
    rssi_val = PyLora.packet_rssi()
#    Data = {"data": `rec`, "rssi": `rssi_val`}
#    loraData = json.dumps(Data)
    print ({rec, rssi_val})
EOL
sudo mv /tmp/Receiver.py  /home/pi/dragino-GPS-RPi-shield/LoRaRX/Receiver.py
sleep 5
sudo apt-get update
sleep 5
#sudo apt-get upgrade

echo "${_MAGENTA}Setup Progress....LoRa installation :: finished$${_RESET}"
echo
