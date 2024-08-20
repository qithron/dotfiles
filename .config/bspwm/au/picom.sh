#!/usr/bin/env sh

picom -f -o 0 -D 7
sleep 1
exec "$0" "$@"
