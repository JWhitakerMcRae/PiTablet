#!/bin/sh
echo "Running start.sh ..."
# Ensure lcd_rotate=2 is NOT set in boot partition config (leave file cookie once done to avoid mounting to check each time!)
mkdir /boot_tmp
mount /dev/mmcblk0p1 /boot_tmp
sed -i "s/lcd_rotate=2/#display_rotate=0/g" /boot_tmp/config.txt
umount /boot_tmp
rm -rf /boot_tmp
# Start app
#FIXME python3 /app/main.py