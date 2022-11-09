if exists("b:current_syntax")
    finish
endif
let b:python_space_error_highlight = 1

source $VIMRUNTIME/syntax/python.vim
let b:current_syntax = 'python'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syn clear pythonFunction

hi link pythonBuiltin Type

syn keyword pythonOperatorNB is not in
hi link pythonOperatorNB pythonConditional

syn keyword pythonConstant False None True
hi pythonConstant ctermfg=13 cterm=bold

syn keyword pythonSpecial1 self args kwargs obj cls ins file
hi pythonSpecial1 ctermfg=11 cterm=bold

syn keyword pythonSpecial2 req path utils
hi pythonSpecial2 ctermfg=3

syn keyword pythonSpecial3 os sys time io asyncio math cmath re
hi pythonSpecial3 ctermfg=12 cterm=bold

syn match pythonDundur '\<__[a-zA-Z0-9]\+__\>'
hi pythonDundur ctermfg=11

" diouxXeEfFgGcrsa%
syn match pythonStringFormat '%\(([_a-zA-Z0-9]*)\)*[0-9]*\.*[0-9]*[%a-zA-Z]'
    \ contained
hi pythonStringFormat ctermfg=10 cterm=bold

syn region pythonString matchgroup=pythonQuotes
    \ start=+[uU]\=\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
    \ contains=@Spell,pythonEscape,pythonStringFormat
syn region pythonString matchgroup=pythonTripleQuotes
    \ start=+[uU]\=\z('''\|"""\)+ skip=+\\["']+ end="\z1" keepend
    \ contains=@Spell,pythonEscape,pythonSpaceError,pythonDoctest
    \,pythonStringFormat
hi pythonString ctermfg=8
syn region pythonRawString matchgroup=pythonQuotes
    \ start=+[uU]\=[rR]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
    \ contains=@Spell,pythonStringFormat
syn region pythonRawString matchgroup=pythonTripleQuotes
    \ start=+[uU]\=[rR]\z('''\|"""\)+ end="\z1" keepend
    \ contains=@Spell,pythonSpaceError,pythonDoctest,pythonStringFormat
hi pythonRawString ctermfg=8 cterm=bold

syn match pythonFVars "{[^}]*}" contained
hi link pythonFVars pythonBytes

syn region pythonFString matchgroup=pythonQuotes
    \ start=+[fF]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
    \ contains=@Spell,pythonEscape,pythonFVars,pythonStringFormat
syn region pythonFString matchgroup=pythonTripleQuotes
    \ start=+[fF]\z('''\|"""\)+ end="\z1" keepend
    \ contains=@Spell,pythonEscape,pythonSpaceError,pythonDoctest,pythonFVars
    \,pythonStringFormat
hi link pythonFString pythonString

syn region pythonRawFString matchgroup=pythonQuotes
    \ start=+[rR][fF]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
    \ contains=@Spell,pythonEscape,pythonFVars,pythonStringFormat
syn region pythonRawFString matchgroup=pythonTripleQuotes
    \ start=+[rR][fF]\z('''\|"""\)+ end="\z1" keepend
    \ contains=@Spell,pythonEscape,pythonSpaceError,pythonDoctest,pythonFVars
    \,pythonStringFormat
hi link pythonRawFString pythonRawString

syn region pythonBytes matchgroup=pythonQuotes
    \ start=+[bB]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
    \ contains=@Spell,pythonEscape,pythonStringFormat
syn region pythonBytes matchgroup=pythonTripleQuotes
    \ start=+[bB]\z('''\|"""\)+ end="\z1" keepend
    \ contains=@Spell,pythonEscape,pythonSpaceError,pythonDoctest
    \,pythonStringFormat
hi pythonBytes ctermfg=6
syn region pythonRawBytes matchgroup=pythonQuotes
    \ start=+[rR][bB]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
    \ contains=@Spell,pythonStringFormat
syn region pythonRawBytes matchgroup=pythonTripleQuotes
    \ start=+[rR][bB]\z('''\|"""\)+ end="\z1" keepend
    \ contains=@Spell,pythonSpaceError,pythonDoctest,pythonStringFormat
hi pythonRawBytes ctermfg=6 cterm=bold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pythonAsync pythonAttribute pythonBuiltin pythonComment pythonConditional
" pythonDecorator pythonDecoratorName pythonDoctest pythonDoctestValue
" pythonEscape pythonException pythonExceptions pythonFunction pythonInclude
" pythonMatrixMultiply pythonNumber pythonOperator pythonQuotes pythonRawString
" pythonRepeat pythonSpaceError pythonStatement pythonString pythonSync
" pythonTodo pythonTripleQuotes
