
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

echo "${_MAGENTA}Installation Progress....setup for remote command for LoRa service :: started${_RESET}"
echo
echo "${_MAGENTA}Installation Progress...installation a Mosquitto broker that is always available.${_RESET}"
echo
sudo apt-get install mosquitto
#sudo apt-get install python3-pip
sudo pip3 install paho-mqtt
sleep 5
echo "${_CYAN}Please Enter the MQTT domain_name${_RESET} $_domain"
                read -p "Entered the MQTT domain_name: " _domain
echo
echo "${_CYAN}Please Enter the MQTT topic to subscribe data${_RESET} $_topic"
                read -p "Entered the MQTT topic_name: " _topic

# start doing stuff: preparing MQTT subsciber task script
# preparing script background work and work under reboot
echo "[*] Creating MQTT subsciber task script"

cat >/tmp/loractl.py <<EOL
#!/usr/bin/env python3
import time
import paho.mqtt.client as mqtt
import os
# This is the Subscriber

def on_connect(client, userdata, flags, rc):
  print("Connected with result code "+str(rc))
  client.subscribe("$_topic")

def on_message(client, userdata, msg):
#  msg_rx = str(msg.payload.decode("utf-8"))
#  if (msg.payload == '0'):
#    print("rebooting")
#    time.sleep(5)
#    os.system('sudo reboot')
#  else :
    print("message received " ,str(msg.payload.decode("utf-8")))
    print("message topic=",msg.topic)
    print("message qos=",msg.qos)
    print("message retain flag=",msg.retain)
    print("System is stopping loRa service")
    time.sleep(1)
    os.system('sudo systemctl stop loradragino.service')
    time.sleep(5)
    os.system('sudo systemctl start loradragino.service')
#    client.disconnect()
    
client = mqtt.Client()
client.connect("$_domain",1883,60)

client.on_connect = on_connect
client.on_message = on_message

client.loop_forever()
EOL
sudo mv /tmp/loractl.py /home/pi/dragino-GPS-RPi-shield/loractl.py

echo
echo "[*] Creating MQTT subsciber shell execution script"
sudo cat >/tmp/startLoRactl.sh <<EOL
#!/bin/bash

# cd /home/pi/dragino-GPS-RPi-shield/
sudo python3 /home/pi/dragino-GPS-RPi-shield/loractl.py

EOL
sudo mv /tmp/startLoRactl.sh /home/pi/dragino-GPS-RPi-shield/startLoRactl.sh
sudo chmod 744 /home/pi/dragino-GPS-RPi-shield/startLoRactl.sh


sudo cat >/tmp/goLoRa.service <<EOL
[Unit]
Description=GPS module service
Wants=network.target
After=loradragino.service
StartLimitInterval=400
StartLimitBurst=3
[Service]
Type=simple
ExecStart=/home/pi/dragino-GPS-RPi-shield/startLoRactl.sh
Restart=on-failure
RestartSec=90
User=pi
[Install]
WantedBy=multi-user.target
EOL
sudo mv /tmp/goLoRa.service /etc/systemd/system/goLoRa.service
echo "${_YELLOW}[*] Starting goLoRa systemd service${_RESET}"
sudo chmod 664 /etc/systemd/system/goLoRa.service
sudo systemctl daemon-reload
sudo systemctl enable goLoRa.service
sudo systemctl start goLoRa.service
sleep 5
echo "${_YELLOW}To see LoRa startup service logs run \"sudo journalctl -u goLoRa -f\" command${_RESET}"
echo
echo "${_YELLOW} The MQTT rebooting protocol is ready for use.${_RESET}"
echo "${_MAGENTA}Installation Progress....setup for remote command for LoRa service :: finished${_RESET}"
echo