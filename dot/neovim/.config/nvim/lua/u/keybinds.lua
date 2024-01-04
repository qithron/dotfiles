vim.g.mapleader = ' '
local map = vim.keymap.set

-- disable
map('', '<CR>', '<NOP>')

-- command line mode
map('c', '<A-h>', '<UP>')
map('c', '<A-j>', '<RIGHT>')
map('c', '<A-k>', '<LEFT>')
map('c', '<A-l>', '<DOWN>')

-- common command
map('', '<C-j>', '9j')
map('', '<C-k>', '9k')
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>Q', ':q!<CR>')
map('n', '<leader><leader>', ':noh<CR>')
map('v', 'F', ':!1py-text-format-fill<CR>')

-- emacs keys
map('i', '<C-e>', '<ESC>A', {silent=true})
map('i', '<C-a>', '<ESC>I', {silent=true})

-- prev buffer
map('n', '<A-`>', ':b#<CR>')
map('i', '<A-`>', '<ESC>:b#<CR>')

-- window focus
map('n', '<A-h>', '<C-w>h')
map('n', '<A-j>', '<C-w>j')
map('n', '<A-k>', '<C-w>k')
map('n', '<A-l>', '<C-w>l')
map('i', '<A-h>', '<ESC><C-w>h')
map('i', '<A-j>', '<ESC><C-w>j')
map('i', '<A-k>', '<ESC><C-w>k')
map('i', '<A-l>', '<ESC><C-w>l')

-- window resize
map('n', '<A-C-h>', ':vert resize -1<CR>', {silent=true})
map('n', '<A-C-l>', ':vert resize +1<CR>', {silent=true})
map('n', '<A-C-j>', ':resize +1<CR>', {silent=true})
map('n', '<A-C-k>', ':resize -1<CR>', {silent=true})

-- next tab
map('n', '<A-Tab>', 'gt')
map('i', '<A-Tab>', '<ESC>gt')
map('t', '<A-Tab>', '<C-\\><C-N>gt')

-- plugins
map('n', '<leader>\\', ':NvimTreeToggle<CR>')
map('n', '<A-e>', ':ToggleBufExplorer<CR>')

-- grep current word in current working dir
vim.cmd([[
function USER_grep_find_kw_cw()
    let s = expand("<cword>")
    if strlen(s) > 2
        exe '!grep -nrs "\<' . s . '\>" | cat -n'
    endif
endfunction]])
map('n', '<A-8>', ':call USER_grep_find_kw_cw()<CR>', {silent=true})

-- github/ThePrimeagen/init.lua
map('x', '<leader>p', '"_dP')
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map({'n', 'v'}, '<leader>y', '"+y')
map('n', '<leader>Y', '"+Y')
