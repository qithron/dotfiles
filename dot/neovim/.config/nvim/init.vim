lua user = {}

" TODO rewrite 'vim.cmd' in lua if possible
lua require('u/settings')
lua require('u/keybinds')

""" plugins
lua require('p/lualine')
lua require('p/lint')
lua require('p/nvim-tree')
lua require('p/bufexplorer')
"lua require('p/nvim-treesitter')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color

hi Normal cterm=none                                  ctermfg=15   ctermbg=none
hi! link Identifier Normal
hi Keyword cterm=bold                                 ctermfg=9    ctermbg=none
hi! link Statement Keyword
hi Type cterm=none                                    ctermfg=10   ctermbg=none
hi String cterm=none                                  ctermfg=8    ctermbg=none
hi! link Character String
hi! Comment cterm=italic                              ctermfg=22   ctermbg=none
hi Number cterm=none                                  ctermfg=5    ctermbg=none

hi Boolean cterm=none                                 ctermfg=12   ctermbg=none
hi! link Function Normal
hi Conditional cterm=italic                           ctermfg=9    ctermbg=none
hi! link Repeat Keyword
hi! link Operator Statement
hi! link Exception Keyword

hi PreProc cterm=italic                               ctermfg=9    ctermbg=none

hi! link NonText Normal

hi LineNrAbove cterm=none                             ctermfg=9    ctermbg=none
hi LineNr      cterm=none                             ctermfg=15   ctermbg=none
hi LineNrBelow cterm=none                             ctermfg=12   ctermbg=none

hi clear SignColumn
hi TabLine cterm=none                                 ctermfg=15   ctermbg=8
hi ColorColumn cterm=reverse                          ctermfg=8    ctermbg=none

hi Special cterm=none                                 ctermfg=11   ctermbg=none
hi Search cterm=none                                  ctermfg=none ctermbg=14

" temp
hi Question cterm=bold,underline ctermfg=9 ctermbg=24
