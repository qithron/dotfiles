test "$ZSH_VERSION" && {  # actually, this shouldn't be done
    alias rehash-all='pkill -x -e -u "$USER" zsh -SIGUSR1'
    alias -g pacman='pacman --verbose --color=auto'
    alias -g emerge-upgrade='emerge -DNnUu @world'
}

alias ce='clear'
alias ls='ls -als --color=auto --group-directories-first'
alias grep='grep --color=auto'

alias reload-gpgAgent='echo RELOADAGENT | gpg-connect-agent'
alias aplay-noise='aplay -t raw /dev/random -r 4000 -c 2 -N'
alias cmatrix-c='cmatrix -bru 60'
alias ss-loop='loop 2 "ss -anoHtu | sort -k5 -b"'
alias d='cal -3; date "+%A, %d %B %Y -- %T"'
alias clock='date "+%Y/%m/%d %T"'
alias clock-loop='loop 60 "date +%Y/%m/%d\ %T"'

alias cdo='cd "$OLDPWD"'
alias cdss='cd ~/img/ss'
alias cdbin='cd ~/.local/bin'
alias cdsbin='cd ~/.local/sbin'
alias cdlib='cd ~/.local/lib'
alias cdrepo='cd ~/repo/github/git/qithron'
alias cdportage='cd /etc/portage'
alias cdc='cd ~/.config'
alias cdcbspwm='cd ~/.config/bspwm'
alias cdcnvim='cd ~/.config/nvim'
alias cdcranger='cd ~/.config/ranger'

alias viTODO='vim ~/doc/uncat/TODO'
alias cmd-rating='grep -Eo "^\w*" ~/.zsh_history|sort|uniq -c|sort|tail -n 10'

alias chmod+x='chmod +x'
alias mkdir-current-time='mkdir -v "$(date +%Y%m%d%H%M%S)"'
alias mkdir-current-time-utc='mkdir -v "$(date -u +%Y%m%d%H%M%S)"'
alias xrandr-hdmi-def='xrandr --output HDMI2 --mode 1360x768 --right-of eDP1 &&
    bspc wm -r'
