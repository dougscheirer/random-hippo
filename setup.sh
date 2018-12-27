#!/bin/bash

# curl this script and run from /home/pi
# curl https://raw.githubusercontent.com/dougscheirer/random-hippo/master/setup.sh | sudo bash

function die()
{
	echo "$*"
	exit 1
}

# make sure to run as root
if [ $(id -u) -ne 0 ]; then
	die "Must be run as root"
fi

# set a password for pi user
echo "Set a password for the pi user"
passwd pi

# turn on sshd by default
update-rc.d defaults ssh || die "failed to enable sshd"
service ssh restart || die "failed to start sshd"

# make sure apt is up to date and basic packages are installed
apt-get update && apt-get install vim git flite alsa-utils mpg321 python-gpiozero || die "Failed to install packages"

# clone the source repo
git clone https://github.com/dougscheirer/random-hippo || die "failed to get source repo"

# the rest is in random-hippo
pushd random-hippo

# run the wlan configure script (more generic than raspi-config, works on USB wifi)
./wifi-usb.sh 

# run raspberry pi configuration module (for keyboard and locale configuration)
raspi-config

# copy all of the files to the correct locations
cp -r etc/* /etc || die "Failed to copy /etc files"
cp -r usr/* /usr || die "Failed to copy /usr files"
cp -r home/pi/* /home/pi && chown -R pi:pi /home/pi/* || die "Failed to copy /home/pi files"

# set random-hippo to run by default on startup
update-rc.d random-hippo defaults || die "Failed to set random-hippo to on by default"
service random-hippo start

# you should reboot now
echo "You can reboot now..."
