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

echo "${_MAGENTA}Installation Progress....setup for for Dragino GPS data acquisition protocol :: started${_RESET}"
echo
sleep 5
chmod +x initnodered.sh
chmod +x primary.sh
chmod +x hciuartdisable.sh
. primary.sh
# Installation of Python Dependencies and GPS Libaries
sudo pip3 install adafruit-circuitpython-gps
sudo pip3 install board

git clone https://github.com/eclipse/paho.mqtt.python.git
cd paho.mqtt.python
sudo python setup.py install

sleep 5
echo "${_CYAN}Please Enter the MQTT domain_name${_RESET} $_domain"
                read -p "Enter the MQTT domain_name: " _domain
echo
echo "${_CYAN}You have entered $_domain for your MQTT domain name${_RESET}"

# start doing stuff: preparing script for GPS data acquisition
# preparing script background work and work under reboot
echo "[*] Creating GPS data acquisition script"

cat >/tmp/gps_simple.py <<EOL
import time
import board
import busio

import adafruit_gps

import context  # Ensures paho is in PYTHONPATH
import paho.mqtt.publish as publish

# for a computer, use the pyserial library for uart access
import serial
uart = serial.Serial("/dev/ttyS0", baudrate=9600, timeout=10)

# Create a GPS module instance.
gps = adafruit_gps.GPS(uart, debug=False)  # Use UART/pyserial

# Set update rate to once a second (1hz) which is what you typically want.
gps.send_command(b"PMTK220,1000")
# Or decrease to once every two seconds by doubling the millisecond value.
# Be sure to also increase your UART timeout above!
# gps.send_command(b'PMTK220,2000')
# You can also speed up the rate, but don't go too fast or else you can lose
# data during parsing.  This would be twice a second (2hz, 500ms delay):
# gps.send_command(b'PMTK220,500')

# Main loop runs forever printing the location, etc. every second.
last_print = time.monotonic()
while True:
    # Make sure to call gps.update() every loop iteration and at least twice
    # as fast as data comes from the GPS unit (usually every second).
    # This returns a bool that's true if it parsed new data (you can ignore it
    # though if you don't care and instead look at the has_fix property).
    gps.update()
    # Every second print out current location details if there's a fix.
    current = time.monotonic()
    if current - last_print >= 1.0:
        last_print = current
        if not gps.has_fix:
            # Try again if we don't have a fix yet.
            print("Waiting for fix...")
            continue
        # We have a fix! (gps.has_fix is true)
        # Print out details about the fix like location, date, etc.

        LAT = "{0:.6f}".format(gps.latitude)
        LON = "{0:.6f}".format(gps.longitude)
        print("Fix quality: {}".format(gps.fix_quality))
        
        # Some attributes beyond latitude, longitude and timestamp are optional
        # and might not be present.  Check if they're None before trying to use!
#        if gps.satellites is not None:
        SAT = "Satellites: {}".format(gps.satellites)
#        if gps.altitude_m is not None:
        ALT = "Altitude: {}".format(gps.altitude_m)
#        if gps.speed_knots is not None:
        SPEED = "Speed: {}".format(gps.speed_knots)
#        if gps.track_angle_deg is not None:
        ANGLE = "Track angle: {} degrees".format(gps.track_angle_deg)
#        if gps.horizontal_dilution is not None:
#        HDIL = "Horizontal dilution: {}".format(gps.horizontal_dilution)
#        if gps.height_geoid is not None:
#        HGEO = "Height geo ID: {} meters".format(gps.height_geoid)
        #STR = '{'+ LAT + ','+ LON + '}'
        print ({LAT, LON})
        publish.single("$_domain", "{\"LAT\":" + LAT+ ",\"LON\":"+ LON +"}", hostname="nex.airmode.live")
EOL
sudo mv /tmp/gps_simple.py /home/pi/paho.mqtt.python/examples/gps_simple.py

sleep 5
   echo
echo "${_YELLOW} The GPS is ready for use.${_RESET}"
sleep 5