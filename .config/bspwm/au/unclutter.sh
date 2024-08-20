#!/usr/bin/env sh

unclutter --timeout 60 --jitter 5
sleep 1
exec "$0" "$@"
