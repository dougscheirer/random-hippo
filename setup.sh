#!/bin/bash

# this script is incomplete

# make sure to run as sudo

function die()
{
	echo "$*"
	exit 1
}

# set a password

# turn on sshd by default

# run raspberry pi configuration module (for keyboard configuration)
raspi-config

# copy all of the files to the correct locations
cp -r etc /etc || die "Failed to copy /etc files"
cp -r usr /usr || die "Failed to copy /usr files"
cp -r home/pi /home/pi && chown pi:pi /home/pi/* || die "Failed to copy /home/pi files"

# install festival, amixer (?)
apt-get install -y festival amixer mpg321 audsp || die "Failed to install packages"

# configure wifi (https://learn.adafruit.com/adafruits-raspberry-pi-lesson-3-network-setup/setting-up-wifi-with-occidentalis)
echo -n "Enter your SSID: "
read SSID
echo -n "Enter your password: "
read -s PASSWORD

cat << EOF >> /etc/network/interfaces

allow-hotplug wlan0
auto wlan0

iface wlan0 inet dhcp
        wpa-ssid "$SSID"
        wpa-psk "$PASSWORD"
EOF

# set random-hippo to run by default on startup
update-rc.d random-hippo defaults || die "Failed to set random-hippo to on by default"

# you should reboot now
echo "You can reboot now..."
