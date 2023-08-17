lua user = {}

lua require('u/settings')
lua require('u/keybinds')

""" plugins
if !$VIMCAT
    lua require('p/packer')
    lua require('p/lualine')
    lua require('p/bufexplorer')
    lua require('p/nvim-tree')
    "lua require('p/nvim-treesitter')
    lua require('p/lint')
    lua user.lsp = function() require('p/lsp') end
endif

hi! Normal cterm=none                                 ctermfg=15   ctermbg=none
hi! link Identifier Normal
hi! link Function Normal
hi! link NonText Normal
hi! Keyword cterm=bold                                ctermfg=9    ctermbg=none
hi! link Statement Keyword
hi! link Repeat Keyword
hi! Operator cterm=bold                               ctermfg=12   ctermbg=none
hi! Conditional cterm=italic                          ctermfg=9    ctermbg=none
hi! PreProc cterm=italic                              ctermfg=9    ctermbg=none
hi! Exception cterm=bold                              ctermfg=202  ctermbg=none
hi! Type cterm=bold                                   ctermfg=11   ctermbg=none
hi! Number cterm=none                                 ctermfg=5    ctermbg=none
hi! Constant cterm=bold                               ctermfg=5    ctermbg=none
hi! Boolean cterm=none                                ctermfg=12   ctermbg=none
hi! String cterm=none                                 ctermfg=8    ctermbg=none
hi! link Character String
hi! Comment cterm=italic                              ctermfg=202  ctermbg=none
hi! link SpecialComment Comment

hi! LineNrAbove cterm=none                            ctermfg=9    ctermbg=none
hi! LineNr      cterm=none                            ctermfg=15   ctermbg=none
hi! LineNrBelow cterm=none                            ctermfg=12   ctermbg=none

hi! clear SignColumn
hi! TabLine cterm=none                                ctermfg=15   ctermbg=8
hi! ColorColumn cterm=reverse                         ctermfg=8    ctermbg=none

hi! Special cterm=none                                ctermfg=11   ctermbg=none
hi! Search cterm=none                                 ctermfg=none ctermbg=14

hi! link NormalFloat Normal
hi! QuickFixLine                                      ctermfg=0    ctermbg=14
