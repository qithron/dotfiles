if exists("b:current_syntax")
    finish
endif
let s:cpo_save = &cpo
set cpo&vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" keywords
sy keyword pythonKeyword as assert break class continue def del elif else
                       \ except finally global if lambda nonlocal pass raise
                       \ return try with yield
                       \ match case
                       \ async await
hi def link pythonKeyword Statement

sy keyword pythonConditional elif else if and or
hi def link pythonConditional Conditional

sy keyword pythonInclude from import
hi def link pythonInclude Include

sy keyword pythonOperator in is not
hi def link pythonOperator Operator

sy keyword pythonRepeat for while
hi def link pythonRepeat Repeat

sy keyword pythonConst False None True NotImplemented Ellipsis __debug__
hi def link pythonConst Constant

hi def     pythonBuiltinFunction ctermfg=11
sy keyword pythonBuiltinFunction
            \ abs all any ascii bin breakpoint callable chr compile delattr dir
            \ divmod eval exec format getattr globals hasattr hash hex id input
            \ isinstance issubclass iter len locals max min next oct open ord
            \ pow print repr round setattr sorted sum vars

hi def     pythonBuiltinClass ctermfg=11 cterm=bold
sy keyword pythonBuiltinClass
            \ bool bytearray bytes classmethod complex dict
            \ enumerate filter float frozenset int list map
            \ memoryview object property range reversed set
            \ slice staticmethod str super tuple type zip

sy keyword pythonException BaseException GeneratorExit KeyboardInterrupt
                         \ SystemExit Exception ArithmeticError
                         \ FloatingPointError OverflowError ZeroDivisionError
                         \ AssertionError AttributeError BufferError EOFError
                         \ ImportError ModuleNotFoundError LookupError
                         \ IndexError KeyError MemoryError NameError
                         \ UnboundLocalError OSError BlockingIOError
                         \ ChildProcessError ConnectionError BrokenPipeError
                         \ ConnectionAbortedError ConnectionRefusedError
                         \ ConnectionResetError FileExistsError
                         \ FileNotFoundError InterruptedError
                         \ IsADirectoryError NotADirectoryError
                         \ PermissionError ProcessLookupError TimeoutError
                         \ ReferenceError RuntimeError NotImplementedError
                         \ RecursionError StopAsyncIteration StopIteration
                         \ SyntaxError IndentationError TabError SystemError
                         \ TypeError ValueError UnicodeError
                         \ UnicodeDecodeError UnicodeEncodeError
                         \ UnicodeTranslateError Warning BytesWarning
                         \ DeprecationWarning EncodingWarning FutureWarning
                         \ ImportWarning PendingDeprecationWarning
                         \ ResourceWarning RuntimeWarning SyntaxWarning
                         \ UnicodeWarning UserWarning
hi def link pythonException Exception

sy keyword pythonDummyVar _
hi def     pythonDummyVar ctermfg=13 cterm=bold

sy match pythonSunder "\<_[_a-zA-Z0-9]\+\>"
hi def   pythonSunder ctermfg=14 cterm=italic

sy match pythonDunder "\<__[_a-zA-Z0-9]\+__\>"
hi def   pythonDunder ctermfg=14 cterm=italic,bold

sy match pythonConstVar '\<[A-Z]\+[_A-Z0-9]*\>'
hi def   pythonConstVar ctermfg=159 cterm=bold,italic

sy match pythonBadName "\<[a-z]\>"
hi def   pythonBadName ctermfg=22 cterm=italic,bold

sy match pythonNumber "\<0[oO]\=\o\+[Ll]\=\>"
sy match pythonNumber "\<0[xX]\x\+[Ll]\=\>"
sy match pythonNumber "\<0[bB][01]\+[Ll]\=\>"
sy match pythonNumber "\<\%([1-9]\d*\|0\)[Ll]\=\>"
sy match pythonNumber "\<\d\+[jJ]\>"
sy match pythonNumber "\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
sy match pythonNumber "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
sy match pythonNumber "\%(^\|\W\)\zs\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"
hi def link pythonNumber Number

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi def     pythonLibrary ctermfg=12 cterm=bold
sy keyword pythonLibrary
    \ os sys time io asyncio math re socket subprocess gzip shutil random queue
    \ importlib functools itertools collections builtins signal threading

hi def     pythonSPVarName ctermfg=10 cterm=bold
sy keyword pythonSPVarName self args kwargs

hi def     pythonCustomName1 ctermfg=10
sy keyword pythonCustomName1 obj cls ins

hi def     pythonCustomName2 ctermfg=75
sy keyword pythonCustomName2 req res arr lst dct

hi def     pythonCustomName3 ctermfg=249
sy keyword pythonCustomName3 file path util data name func size

sy match pythonComma ","
hi def pythonComma ctermfg=220 cterm=bold

sy match pythonEqual "="
hi def pythonEqual ctermfg=10 cterm=bold

sy match pythonColon ":"
hi def link pythonColon pythonException

