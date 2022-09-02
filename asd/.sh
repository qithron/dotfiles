#!/usr/bin/env sh
#
# shared config for my shells (bash, dash, fish)

###############################################################################
# environment

export XDG_CONFIG_HOME="$HOME/.config"
export  XDG_CACHE_HOME="$HOME/.cache"
export   XDG_DATA_HOME="$HOME/.local/share"
export  XDG_STATE_HOME="$HOME/.local/state"

export EDITOR='nvim'
export VISUAL="$EDITOR"

echo "$PATH" | grep -q "$HOME/.local/bin:$HOME/.local/sbin:" ||
    export PATH="$HOME/.local/bin:$HOME/.local/sbin:$PATH"

export HISTCONTROL='ignoreboth:erasedups'
export HISTFILESIZE=
export HISTSIZE=
export HISTIGNORE='rm *:ls:cd:echo:e:vim:pkill *'

export PYTHONDONTWRITEBYTECODE='1'
echo "$PYTHONPATH" | grep -q "$HOME/.local/lib/python/site-packages:" ||
    export PYTHONPATH="$HOME/.local/lib/python/site-packages:$PYTHONPATH"

export CARGO_HOME="$HOME/.local/share/cargo"

# TODO: considering to make a special directory
# TODO:     to be sourced instead modify this file
export RANGER_TMP="$(ranger-env)"

export GIT_PAGER='cat'

###############################################################################
# aliases

alias ce='clear'
alias ls='ls -lA --color=auto --group-directories-first'
alias grep='grep --color=auto'

[ -x '/usr/bin/pacman' ] && alias pacman='pacman --verbose --color=auto'

alias reload-gpgAgent='echo RELOADAGENT | gpg-connect-agent'
alias aplay-noise='aplay -t raw /dev/random -d 0 -r 4000 -c 2 -N'
alias cmatrix-c='cmatrix -bru 60'
alias ss-loop='loop 2 "ss -anoHtu | sort -k5 -b"'
alias clock='date "+%Y/%m/%d %T"'
alias clock-loop='loop 60 "date +%Y/%m/%d\ %T"'

# cd
alias cdo='cd "$OLDPWD"'
alias cdrepo='cd ~/Repository/github/git/qithron'
alias cdbspwm='cd ~/.config/bspwm'
alias cdfish='cd ~/.config/fish'
alias cdnvim='cd ~/.config/nvim'
alias cdportage='cd /etc/portage'

# git
alias gitd='git diff'
alias gitl='git log'
alias gits='git status'
