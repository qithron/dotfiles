#!/usr/bin/env sh
#
# shared config

###############################################################################
# environment

export XDG_CONFIG_HOME="$HOME/.config"
export  XDG_CACHE_HOME="$HOME/.cache"
export   XDG_DATA_HOME="$HOME/.local/share"
export  XDG_STATE_HOME="$HOME/.local/state"

export HISTCONTROL='ignoreboth:erasedups'
export HISTFILESIZE=
export HISTSIZE=
export HISTIGNORE='rm *:ls:cd:echo:e:vim:pkill *'

export PATH="$HOME/.local/bin:$HOME/.local/sbin:$PATH" # sbin = secret bin :)
export EDITOR='nvim'
export VISUAL="$EDITOR"
export PYTHONDONTWRITEBYTECODE='1'
export PYTHONPATH="$HOME/.local/lib/python/site-packages:$PYTHONPATH"
export CARGO_HOME="$HOME/.local/share/cargo"

export RANGER_TMP="$(ranger-env)"

export GIT_PAGER='cat'

###############################################################################
# aliases

alias ce='clear'
alias ls='ls -lA --color=auto --group-directories-first'
alias grep='grep --color=auto'

[ -x '/usr/bin/pacman' ] && alias pacman='pacman --verbose --color=auto'
[ -x '/usr/bin/sudo' ] && alias sudoer='/usr/bin/sudo'

alias reload-gpgAgent='echo RELOADAGENT | gpg-connect-agent'
alias aplay-noise='aplay -t raw /dev/random -d 0 -r 4000 -c 2 -N'
alias cmatrix-c='cmatrix -bru 60'
alias ss-mon='loop 2 "ss -anoHtu | sort -k5 -b"'
alias clock='date "+%Y/%m/%d %T"'
alias clock-loop='loop 60 "date +%Y/%m/%d\ %T"'

# cd
alias cdo='cd "$OLDPWD"'
alias cdrepo='cd ~/Repository/github/git/qithron'
alias cdbspwm='cd ~/.config/bspwm'
alias cdfish='cd ~/.config/fish'
alias cdnvim='cd ~/.config/nvim'
alias cdportage='cd /etc/portage'
alias cdaoped='cd /mnt/b/data/aaa/AOPED'

# other useless tobe deleted aliases
alias vist='sudo nvim /etc/portage/savedconfig/x11-terms/st-*'
alias vipackuse='cd /etc/portage; sudo nvim package.use'