sy match pythonOperatorSym "[<=>!]=\|<<\|>>\|[-/%@<>&|~^.]\|+\|*"
hi def pythonOperatorSym ctermfg=12 cterm=bold

sy keyword pythonTodo XXX FIXME TODO contained
hi def link pythonTodo Todo

sy match pythonComment "#.*$" contains=@Spell,pythonTodo
hi def link pythonComment Comment

sy match pythonParentheses "\[\|[](){}]"
hi def   pythonParentheses ctermfg=160 cterm=bold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
sy match pythonString /'\(\\'\|[^']\|\\\n\)*'/
    \ contains=@Spell,pythonEscape,pythonFormat
sy match pythonString /[Ff]'\(\\'\|[^']\|\\\n\)*'/
    \ contains=@Spell,pythonEscape,pythonFormat,pythonFString
sy match pythonRString /[Rr]'\(\\'\|[^']\|\\\n\)*'/
    \ contains=@Spell,pythonFormat
sy match pythonRString /\([Rr][Ff]\|[Ff][Rr]\)'\(\\'\|[^']\|\\\n\)*'/
    \ contains=@Spell,pythonFormat,pythonFString
sy match pythonBytes /[Bb]'\(\\'\|[^']\|\\\n\)*'/
    \ contains=@Spell,pythonEscape,pythonFormat
sy match pythonRBytes /\([Bb][Rr]\|[Rr][Bb]\)'\(\\'\|[^']\|\\\n\)*'/
    \ contains=@Spell,pythonFormat

sy match pythonString /"\(\\"\|[^"]\|\\\n\)*"/
    \ contains=@Spell,pythonEscape,pythonFormat
sy match pythonString /[Ff]"\(\\"\|[^"]\|\\\n\)*"/
    \ contains=@Spell,pythonEscape,pythonFormat,pythonFString
sy match pythonRString /[Rr]"\(\\"\|[^"]\|\\\n\)*"/
    \ contains=@Spell,pythonFormat
sy match pythonRString /\([Rr][Ff]\|[Ff][Rr]\)"\(\\"\|[^"]\|\\\n\)*"/
    \ contains=@Spell,pythonFormat,pythonFString
sy match pythonBytes /[Bb]"\(\\"\|[^"]\|\\\n\)*"/
    \ contains=@Spell,pythonEscape,pythonFormat
sy match pythonRBytes /\([Bb][Rr]\|[Rr][Bb]\)"\(\\"\|[^"]\|\\\n\)*"/
    \ contains=@Spell,pythonFormat

sy region pythonString
    \ start=+\z('''\|"""\)+
    \ skip=+\\['"]+ end=+\z1+
    \ contains=@Spell,pythonEscape,pythonFormat
sy region pythonString
    \ start=+[Ff]\z('''\|"""\)+
    \ skip=+\\['"]+ end=+\z1+
    \ contains=@Spell,pythonEscape,pythonFormat,pythonFString
sy region pythonRString
    \ start=+[Rr]\z('''\|"""\)+
    \ skip=+\\['"]+ end=+\z1+
    \ contains=@Spell,pythonFormat
sy region pythonRString
    \ start=+\([Rr][Ff]\|[Ff][Rr]\)\z('''\|"""\)+
    \ skip=+\\['"]+ end=+\z1+
    \ contains=@Spell,pythonFormat,pythonFString
sy region pythonBytes
    \ start=+[Bb]\z('''\|"""\)+
    \ skip=+\\['"]+ end=+\z1+
    \ contains=@Spell,pythonEscape,pythonFormat
sy region pythonRBytes
    \ start=+\([Bb][Rr]\|[Rr][Bb]\)\z('''\|"""\)+
    \ skip=+\\['"]+ end=+\z1+
    \ contains=@Spell,pythonFormat

hi def pythonString  ctermfg=8
hi def pythonRString ctermfg=8 cterm=bold
hi def pythonBytes   ctermfg=95
hi def pythonRBytes  ctermfg=95 cterm=bold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
sy match pythonEscape +\\[abfnrtv'"\\]+ contained
sy match pythonEscape "\\\o\{1,3}" contained
sy match pythonEscape "\\x\x\{2}" contained
sy match pythonEscape "\%(\\u\x\{4}\|\\U\x\{8}\)" contained
sy match pythonEscape "\\N{\a\+\%(\s\a\+\)*}" contained
sy match pythonEscape "\\$" contained
hi def link pythonEscape Special

sy match pythonFormat "%\(([^)]*)\)*[\-0-9]*\.*[0-9]*[%a-zA-Z]" contained
hi def pythonFormat ctermfg=207

sy region pythonFString extend start="{" end="}" contained keepend contains=ALL
hi def link pythonFString Normal

sy match pythonSpaceError display excludenl "\s\+$"
sy match pythonSpaceError display " \+\t"
sy match pythonSpaceError display "\t\+ "
hi def link pythonSpaceError Error

syn sync match pythonSync grouphere NONE "^\%(def\|class\)\s\+\h\w*\s*[(:]"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:cpo_save
unlet s:cpo_save
let b:current_syntax = 'python'
