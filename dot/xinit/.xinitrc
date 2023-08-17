#!/usr/bin/env sh

v=/etc/X11/xinit
test -f "$v/.Xresources" && xrdb -merge "$v/.Xresources"
test -f "$v/.Xmodmap" && xmodmap "$v/.Xmodmap"

v=/etc/X11/xinit/xinitrc.d
test -d "$v" && for v in "$v"/?*.sh; do test -x "$v" && . "$v"; done
unset v

exec "$HOME/.config/bspwm/start"
