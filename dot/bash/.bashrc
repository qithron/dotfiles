#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# prompt strings
#PS1='\[\e[0m\]'
#PS1+='\[\e[1;31;47m\] \u\[\e[34m\]@\[\e[31m\]\h \[\e[33;45m\] \w \[\e[0m\]\n'
#PS1+='\[\e[0m\]\[\e[1;5;31;47m\] >>> \[\e[0m\] \$ '
#PS2='\[\e[1;5;31;47m\] ... \[\e[0m\]   '
if [[ "$(id -u)" = '0' ]]; then
    PS1='\[\e[1;31m\]'
else
    PS1='\[\e[1;32m\]'
fi
PS1+='\u\[\e[0m\]@'
if [[ "$HOSTNAME" = 'satokoi' ]]; then
    PS1+='\[\e[1;38;5;120m\]sato\[\e[1;38;5;70m\]koi'
else
    PS1+='\[\e[33m\]\h'
fi
PS1+='\[\e[0m\]:\[\e[1;33m\]\w\[\e[0m\] \n'
PS1+='\[\e[5m\]>>>\[\e[0m\] \$ '
PS2='\[\e[1;5m\]... \[\e[0m\]> '

# After each command, append to the history file and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export HISTFILESIZE=
export HISTSIZE=
export HISTIGNORE='rm *:pkill *'

shopt -s histappend
shopt -s autocd
shopt -u checkwinsize

set -o vi

bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'
bind '"\e[1;5C": menu-complete'
bind '"\e[1;5D": menu-complete-backward'

v="${XDG_CONFIG_HOME:-$HOME/.config}/sh"
if [ -d "$v" ]; then
    . "$v/rc"
fi
unset v
