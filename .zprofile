export  XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export   XDG_DATA_HOME="$HOME/.local/share"
export  XDG_STATE_HOME="$HOME/.local/state"

export LANG="en_US.UTF-8"
export LC_TIME="id_ID.UTF-8"
export USER="$(whoami)"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="nvim-pager"
export MANPAGER="nvim +Man!"
export GIT_PAGER="cat"

test -d /system/bin && export PATH="$PATH:/system/bin"
export PATH="$HOME/.local/sbin:$HOME/.local/bin:$HOME/.local/games:$PATH"
export CDPATH="$XDG_CONFIG_HOME"
export LUA_PATH=";;$HOME/.local/lib/lua/?.lua;$HOME/.local/lib/lua/?/init.lua"

d=$(get-tmpfs-path)
test -e "$d" || mkdir -m 700 "$d"
unset d

command_exists() command -v "$@" > /dev/null
command_exists cargo && export CARGO_HOME="$XDG_DATA_HOME/cargo"
command_exists rustup && {
    export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
    export MANPATH="$MANPATH:$RUSTUP_HOME/toolchains/stable-x86_64-unknown-linux-gnu/share/man"
}
