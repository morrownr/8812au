#!/bin/bash

DRV_NAME=rtl8812au
DRV_VERSION=5.9.3.2

if [ $EUID -ne 0 ]
then
	echo "You must run dkms-install.sh with superuser priviliges."
	echo "Try: \"sudo ./dkms-install.sh\""
	exit 1
fi

if [ -d "/usr/lib/dkms" ]
then
	echo "dkms appears to be installed."
else
	echo "dkms does not appear to be installed."
	echo "Try: \"sudo apt install dkms\""
	exit 1
fi

echo ""
echo "Copying driver to: /usr/src/${DRV_NAME}-${DRV_VERSION}"
cp -r $(pwd) /usr/src/${DRV_NAME}-${DRV_VERSION}

echo ""
echo "Copying 8812au.conf to: /etc/modprobe.d"
cp -r 8812au.conf /etc/modprobe.d

dkms add -m ${DRV_NAME} -v ${DRV_VERSION}
RESULT=$?

if [ "$RESULT" != "0" ]
then
	echo "An error occurred while running: dkms add"
	exit 1
else
	echo "dkms add was successful."
fi

dkms build -m ${DRV_NAME} -v ${DRV_VERSION}
RESULT=$?

if [ "$RESULT" != "0" ]
then
	echo "An error occurred while running: dkms build"
	exit 1
else
	echo "dkms build was successful."
fi

dkms install -m ${DRV_NAME} -v ${DRV_VERSION}
RESULT=$?

if [ "$RESULT" != "0" ]
then
	echo "An error occurred while running: dkms install"
	exit 1
else
	echo "dkms install was successful."
fi

