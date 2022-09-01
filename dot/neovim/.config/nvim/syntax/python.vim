if exists("b:current_syntax")
    finish
endif
source $VIMRUNTIME/syntax/python.vim
let b:current_syntax = 'python'

syn clear pythonFunction
syn clear pythonMatrixMultiply
syn keyword pythonConstant False None True
syn keyword pythonSpecial self obj cls ins args kwargs
syn keyword pythonInit __init__

hi pythonSpecial ctermfg=14 cterm=bold
hi pythonConstant ctermfg=13 cterm=bold
hi link pythonInit PreProc
hi link pythonBuiltin Type

"False None True and as assert async await break class continue def del elif else except finally for from global if import in is lambda nonlocal not or pass raise return try while with yield

"hi pythonAsync          guifg=#FF00FF gui=bold ctermfg=magenta term=bold
"hi pythonAttribute      guifg=#FFFF00 ctermfg=yellow
"hi pythonBuiltin        guifg=#00FF00 ctermfg=green
"hi pythonComment        guifg=#FF7F00 ctermfg=16
"hi pythonConditional    guifg=#0000FF gui=bold ctermfg=blue term=bold
"hi pythonDecorator      guifg=#FF00FF gui=bold ctermfg=magenta term=bold
"hi pythonDecoratorName  guifg=#FF00FF gui=bold ctermfg=magenta term=bold
"hi pythonDoctest        guifg=#FFFFFF gui=bold ctermfg=white term=bold
"hi pythonDoctestValue   guifg=#FFFFFF ctermfg=white
"hi pythonEscape         guifg=#FF0000 gui=bold ctermfg=red term=bold
"hi pythonException      guifg=#FF0000 ctermfg=red
"hi pythonExceptions     guifg=#FF0000 gui=bold ctermfg=red term=bold
"hi clear pythonFunction
"hi pythonInclude        guifg=#FF7F7F ctermfg=18
"hi pythonMatrixMultiply guifg=#FFFF00 ctermfg=yellow
"hi pythonSpaceError     guibg=#FF0000 ctermfg=red
"hi pythonStatement      guifg=#FF0000 ctermfg=red
"hi pythonNumber         guifg=#BF00BF ctermfg=17
"hi pythonOperator       guifg=#0000FF gui=italic ctermfg=blue term=italic
"hi pythonQuotes         guifg=#7F7F7F ctermfg=8
"hi pythonRawString      guifg=#7F7F7F ctermfg=8
"hi pythonRepeat         guifg=#FFFF00 gui=bold ctermfg=yellow term=bold
"hi pythonString         guifg=#7F7F7F ctermfg=8
"hi pythonSync           guifg=#FF00FF gui=bold ctermfg=magenta term=bold
"hi pythonTodo           guifg=#000000 guibg=#FFFF00 ctermfg=black ctermbg=yellow
"hi pythonTripleQuotes   guifg=#7F7F7F ctermfg=8

"pythonAsync             links to Statement
"pythonAttribute         cleared
"pythonBuiltin           links to Function
"pythonComment           links to Comment
"pythonConditional       links to Conditional
"pythonDecorator         links to Define
"pythonDecoratorName     links to Function
"pythonDoctest           links to Special
"pythonDoctestValue      links to Define
"pythonEscape            links to Special
"pythonException         links to Exception
"pythonExceptions        links to Structure
"pythonFunction          links to Function
"pythonInclude           links to Include
"pythonMatrixMultiply    cleared
"pythonNumber            links to Number
"pythonOperator          links to Operator
"pythonQuotes            links to String
"pythonRawString         links to String
"pythonRepeat            links to Repeat
"pythonSpaceError        cleared
"pythonStatement         links to Statement
"pythonString            links to String
"pythonSync              cleared
"pythonTodo              links to Todo
"pythonTripleQuotes      links to pythonQuotes
