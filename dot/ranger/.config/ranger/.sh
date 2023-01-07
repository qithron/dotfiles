test -x /usr/bin/ranger && {
d="$(get-user-tmp-path ranger)"
test "$d" || d=/tmp/ranger@$(whoami)
[ -d "$d" ] || mkdir -p "$d" && chmod 700 "$d"
export RANGER_TMP="$d"
unset d

e() {
    ranger --choosedir="$RANGER_TMP/ranger-last-dir-ranger" || return
    test -f "$RANGER_TMP/ranger-last-dir-ranger" || return
    cd "$(cat "$RANGER_TMP/ranger-last-dir-ranger")" || return
    rm -f "$RANGER_TMP/ranger-last-dir-ranger"
}
}
