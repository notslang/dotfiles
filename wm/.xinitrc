#!/bin/bash
systemctl --user import-environment DISPLAY XAUTHORITY

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# fix keyboard
setxkbmap -option caps:none
volnoti
exec i3
