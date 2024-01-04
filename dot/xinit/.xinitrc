#!/usr/bin/env sh

cd ~ || exit 1

v=/etc/X11/xinit
test -f "$v/.Xresources" && xrdb -merge "$v/.Xresources"
test -f "$v/.Xmodmap" && xmodmap "$v/.Xmodmap"

v=/etc/X11/xinit/xinitrc.d
test -d "$v" && for v in "$v"/?*.sh; do test -x "$v" && . "$v"; done
unset v

xinput set-prop 12 337 1
xinput set-prop 12 345 0

exec "$HOME/.config/bspwm/start"
