" Date: Fri, 17 Nov 2023 00:00:00 +0000

if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "ssa"

syn keyword ssaTodo TODO FIXME NOTE XXX contained
syn match ssaComment /^\(;\|!:\).*$/ contains=ssaTodo,@Spell
syn match ssaTextComment /{[^}]*}/ contained contains=@Spell
syn match ssaSection /^\[[a-zA-Z0-9+ ]\+\]$/
syn match ssaHeader /^[^;!:]\+:/ skipwhite

hi def link ssaComment Comment
hi def link ssaHeader Label
hi def link ssaSection Type
hi def link ssaTextComment Comment
hi def link ssaTodo Todo
