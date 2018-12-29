#!/bin/bash

SSID=$1
PASS=$2

if [ "$SSID" == "" ] || [ "$PASS" == "" ] ; then
	echo -n SSID: 
	read SSID
	echo

	echo -n Password: 
	read -s PASS
	echo
fi


if [ "$SSID" == "" ] || [ "$PASS" == "" ] ; then
	echo "need SSID and password" && exit 1
fi

EXISTS=$(sudo grep $SSID /etc/wpa_supplicant/wpa_supplicant.conf)
if [ ! "$EXISTS" == "" ] ; then
	echo "$SSID is already configured in /etc/wpa_supplicant/wpa_supplicant.conf" && exit 0
fi

NETBLOCK=$(wpa_passphrase $SSID $PASS | sed 's/#psk=.*//g')
sudo tee "/etc/wpa_supplicant/wpa_supplicant.conf" > /dev/null <<EOF
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

$NETBLOCK
EOF

# reconfigure
sudo wpa_cli reconfigure
