#!/usr/bin/env python3
import time
import paho.mqtt.client as mqtt
import os
# This is the Subscriber

def on_connect(client, userdata, flags, rc):
  print("Connected with result code "+str(rc))
  client.subscribe("nexplex/control/rpi")

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
    print("System is rebooting")
    time.sleep(1)
    os.system('sudo reboot')
#    client.disconnect()
    
client = mqtt.Client()
client.connect("tron.airmode.live",1883,60)

client.on_connect = on_connect
client.on_message = on_message

client.loop_forever()