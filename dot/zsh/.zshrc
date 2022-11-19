#!/usr/bin/env zsh

trap 'rehash' USR1

zshaddhistory(){
    if test "$(printf "$1" | wc -l)" != 1 ||
        printf "%s" "$1" | grep -Eq -e '^(rm|rmdir|pkill)'
    then
        fc -R
        return 2
    fi
    fc -IA
}

preexec(){
    _S=$(date '+%s.%N').$3
}

precmd(){
    printf "\e[5 q" # beam shape cursor
    PS1="%B%F{%(!.1.2)}%n%f%b@%B%M%b %~ %B%F{$((RANDOM%8))}%#%f%b "
    test "$_S" && {
        local E=$(date '+%s.%N')
        local S=$(printf "%s" "$_S" | grep -Eo '^\w*\.\w*')
        local C=$(printf "%s" "$_S" | sed s/'^\w*\.\w*\.'//)
        _S=
        local Ss=$(echo "$S" | grep -Eo '^\w*')
        local Sn=$(echo "$S" | grep -Eo '[1-9]\w*$')
        test "$Sn" || Sn=0
        local Es=$(echo "$E" | grep -Eo '^\w*')
        local En=$(echo "$E" | grep -Eo '[1-9]\w*$')
        test "$En" || En=0
        local ELe=$((En < Sn))
        local ELs=$((Es - Ss - (ELe * 1)))
        local ELn=$((En - Sn + (ELe * 1000000000)))
        test "$ELs" -lt 1 || {
            printf "\e[1;32m#############################\e[0m\n"
            printf "%s\n" "$C"
            printf "\e[1;32m#############################\e[0m\n"
            date --date="@$S" '+%Y/%m/%d %H:%M:%S.%N'
            date --date="@$E" '+%Y/%m/%d %H:%M:%S.%N'
            printf "\e[1m%10d %02d:%02d:%02d.%09d\e[0m\n" \
                $((ELs/86400)) $((ELs%86400/3600)) \
                $((ELs%3600/60)) $((ELs%60)) $ELn
            printf "\e[1;32m#############################\e[0m\n"
        }
    }
}

# return status of the last command
RPS1="$(printf "\e[5C")%?"

# change cursor shape for different vi modes
zle-keymap-select(){
    case "$KEYMAP" in
        vicmd)
            printf "\e[1 q";;
        main)
            printf "\e[5 q";;
        *)
            echo "zle-keymap-select: warning: $KEYMAP"
    esac
}
zle -N zle-keymap-select

HISTFILE=~/.zsh_history
HISTSIZE=1099511627776
SAVEHIST=1099511627776

# vi mode
bindkey -v

# menu completion
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi keys in menu completion
bindkey -M menuselect "^[h" vi-backward-char
bindkey -M menuselect "^[j" vi-down-line-or-history
bindkey -M menuselect "^[k" vi-up-line-or-history
bindkey -M menuselect "^[l" vi-forward-char

# some widgets and keybinds
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M vicmd "^[j" down-line-or-beginning-search
bindkey -M vicmd "^[k" up-line-or-beginning-search

bindkey -M viins "^[h" down-line-or-beginning-search
bindkey -M viins "^[j" down-line-or-history
bindkey -M viins "^[k" up-line-or-history
bindkey -M viins "^[l" up-line-or-beginning-search

bindkey -M viins "^N" menu-complete

. "${XDG_CONFIG_HOME:-$HOME/.config}/sh/rc"
