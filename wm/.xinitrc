#!/bin/bash
systemctl --user import-environment DISPLAY XAUTHORITY

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# fix keyboard
setxkbmap -option caps:none
xinput set-prop "DELL08B6:00 044E:120A Touchpad" "libinput Natural Scrolling Enabled" 1
xinput set-prop "DELL08B6:00 044E:120A Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "DELL08B6:00 044E:120A Touchpad" "libinput Disable While Typing Enabled" 0

volnoti
exec i3
