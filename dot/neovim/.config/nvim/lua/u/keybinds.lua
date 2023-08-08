vim.g.mapleader = ' '
local map = vim.keymap.set

-- disable
--map('', '<C-a>', '<NOP>')
--map('', '<C-x>', '<NOP>')
map('', '<CR>', '<NOP>')

-- escape
map('i', '<A-i>', '<ESC>')
map('t', '<A-i>', '<C-\\><C-n>')

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

-- emacs keys
map('i', '<C-e>', '<ESC>A', {silent=true})
map('i', '<C-a>', '<ESC>I', {silent=true})

-- next/prev buffer
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

-- next/prev tab
map('n', '<A-1>', 'gT')
map('n', '<A-2>', 'gt')
map('i', '<A-1>', '<ESC>gT')
map('i', '<A-2>', '<ESC>gt')

-- switch to tab x (<ALT>+<F1>, ..., <ALT>+<F12>)
vim.cmd([[
function TabPageGoTo(i)
    if a:i > tabpagenr('$')
        return
    endif
    execute 'tabnext ' .. a:i
endfunction]])
local j, k
for i = 49, 60 do
    j = '<F' .. i .. '>'
    k = ':call TabPageGoTo(' .. (i-48) .. ')<CR>'
    map('n', j, k)
    map('i', j, '<ESC>' .. k)
    map('t', j, '<C-\\><C-N>' .. k)
end

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
