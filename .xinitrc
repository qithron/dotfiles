#!/bin/sh

cd ~ || exit

v=/etc/X11/xinit
test -f "$v/.Xresources" && xrdb -merge "$v/.Xresources"
test -f "$v/.Xmodmap" && xmodmap "$v/.Xmodmap"
v=/etc/X11/xinit/xinitrc.d
test -d "$v" &&
    for v in "$v"/?*.sh; do
        test -x "$v" && . "$v"
    done
unset v

(
    id=$(xinput list | grep Touchpad | grep -Eo 'id=[0-9]*' | cut -d '=' -f 2)
    test "$id" || exit
    xinput set-prop "$id" 'libinput Tapping Enabled' 1
    xinput set-prop "$id" 'libinput Disable While Typing Enabled' 0
)

exec "$XDG_CONFIG_HOME/bspwm/start"
