if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "sh"

syn sync ccomment

syn keyword shKeyword if then elif else fi for until while do done case in esac

syn region shCommandSubstitution start="\$(" end=")"
            \ contains=ALLBUT,shSpecial,@shHereDocHelper,@shHereDocRawHelper

syn match shDelimiter '[&|!;]'
syn match shRedirection "\d*\(<<-\?\|\(<&\|>&\)\(-\|\w*\)\|>|\|<>\|>>\|<\|>\)"
syn match shShortCircuit "&&\|||"

syn match shVarAssign "\h\w*="

syn region shParamExpansionBraces start="\${" end="}"
            \ contains=shEscape,@shParamExpansion
syn match shParamExpansionSimple "\$\([*@#?!$]\|-\|\w\+\>\)"
syn cluster shParamExpansion contains=shParamExpansionSimple,shParamExpansionBraces

syn region shComment start="\(^\|\s\)\@1<=#" end="$" contains=@spell

syn region shDoubleQuotes start='"' skip='\\"' end='"'
            \ contains=shCommandSubstitution,shSpecial,@shParamExpansion
            \ nextgroup=shCommandSubstitution
syn region shSingleQuotes start="'" end="'"
syn cluster shQuotes contains=shSingleQuotes,shDoubleQuotes

syn match shSpecial contained '\\\(\\\|x\d\d\|\d\d\d\|0\|n\|t\|r\|\$\|`\|"\|$\)'

" Here document with dereferencing
syn region shHereDoc start="\d*<<-\?[ ]*\z([^ ]\+\)" end="^\z1$"
            \ contains=shHereDocRedirOp,shHereDocDeref
            \ nextgroup=shHereDocRedirOp keepend transparent
syn region shHereDocDeref start="^" skip=".*" end=""
            \ contained contains=shCommandSubstitution,shSpecial,@shParamExpansion
syn match shHereDocDelimAfter ".*$"
            \ contains=ALLBUT,shSpecial,shHereDoc,shHereDocRaw,@shHereDocHelper,@shHereDocRawHelper
            \ contained nextgroup=shHereDocDeref skipnl
syn match shHereDocDelimStart "[^ ]\+"
            \ contained nextgroup=shHereDocDeref,shHereDocDelimAfter
syn match shHereDocRedirOp "\d*<<-\?"
            \ contained nextgroup=shHereDocDelimStart skipwhite
syn cluster shHereDocHelper contains=shHereDocRedirOp,shHereDocDelimStart,shHereDocDelimAfter,shHereDocDeref

" Here document without dereferencing
syn region shHereDocRaw start='\d*<<-\?\s*"\z([^"]\+\)"' end="^\z1$"
            \ contains=shHereDocRedirOpRaw,shHereDocNoDeref
            \ nextgroup=shHereDocRedirOpRaw keepend transparent
syn region shHereDocNoDeref start="^" skip=".*" end=""
            \ contained
syn match shHereDocDelimAfterRaw ".*$"
            \ contains=ALLBUT,shSpecial,shHereDoc,shHereDocRaw,@shHereDocHelper,@shHereDocRawHelper
            \ contained nextgroup=shHereDocNoDeref skipnl
syn match shHereDocDelimStartRaw '"[^"]\+"'
            \ contained nextgroup=shHereDocDelimAfterRaw
syn match shHereDocRedirOpRaw "\d*<<-\?"
            \ contained nextgroup=shHereDocDelimStartRaw skipwhite
syn cluster shHereDocRawHelper contains=shHereDocRedirOpRaw,shHereDocDelimStartRaw,shHereDocDelimAfterRaw,shHereDocNoDeref

" First priority
syn match shEscape /\\\(\\\|\d\|[ (){}<>&|=*?!$`'";~]\|\[\|\]\|$\)/

" B R G Y B M C W
" 0 1 2 3 4 5 6 7

hi def link shComment Comment

hi def link shKeyword Keyword
hi def link shDelimiter shKeyword
hi def link shRedirection shKeyword
hi def link shShortCircuit shKeyword

hi def link shQuotes String
hi def link shDoubleQuotes shQuotes
hi def link shSingleQuotes shQuotes

hi def link shHereDocDeref shQuotes
hi def link shHereDocNoDeref shQuotes
hi def link shHereDocDelimStart shQuotes
hi def link shHereDocDelimStartRaw shQuotes
hi def link shHereDocRedirOp shKeyword
hi def link shHereDocRedirOpRaw shKeyword

hi def link shEscape Special
hi def link shSpecial Special

hi def shParamExpansion ctermfg=12
hi def link shParamExpansionBraces shParamExpansion
hi def link shParamExpansionSimple shParamExpansion
hi def clear shCommandSubstitution
