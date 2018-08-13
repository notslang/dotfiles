#!  /bin/bash
systemctl --user import-environment DISPLAY XAUTHORITY
xrandr --newmode "3840x2160_30.00"  339.57  3840 4080 4496 5152  2160 2161 2164 2197  -HSync +Vsync
xrandr --addmode DisplayPort-0 3840x2160_30.00
xrandr --output DisplayPort-0 --mode 3840x2160_30.00

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# fix keyboard
setxkbmap -option caps:none
volnoti
exec i3
