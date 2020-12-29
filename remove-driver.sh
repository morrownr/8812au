#!/bin/bash

DRV_NAME="rtl8812au"
DRV_VERSION="5.9.3.2"
OPTIONS_FILE="8812au.conf"

KRNL_VERSION="$(uname -r)"
SCRIPT_NAME="remove-driver.sh"

if [[ $EUID -ne 0 ]]; then
	echo "You must run this script with superuser (root) privileges."
	echo "Try \"sudo ./${SCRIPT_NAME}\""
	exit 1
fi

dkms remove ${DRV_NAME}/${DRV_VERSION} --all
RESULT=$?

if [[ "$RESULT" != "0" ]]; then
	echo "An error occurred while running: dkms remove : ${RESULT}"
	exit $RESULT
else
	rm -f /etc/modprobe.d/${OPTIONS_FILE}
	rm -rf /usr/src/${DRV_NAME}-${DRV_VERSION}
	echo "The driver was removed successfully."
	exit 0
fi
