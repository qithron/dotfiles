#!/usr/bin/env sh

sxhkd -c "$BSPWM_HOME/sxhkdrc"
sleep 1
exec "$0" "$@"
