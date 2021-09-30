# PiTablet
Handheld tablet built around the Raspberry Pi 3 B+ + 7" touchscreen, as a Docker container with Resin support

## Prerequisites:
1. Raspberry Pi 3 B+ (https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/)
1. Raspberry Pi 7" touchscreen (https://www.raspberrypi.org/products/raspberry-pi-touch-display/)
1. PiCAN2 HAT (https://www.skpang.co.uk/collections/hats/products/pican2-can-bus-board-for-raspberry-pi-2-3)
1. Adafruit PowerBoost 1000 Charger (https://www.adafruit.com/product/2465)
1. Lithion Ion Polymer Battery, 3.7V (https://www.adafruit.com/product/5035)
1. SD card running Raspberry Pi OS (https://www.raspberrypi.org/software/)

## Installation:
1. Ensure all packages are up to date:  
	`sudo apt update`  
	`sudo apt upgrade`
1. Install environment dependencies:  
	`sudo apt install unclutter vim`  
	`sudo apt python3-gi python3-gi-cairo gir1.2-gtk-3.0`
1. Add the following lines to the `/boot/config.txt` file and reboot:  
	`dtparam=spi=on`  
	`dtoverlay=mcp2515-can0,oscillator=16000000,interrupt=25`  
	`dtoverlay=spi-bcm2835-overlay`
1. Clone this repo to your device:  
	`cd ~`  
	`git clone https://github.com/JWhitakerMcRae/PiTablet.git`
1. Install required pip packages:  
  `cd ~/PiTablet`  
	`pip3 install -r requirements.txt`
1. Set the splashscreen:  
	`cd /usr/share/plymouth/themes/pix/`  
	`sudo cp splash.png splash.orig.png`  
	`sudo cp ~/PiTablet/assets/splash.png splash.png`
1. Add the following lines to the `/etc/xdg/lxsession/LXDE-pi/autostart` file and reboot:  
	`@unclutter -idle 0`  
	`@/home/pi/PiTablet/main_gtk.py`

## Notes:
* N/A

Created in part using example code (with the same MIT license) found in:  
[https://github.com/skpang/PiCAN-Python-examples](https://github.com/skpang/PiCAN-Python-examples)
