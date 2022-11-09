#!/usr/bin/env zsh

zshaddhistory() {
    if echo "$1" | grep -Eq \
        -e '^rm' \
        -e '^rm ' \
        -e '^rmdir' \
        -e '^pkill' \
    ; then
        fc -R
        return 2
    else
        fc -IA
    fi
}

preexec() {
    echo "$3" | grep -Eq \
        -e '^((ls)|(cd)|(pwd)|(clear))' \
        -e '^sh-greeting' \
        && return
    _S=$(date '+%s.%N').$3
}

precmd() {
    test "$_S" || return
    local E=$(date '+%s.%N')
    local S=$(echo "$_S" | grep -Eo '^\w*\.\w*')
    local C=$(echo "$_S" | sed s/'^\w*\.\w*\.'//)
    _S=

    local Ss Sn
    Ss=$(echo "$S" | grep -Eo '^\w*')
    Sn=$(echo "$S" | grep -Eo '[1-9]\w*$')
    test "$Sn" || Sn=0

    local Es En
    Es=$(echo "$E" | grep -Eo '^\w*')
    En=$(echo "$E" | grep -Eo '[1-9]\w*$')
    test "$En" || En=0

    local ELe ELs ELn
    ELe=$((En < Sn))
    ELs=$((Es - Ss - (ELe * 1)))
    ELn=$((En - Sn + (ELe * 1000000000)))
    test "$ELs" -lt 1 && return

    #######################################################################
    printf "\033[1;32m#############################\033[0m\n"
    printf '%s\n' "$C"
    printf "\033[1;32m#############################\033[0m\n"
    date --date="@$S" '+%Y/%m/%d %H:%M:%S.%N'
    date --date="@$E" '+%Y/%m/%d %H:%M:%S.%N'
    printf "\033[1m"
    printf '%10d %02d:%02d:%02d.%09d\n' $((ELs/86400)) \
        $((ELs%86400/3600)) $((ELs%3600/60)) $((ELs%60)) $ELn
    printf "\033[1;32m#############################\033[0m\n"
}

#REPORTTIME=0
#e=$(printf '\e[')
#TIMEFMT="${e}1;32m%*E${e}0m %J"

HISTFILE=~/.zsh_history
HISTSIZE=281474976710655
SAVEHIST=281474976710655

PS1="%B%n%F{$(date +%u)}@%f%m%b %~ %# "

v="${XDG_CONFIG_HOME:-$HOME/.config}/sh"
if [ -d "$v" ]; then
    . "$v/rc"
fi
unset v
