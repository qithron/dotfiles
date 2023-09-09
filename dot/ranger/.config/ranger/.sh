which ranger > /dev/null && {

    d="$(get-user-tmp-path ranger)"
    test "$d" || d=/tmp/ranger@$(whoami)
    test -d "$d" || mkdir -p "$d" && chmod 700 "$d"
    export RANGER_TMP="$d"
    unset d

    e(){
        v="$RANGER_TMP/ranger-last-dir-ranger"
        ranger --choosedir="$v" || return
        test -f "$v" && cd "$(cat "$v")" || return
        rm -f "$v"
    }
}
