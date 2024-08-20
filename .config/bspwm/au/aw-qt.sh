#!/usr/bin/env sh

test "$NO_LOG" && exit
aw-qt --no-gui
sleep 1
exec "$0" "$@"
