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
git clone https://github.com/hanifr/PyLora.git
cd ./PyLora
python setup.py build
sudo python setup.py install
# setting up LoRa service
sleep 5
echo "${_CYAN}Please Enter the MQTT domain_name${_RESET} $_domain"
                read -p "Enter the MQTT domain_name: " _domain
echo
echo "${_CYAN}Please Enter the MQTT topic to publish data${_RESET} $_topic"
                read -p "Enter the MQTT topic_name: " _topic
sudo cat >/tmp/LoRaRX.py <<EOL
import PyLora
import time
import context  # Ensures paho is in PYTHONPATH
import paho.mqtt.publish as publish
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
    print(rec)
    publish.single("$_topic", rec, hostname="$_domain")
EOL
sudo mv /tmp/LoRaRX.py  /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/LoRaRX.py
sleep 5
sudo apt-get update
sleep 5
#sudo apt-get upgrade

echo "${_MAGENTA}Setup Progress....LoRa installation :: finished$${_RESET}"
echo
