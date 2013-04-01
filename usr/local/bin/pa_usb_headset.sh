#!/bin/bash
#
# set the most recently connected usb device to default audio sink/source in
# PulseAudio
#
# this script can be run by a user or via udev
# it doesn't take params as udev and PulseAudio identify devices in different ways
# so we either hardcode the device or assume it's the most recently created sound card

# If running as root from ACPI or udev:
# - switch to the X11 user 
# - fork to let udev keep running
X_USER=$(who | sed -n '/:[0-9]\W/{s/ .*//p;q}')
if [ "$X_USER" ] && [ "$LOGNAME" != "$X_USER" ]; then
    { su "$X_USER" -c "$0 $*" > /dev/null 2>&1 < /dev/null & } &
    exit 0
fi

/bin/sleep 2 # wait for PulseAudio to "see" the new device

# hard code a device here or leave blank to auto-discover
DEVICE=
if [ -z "$DEVICE" ] ; then
  DEVICE=$(pactl list short sinks | sed -ne '$ s/^[0-9]*	alsa_output.\(usb[^	]*\)	.*$/\1/p')
  [ -z "$DEVICE" ] && exit 0 # not a USB device, giving up
fi

/usr/bin/pacmd set-default-source alsa_input.$DEVICE    > /dev/null
/usr/bin/pacmd suspend-source     alsa_input.$DEVICE 0  > /dev/null
/usr/bin/pacmd set-default-sink   alsa_output.$DEVICE   > /dev/null
/usr/bin/pacmd suspend-sink       alsa_output.$DEVICE 0 > /dev/null
