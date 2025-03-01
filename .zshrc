export ZSHLVL="$(expr "${ZSHLVL:-0}" + 1)"

get_cwd_home_aware() {
    local d="${PWD/#$HOME/~}"
    test "$d" = '~' && d="$d/"
    echo "$d"
}

set_window_title() {
    printf "\e]0;%s\x07" "$1"
}

preexec() {
    local v

    # history handling because builtin fc is confusing
    command_name="$(echo "$2" |
        sed 's/^sudo \+//' | grep -ao '^[^ ]\+' | head -n 1)"
    cmd-count-db "$command_name" &!

    v=$(
        echo ' rm rmdir kill pkill exit poweroff reboot chmod chown e ' |
            grep -Fq " $command_name " && exit

        if test "$(echo "$1" | wc -l)" -eq 1; then
            echo "$1"
        else
            printf '%s' "$2" | sed ':a;N;$!ba;s/\n/\\n/g'
        fi
    )

    test "$v" = "$(tail -n 1 "$HISTFILE")" || {
        echo "$v" >> "$HISTFILE"
        fc -R
    }

    # Special case for command fg. Set window title to job command line.
    v=$(
        if echo "$2" | grep -q '^\<fg\>'; then
            local job="$(echo "$2" | cut -d' ' -f2)"
            if test "$job" = fg; then
                jobs | tail -n 1
            else
                jobs "$job"
            fi | sed -E 's/^.{,7}\w*[ ]*//'
        else
            echo "$2"
        fi
    )

    set_window_title "zsh: $v"
    command_exec_time="$(date '+%s.%N').$3"
}

precmd() {
    printf "\e[?25h" # show cursor
    printf "\e[5 q" # beam shape cursor
    set_window_title "zsh: $(get_cwd_home_aware)"

    test "$command_exec_time" || return 0
    local end="$(date '+%s.%N')"
    local str="$(printf "%s" "$command_exec_time" | grep -o '^\w*\.\w*')"
    local cmd="$(printf "%s" "$command_exec_time" | sed 's/^\w*\.\w*\.//')"
    command_exec_time=

    local elapsed="$((end-str))"
    local ela_sec="$(echo "$elapsed" | cut -d. -f1)"
    test "$ela_sec" -lt 1 && return
    local ela_nan="$(echo "$elapsed" | cut -d. -f2 | grep -Eo '^.{,9}')"
    test "$ela_nan" || ela_nan=0

    printf "\e[1;32m#############################\e[0m\n"
    printf "%s\n" "$cmd"
    printf "\e[1;32m#############################\e[0m\n"
    date --date="@$str" '+%Y/%m/%d %H:%M:%S.%N'
    date --date="@$end" '+%Y/%m/%d %H:%M:%S.%N'
    printf "\e[1m%10d %02d:%02d:%02d.%09s\e[0m\n" \
        $((ela_sec/86400)) $((ela_sec%86400/3600)) \
        $((ela_sec%3600/60)) $((ela_sec%60)) $ela_nan

    echo ' e fg vim mpv mvi tmux py python man pass ' |
        grep -Fq " $command_name " || bell &!
}

zshexit() {
    # TODO: fix this in yazi
    test "$YAZI_ID" && set_window_title "yazi: $(get_cwd_home_aware)"
    sed -i 's/^[ ]*//' "$HISTFILE"

    local d="/mnt/a/data/backup"
    test "$(whoami)" = qthr -a -d "$d" -a -w "$d" && cp -au \
        ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks \
        ~/.gnupg \
        ~/.password-store \
        ~/.ssh \
        ~/av/aaa/txt \
        "$d" > /dev/null 2>&1
    return 0
}

zshaddhistory() {
    test "${#1}" -eq 1 && fc -R
    return 1
}

# history
HISTFILE=~/.zhistory
HISTSIZE=999999999999
SAVEHIST=$HISTSIZE
HIST_FIND_NO_DUPS=1 # TODO not work

# vi mode
bindkey -v

# change cursor shape for different vi modes
zle-keymap-select() {
    case "$KEYMAP" in
        vicmd)
            printf "\e[1 q";;
        main)
            printf "\e[5 q";;
        *)
            echo "zle-keymap-select: warning: $KEYMAP" 1>&2
    esac
}
zle -N zle-keymap-select

# menu completion
zstyle ':completion:*' menu select
zmodload zsh/complist
autoload -Uz compinit
compinit
_comp_options+=(globdots)

# vi keys in menu completion
bindkey -M menuselect "^h" vi-backward-char
bindkey -M menuselect "^j" vi-down-line-or-history
bindkey -M menuselect "^k" vi-up-line-or-history
bindkey -M menuselect "^l" vi-forward-char

# keybinds
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M viins "^p" down-line-or-beginning-search
bindkey -M viins "^n" up-line-or-beginning-search

command_exists yazi && e() {
    local v="$(get-tmpfs-path yazi-cwd-file)"
    yazi --cwd-file "${v:?}"
    test -f "$v" || return 0
    v=$(cat "$v" && rm -f "$v")
    test "$v" = "$PWD" && return
    cd "$v"
}

command_exists emerge && alias -g emerge-upgrade='emerge -DNnUu @world'

alias c='date "+%Y/%m/%d %T"'
alias d='cal -y; echo; date "+%A, %d %B %Y -- %T"'

alias cdr='cd "$(realpath "$(pwd)")"'
alias cdb='cd ~/.local/bin'
alias cds='cd ~/img/ss'
alias cdq='cd ~/repo/github/qithron'

alias grep='grep --color=auto'
alias ls='ls -als --time-style=long-iso --color=auto --group-directories-first'
alias mkdir-current-time-local='mkdir -v "$(date +%Y%m%d%H%M%S)"'
alias mkdir-current-time='mkdir -v "$(date -u +%Y%m%d%H%M%S)"'
alias rehash-all='pkill -u "$USER" -SIGUSR1 zsh'
