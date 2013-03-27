#!/bin/sh
#
# Ref:
# http://www.thinkwiki.org/wiki/How_to_configure_acpid#Make_the_Microphone_Mute_button_work
# http://askubuntu.com/questions/125367/enabling-mic-mute-button-and-light-on-lenovo-thinkpads/137278#137278

INPUT_DEVICE=Capture

# If running as root from ACPI or udev, switch to the X11 user.
X_USER=$(who | sed -n '/:[0-9]\W/{s/ .*//p;q}')
if [ "$X_USER" ] && [ "$LOGNAME" != "$X_USER" ]; then
    exec su "$X_USER" -c "$0 $*"
fi

if [ ! "$DISPLAY" ]; then
    export DISPLAY="$(who | sed -n '/:[0-9]\W/{s/.*(\([^)]*\))/\1/p;q}')"
fi

amixer sset $INPUT_DEVICE,0 toggle
if amixer sget $INPUT_DEVICE,0 | grep '\[on\]' ; then
    notify-send -t 20 -i microphone-sensitivity-muted-symbolic "Mic MUTED"
    #echo "0 blink" > /proc/acpi/ibm/led
else
    notify-send -t 20 -i microphone-sensitivity-high-symbolic "Mic ON"
    #echo "0 on" > /proc/acpi/ibm/led 
fi
