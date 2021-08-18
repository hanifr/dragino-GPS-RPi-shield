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
echo "${_MAGENTA}Installation Progress....set local time to Kuala Lumpur${_RESET}"
echo
sudo timedatectl set-timezone Asia/Kuala_Lumpur
. primary.sh
# Installation of Python Dependencies and GPS Libaries
echo "${_MAGENTA}Installation Progress...installation of GPS Python Library${_RESET}"
echo
sudo pip3 install adafruit-circuitpython-gps
sudo pip3 install board

echo "${_MAGENTA}Installation Progress....installation of MQTT PAHO${_RESET}"
echo
git clone https://github.com/eclipse/paho.mqtt.python.git
cd ./paho.mqtt.python
sudo python setup.py install

sleep 5
echo "${_CYAN}Please Enter the MQTT domain_name${_RESET} $_domain"
                read -p "Enter the MQTT domain_name: " _domain
echo
echo "${_CYAN}Please Enter the MQTT topic to publish data${_RESET} $_topic"
                read -p "Enter the MQTT topic_name: " _topic
echo
echo "${_CYAN}You have entered $_domain for MQTT server and $_topic for the topic${_RESET}"

# start doing stuff: preparing script for GPS data acquisition
# preparing script background work and work under reboot
echo "[*] Creating GPS data acquisition script"

cat >/tmp/gps_simple.py <<EOL
# SPDX-FileCopyrightText: 2021 ladyada for Adafruit Industries
# SPDX-License-Identifier: MIT

# Simple GPS module demonstration.
# Will wait for a fix and print a message every second with the current location
# and other details.
import time
import board
import busio

import adafruit_gps

import context  # Ensures paho is in PYTHONPATH
import paho.mqtt.publish as publish
import json

# Create a serial connection for the GPS connection using default speed and
# a slightly higher timeout (GPS modules typically update once a second).
# These are the defaults you should use for the GPS FeatherWing.
# For other boards set RX = GPS module TX, and TX = GPS module RX pins.
#uart = busio.UART(board.TX, board.RX, baudrate=9600, timeout=10)

# for a computer, use the pyserial library for uart access
import serial
uart = serial.Serial("/dev/ttyS0", baudrate=9600, timeout=10)

# If using I2C, we'll create an I2C interface to talk to using default pins
# i2c = board.I2C()

# Create a GPS module instance.
gps = adafruit_gps.GPS(uart, debug=False)  # Use UART/pyserial
# gps = adafruit_gps.GPS_GtopI2C(i2c, debug=False)  # Use I2C interface

# Initialize the GPS module by changing what data it sends and at what rate.
# These are NMEA extensions for PMTK_314_SET_NMEA_OUTPUT and
# PMTK_220_SET_NMEA_UPDATERATE but you can send anything from here to adjust
# the GPS module behavior:
#   https://cdn-shop.adafruit.com/datasheets/PMTK_A11.pdf

# Turn on the basic GGA and RMC info (what you typically want)
gps.send_command(b"PMTK314,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
# Turn on just minimum info (RMC only, location):
# gps.send_command(b'PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
# Turn off everything:
# gps.send_command(b'PMTK314,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
# Turn on everything (not all of it is parsed!)
# gps.send_command(b'PMTK314,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0')

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
#        print("=" * 40)  # Print a separator line.
#        print(
#            "Fix timestamp: {}/{}/{} {:02}:{:02}:{:02}".format(
#                gps.timestamp_utc.tm_mon,  # Grab parts of the time from the
#                gps.timestamp_utc.tm_mday,  # struct_time object that holds
#                gps.timestamp_utc.tm_year,  # the fix time.  Note you might
#                gps.timestamp_utc.tm_hour,  # not get all data like year, day,
#                gps.timestamp_utc.tm_min,  # month!
#                gps.timestamp_utc.tm_sec,
#            )
#        )
        LAT = "{0:.6f}".format(gps.latitude)
        LON = "{0:.6f}".format(gps.longitude)
        FIX = "Fix quality: {}".format(gps.fix_quality)
        
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
#        print ({LAT, LON})
        publish.single("$_topic", "{\"GID\":" + "301" + ",\"LAT\":"+LAT+",\"LON\":"+ LON +"}", hostname="$_domain")
EOL
sudo mv /tmp/gps_simple.py /home/pi/dragino-GPS-RPi-shield/paho.mqtt.python/examples/gps_simple.py

sleep 5
echo
echo "${_YELLOW} The GPS is ready for use.${_RESET}"
echo "${_YELLOW} use Node-Red to invoke the GPS data.${_RESET}"
echo "${_YELLOW} Please import gps.json into Node-Red.${_RESET}"
echo
sleep 5