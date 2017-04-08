#!/bin/sh
SETVOL="/usr/bin/amixer -q -D pulse sset Master"
STEP=5
case "$1" in
    "up")
          $SETVOL $STEP%+
          ;;
    "down")
          $SETVOL $STEP%-
          ;;
    "mute")
          $SETVOL toggle
          ;;
esac

VOLUME=$(amixer get Master | grep "Playback.*\[.*%\]" | head -1 | awk '{print $5;}' | sed 's/\[\(.*\)%\]/\1/')
STATE=$(amixer get Master | grep 'Front Left:' | grep -o "\[on\]")

# Show volume with volnoti
if [[ -n $STATE ]]; then
    volnoti-show $VOLUME
else
    volnoti-show -m
fi

exit 0
