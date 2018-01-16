#!/bin/sh
echo "Running start.sh ..."
# ensure lcd_rotate=2 is set in boot partition config (leave file cookie once done to avoid mounting to check each time!)
checkfile="/home/pitablet/screen_orientation_fixed"
if [ ! -f "$checkfile" ]
then
	echo "Fixing screen orientation ..."
	mkdir /boot_tmp
	mount /dev/mmcblk0p1 /boot_tmp
	sed -i "s/#display_rotate=0/lcd_rotate=2/g" /boot_tmp/config.txt
	umount /boot_tmp
	rm -rf /boot_tmp
	touch $checkfile
	echo "*** PLEASE PERFORM HARD REBOOT OF DEVICE ***"
fi
echo "Done!"
