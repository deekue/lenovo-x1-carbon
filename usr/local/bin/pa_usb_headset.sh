#!/bin/bash
#
# set the most recently connected usb device to default audio sink/source in
# PulseAudio
#
# this script can be run by a user or via udev
# it doesn't take params as udev and PulseAudio identify devices in different ways
# so we either hardcode the device or assume it's the most recently created sound card
LOG=/tmp/$(basename -- "$0").$LOGNAME.log

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
INPUT_DEVICE=
OUTPUT_DEVICE=
if [ -z "$INPUT_DEVICE" ] ; then
  INPUT_DEVICE=$(pactl list short sources | grep alsa_input.usb | tail -1 | cut -f2 -d'	')
fi
if [ -z "$OUTPUT_DEVICE" ] ; then
  OUTPUT_DEVICE=$(pactl list short sinks | grep alsa_output.usb | tail -1 | cut -f2 -d'	')
fi

if [ -z "$INPUT_DEVICE" ] ; then
  echo "INPUT_DEVICE not defined and USB device not found" >> $LOG
else
  echo "$(date +%Y%m%d%H%S): setting $INPUT_DEVICE to primary source" >> $LOG
  /usr/bin/pacmd set-default-source $INPUT_DEVICE    >> $LOG
  /usr/bin/pacmd suspend-source     $INPUT_DEVICE 0  >> $LOG
fi

if [ -z "$OUTPUT_DEVICE" ] ; then
  echo "OUTPUT_DEVICE not defined and USB device not found" >> $LOG
else
  echo "$(date +%Y%m%d%H%S): setting $OUTPUT_DEVICE to primary sink" >> $LOG
  /usr/bin/pacmd set-default-sink   $OUTPUT_DEVICE   >> $LOG
  /usr/bin/pacmd suspend-sink       $OUTPUT_DEVICE 0 >> $LOG
fi
