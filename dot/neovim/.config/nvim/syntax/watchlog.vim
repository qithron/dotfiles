if exists("b:current_syntax")
    finish
endif
let s:cpo_save = &cpo
set cpo&vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

sy match watchlogY "^[0-9\-]\{4}"  contained
sy match watchlogB "^[0-9\-]\{6}"  contained contains=watchlogY
sy match watchlogD "^[0-9\-]\{8}"  contained contains=watchlogB
sy match watchlogH "^[0-9\-]\{10}" contained contains=watchlogD
sy match watchlogM "^[0-9\-]\{12}" contained contains=watchlogH
sy match watchlogS "^[0-9\-]\{4}.\{10}" contains=watchlogM

hi def watchlogY ctermfg=9
hi def watchlogB ctermfg=11
hi def watchlogD ctermfg=10
hi def watchlogH ctermfg=14
hi def watchlogM ctermfg=12
hi def watchlogS ctermfg=13

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:cpo_save
unlet s:cpo_save
let b:current_syntax = 'watchlog'
