#!/bin/bash

HW_REVISION=$(cat /proc/cpuinfo | grep 'Revision' | awk '{print $3}' | sed 's/^1000//')

#
# HW_REVISION info found at: http://elinux.org/RPi_HardwareHistory
#
if [ "$HW_REVISION" = "900092" ] || [ "$HW_REVISION" = "900093" ] || [ "$HW_REVISION" = "920093" ]; then
  MODEL_ABBREV='rpiz'
elif [ "$HW_REVISION" = "9000c1" ]; then
  MODEL_ABBREV='rpizw'
else
  MODEL_ABBREV='rpi'
fi

SERIAL_NUM=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2 | sed 's/^0*//'`

NEW_HOSTNAME=${MODEL_ABBREV}-${SERIAL_NUM}

/bin/echo ""
/bin/echo "===> Setting hostname to: ${NEW_HOSTNAME} ..."
/bin/bash -c "/bin/echo '${NEW_HOSTNAME}' > /etc/hostname"
/bin/sed -i "s/\(.*\)raspberrypi/\1${NEW_HOSTNAME}/g" /etc/hosts
hostname ${NEW_HOSTNAME}

/bin/echo "===> rpi-hostname.sh FINISHED!"
