test "$(tty)" = /dev/tty1 && tmux new-session -s "$USER" -d > /dev/null 2>&1
test "$TERMUX_VERSION" && cd
