#!/bin/bash

DRV_NAME=rtl8812au
DRV_VERSION=5.6.4.2

if [[ $EUID -ne 0 ]]; then
  echo "You must run this installation script with superuser priviliges."
  echo "Try \"sudo ./dkms-remove.sh\""
  exit 1
fi

dkms remove ${DRV_NAME}/${DRV_VERSION} --all
RESULT=$?

if [[ "$RESULT" != "0" ]]; then
  echo "An error occurred while running dkms remove"
  exit $RESULT
else
	echo ""
	echo "Removing /etc/modprobe.d/8812au.conf"
	rm -f /etc/modprobe.d/8812au.conf
	echo ""
	echo "Removing /usr/src/${DRV_NAME}-${DRV_VERSION)"
	rm -rf /usr/src/${DRV_NAME}-${DRV_VERSION}
	echo "dkms-remove.sh was successful."
fi
