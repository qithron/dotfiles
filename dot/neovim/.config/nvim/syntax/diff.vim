if exists("b:current_syntax")
    finish
endif
source $VIMRUNTIME/syntax/diff.vim
let b:current_syntax = 'diff'

hi diffFile cterm=bold                                ctermfg=9    ctermbg=none
hi diffLine cterm=bold                                ctermfg=11   ctermbg=none
hi diffAdded cterm=none                               ctermfg=10   ctermbg=none
hi diffRemoved cterm=none                             ctermfg=8    ctermbg=none
