if exists("b:current_syntax")
    finish
endif
source $VIMRUNTIME/syntax/html.vim
let b:current_syntax = 'html'

setlocal indentexpr=
