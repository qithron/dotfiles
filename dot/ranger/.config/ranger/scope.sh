#!/usr/bin/env sh

set -o noclobber -o noglob -o nounset

# code | meaning    | action of ranger
# -----+------------+------------------
# 0    | success    | Display stdout as preview
# 1    | no preview | Display no preview at all
# 2    | plain text | Display the plain content of the file
# 3    | fix width  | Don't reload when width changes
# 4    | fix height | Don't reload when height changes
# 5    | fix both   | Don't ever reload
# 6    | image      | Display the IMAGE_CACHE_PATH as an image
# 7    | image      | Display the file directly as an image

FILE_PATH=$1        # Full path of the highlighted file
WIDTH=$2            # Width of the preview pane (number of fitting characters)
HEIGHT=$3           # Height of the preview pane (number of fitting characters)
IMAGE_CACHE_PATH=$4 # Full path that should be used to cache image preview
PV_IMAGE_ENABLED=$5 # 'True' if image previews are enabled, 'False' otherwise.

EXTENSION=$(printf "%s" "${FILE_PATH##*.}" | tr '[:upper:]' '[:lower:]')
MIMETYPE=$(file --dereference --brief --mime-type -- "$FILE_PATH")

test "$PV_IMAGE_ENABLED" = 'True' && {
    _convert(){
        convert "$1" -filter point -resize 512x512 \
            "$IMAGE_CACHE_PATH"
    }
    case "$MIMETYPE" in
        image/*)
            _convert "$FILE_PATH"'[0]' && exit 6;;
        font/*|\
        application/x-font-pfm|\
        application/vnd.ms-opentype)
            preview_png="/tmp/$(basename "${IMAGE_CACHE_PATH%.*}").png"
            fontimage --pixelsize 40 --fontname --pixelsize 30 \
                      --text " ABCDEFGHIJKLMNOPQRSTUVWXYZ " \
                      --text " abcdefghijklmnopqrstuvwxyz " \
                      --text " !\"#$%&'()*+,-./: " \
                      --text " ;<=>?@[\]^_\`{|}~ " \
                      --text " 0123456789 " \
                      -o "$preview_png" "$FILE_PATH" &&
            _convert "$preview_png"
            rm "$preview_png" && exit 6;;
    esac
}

printf "\033[1;32m%s\033[0m\n" "$MIMETYPE"

#case "$EXTENSION" in
#    a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
#    rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip|zst|\
#    7z|rar)
#        { tar --list -f "$FILE_PATH" && exit 5;} ||
#        echo 'tar: failed'
#esac

case "$MIMETYPE" in
    application/x-rar)
        unrar lt -p- -- "$FILE_PATH" && exit 5;;
    application/zip)
        unzip -v -- "$FILE_PATH" && exit 5;;
    application/x-7z-compressed)
        7z l "$FILE_PATH" && exit 5;;
    application/gzip|\
    application/x-xz|\
    application/x-tar|\
    application/zstd)
        tar --warning=none -t -f "$FILE_PATH" && exit 5;;
    text/*|\
    */xml)
        head -n $((HEIGHT*9)) "$FILE_PATH" | cut -b "-$WIDTH" &&
        exit;;
    application/x-bittorrent)
        torrentinfo -- "$FILE_PATH"&&
        exit 5;;
    video/*|\
    audio/*|\
    image/*)
        mediainfo -- "$FILE_PATH" &&
        exit 5;;
    *)
        file -Lbs -- "$FILE_PATH" &&
        exit 5;;
esac

exit 1
