#!/usr/bin/env sh

v='/etc/X11/xinit/xinitrc.d'
[ -d "$v" ] &&
    for v in "$v"/?*.sh; do
        [ -x "$v" ] && . "$v"
    done
unset v

exec "$HOME/.config/bspwm/start"
