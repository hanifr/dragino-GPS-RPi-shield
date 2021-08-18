# dragino-GPS-RPi-shield
 bot to automate the deployment of gps data acquisition ON raspberry pi 4
 # Use Raspberry Terminal

 ## 0 - Enable SPI and Serial Port by using the following command
```
sudo raspi-config
```
## 1 - Change setup for /boot/cmdline.txt to the following
```
sudo nano /boot/cmdline.txt
+++++++++++++++++++++++++++
dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait
+++++++++++++++++++++++++++
```

 ## 2 - Execute Main script
```
git clone https://github.com/hanifr/dragino-GPS-RPi-shield.git
cd dragino-GPS-RPi-shield
./init.sh
```
## 3 - Disable HCIUART
```
./hciuartdisable.sh
```

## 4 - Optional: Run GPS and LoRa services on boot
```
./startup.sh
```

## 5 - Optional: Run Node-red on boot
```
./initnodered.sh
```
