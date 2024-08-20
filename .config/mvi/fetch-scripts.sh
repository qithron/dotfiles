#!/bin/sh
#
# src: https://github.com/occivink/mpv-image-viewer

cd "$(dirname "$(realpath "$0")")"/scripts || exit 1

url=https://raw.githubusercontent.com/occivink/mpv-image-viewer/master/scripts
curl -O "$url/{\
detect-image.lua,\
equalizer.lua,\
freeze-window.lua,\
image-positioning.lua,\
minimap.lua,\
ruler.lua,\
status-line.lua}"
