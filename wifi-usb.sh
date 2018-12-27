#!/bin/bash

if [ $(id -u) -ne 0 ] ; then
	echo "Must run as root" && exit 1
fi

SSID=$1
PASS=$2

if [ "$SSID" == "" ] || [ "$PASS" == "" ] ; then
	echo -n SSID: 
	read -s SSID
	echo

	echo -n Password: 
	read -s PASS
	echo
fi


if [ "$SSID" == "" ] || [ "$PASS" == "" ] ; then
	echo "need SSID and password" && exit 1
fi

EXISTS=$(grep $SSID /etc/wpa_supplicant/wpa_supplicant.conf)
if [ ! "$EXISTS" == "" ] ; then
	echo "$SSID is already configured in /etc/wpa_supplicant/wpa_supplicant.conf" && exit 0
fi

NETBLOCK=$(wpa_passphrase $SSID $PASS | sed 's/#psk=.*//g')
cat <<EOF > /etc/wpa_supplicant/wpa_supplicant.conf
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

$NETBLOCK
EOF

# reconfigure
wpa_cli reconfigure
