" Date: Mon, 17 Apr 2023 00:00:00 +0000

if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "ymdhms"

sy match watchlogYrr "^[0-9\-]\{4}"  contained
sy match watchlogMon "^[0-9\-]\{6}"  contained contains=watchlogYrr
sy match watchlogDay "^[0-9\-]\{8}"  contained contains=watchlogMon
sy match watchlogHrr "^[0-9\-]\{10}" contained contains=watchlogDay
sy match watchlogMin "^[0-9\-]\{12}" contained contains=watchlogHrr
sy match watchlogSec "^[0-9\-]\{4}.\{10}"      contains=watchlogMin

hi def watchlogYrr ctermfg=9
hi def watchlogMon ctermfg=11
hi def watchlogDay ctermfg=10
hi def watchlogHrr ctermfg=14
hi def watchlogMin ctermfg=12
hi def watchlogSec ctermfg=13
