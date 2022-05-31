#!/bin/bash

/bin/echo ""
/bin/echo "===> Starting timer to turn off power mgmt ..."
# Power management appears to be disabled by default in Raspbian 9.x Stretch
#( /bin/sleep 30 && /sbin/iwconfig wlan0 power off )&

/bin/echo "===> rpi-disable-power-mgmt.sh FINISHED!"
