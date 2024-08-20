#!/bin/dash

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

MIMETYPE=$(file --dereference --mime-type --brief -- "$FILE_PATH")

test "$PV_IMAGE_ENABLED" = 'True' && {
    _convert(){
        convert "$1"'[0]' -filter point -resize 720x720 "$IMAGE_CACHE_PATH"
    }

    case "$MIMETYPE" in
        image/svg+xml)
            _convert "$FILE_PATH" && exit 6;;

        image/*)
            v=$(identify -format '%w %h' "$FILE_PATH")
            w=$(echo "$v" | cut -d ' ' -f1)
            h=$(echo "$v" | cut -d ' ' -f2)

            test "$(stat --printf '%s' "$FILE_PATH")" -le 4194304 && exit 7
            test "$w" -le 1280 -a "$h" -le 1280 && exit 7
            _convert "$FILE_PATH" && exit 6;;

        font/*|\
        application/x-font-pfm|\
        application/vnd.ms-opentype)
            tmp="$(mktemp -p "$XDG_CACHE_HOME").png"

            fontimage --pixelsize 40 --fontname --pixelsize 30 \
                      --text " ABCDEFGHIJKLMNOPQRSTUVWXYZ " \
                      --text " abcdefghijklmnopqrstuvwxyz " \
                      --text " !\"#$%&'()*+,-./: " \
                      --text " ;<=>?@[\]^_\`{|}~ " \
                      --text " 0123456789 " \
                      -o "$tmp" "$FILE_PATH" &&
                _convert "$tmp" && rm -f "$tmp" && exit 6;;
    esac
}

header() {
    printf "\033[1;31m%s\033[0m\n" "$MIMETYPE"
}

match() {
    case "$MIMETYPE" in
        application/x-rar)
            header
            unrar lt -p- -- "$FILE_PATH" &&
            exit 5;;

        application/zip)
            header
            unzip -v -- "$FILE_PATH" &&
                exit 5;;

        application/x-7z-compressed)
            7z l "$FILE_PATH" &&
            exit 5;;

        application/gzip|\
        application/x-xz|\
        application/x-tar|\
        application/zstd)
            header
            tar --warning=none -t -f "$FILE_PATH" &&
            exit 5;;

        application/x-bittorrent)
            header
            torrent-info -- "$FILE_PATH" &&
            exit 5;;

        video/*|\
        audio/*|\
        image/*)
            header
            mediainfo -- "$FILE_PATH" &&
            exit 5;;

        text/*|\
        application/json|\
        application/javascript|\
        application/x-shellscript|\
        */xml)
            header
            head -n $((HEIGHT*9)) "$FILE_PATH" | cut -b "-$WIDTH" &&
            exit;;
    esac

    return 1
}

unknown_mime() {
    header
    printf "\033[1;33m%s\033[0m\n" "$(file -Lbs -- "$FILE_PATH")"
    stat -L -- "$FILE_PATH"
    exit
}

match || {
    EXT=$(basename "$FILE_PATH" | grep -o '\.[^.]*$' |
        tr '[:upper:]' '[:lower:]' | cut -d '.' -f 2)

    case "$EXT" in
        torrent)
            MIMETYPE=application/x-bittorrent;;
    esac

    match || unknown_mime
}

exit 1
