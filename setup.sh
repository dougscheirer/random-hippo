#!/bin/bash

# curl this script and run from /home/pi
# curl https://raw.githubusercontent.com/dougscheirer/random-hippo/master/setup.sh | bash setup.sh

function die()
{
	echo "$*"
	exit 1
}

NOSYS=0
if [ "$1" == "nosys" ] ; then
	echo "Skipping wifi, raspi-config, and apt packages"
	NOSYS=1
fi

if [ $NOSYS -eq 0 ] ; then
	# run the wlan configure script (more generic than raspi-config, works on USB wifi)
	./wifi-usb.sh 

	# run raspberry pi configuration module (for keyboard/locale/etc. configuration)
	sudo raspi-config

	# turn on sshd by default
	sudo update-rc.d ssh defaults || die "failed to enable sshd"
	sudo service ssh restart || die "failed to start sshd"

	# make sure apt is up to date and basic packages are installed
	sudo apt-get update && sudo apt-get install vim git flite alsa-utils mpg321 python-gpiozero || die "Failed to install packages"
fi

# clone the source repo
git clone https://github.com/dougscheirer/random-hippo || die "failed to get source repo"

# the rest is in random-hippo
pushd random-hippo

# copy all of the files to the correct locations
sudo cp -r etc/* /etc || die "Failed to copy /etc files"
sudo cp -r usr/* /usr || die "Failed to copy /usr files"
cp -r home/pi/* /home/pi && chown -R pi:pi /home/pi/* || die "Failed to copy /home/pi files"

# set random-hippo to run by default on startup
sudo update-rc.d random-hippo defaults || die "Failed to set random-hippo to on by default"
sudo service random-hippo start

# you should reboot now
echo "You can reboot now..."
