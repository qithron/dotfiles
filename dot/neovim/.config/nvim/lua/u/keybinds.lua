vim.g.mapleader = ' '
local map = vim.keymap.set

-- disable
map('', '<C-a>', '<NOP>')
map('', '<C-x>', '<NOP>')

-- escape
map('i', '<A-i>', '<ESC>')
map('t', '<A-i>', '<C-\\><C-n>')

-- command line mode
map('c', '<A-h>', '<LEFT>')
map('c', '<A-j>', '<DOWN>')
map('c', '<A-k>', '<UP>')
map('c', '<A-l>', '<RIGHT>')

-- common command
map('n', '<C-j>', '9j')
map('n', '<C-k>', '9k')
map('n', '<C-l>', '7l')
map('n', '<C-h>', '7h')
map('n', '<C-j>', '9j')
map('n', '<C-k>', '9k')
map('n', '<C-l>', '7l')
map('n', '<C-h>', '7h')
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>Q', ':q!<CR>')
map('n', '<leader>s', ':w<CR>')
map('n', '<C-s>', ':w<CR>')

-- emacs keys
map('i', '<C-e>', '<ESC>A', {silent=true})
map('i', '<C-a>', '<ESC>I', {silent=true})

-- next/prev buffer
map('n', '<A-o>', ':bp<CR>')
map('n', '<A-p>', ':bn<CR>')
map('i', '<A-o>', '<ESC>:bp<CR>')
map('i', '<A-p>', '<ESC>:bn<CR>')
map('t', '<A-o>', '<C-\\><C-n>:bp<CR>')
map('t', '<A-p>', '<C-\\><C-n>:bn<CR>')

-- window focus
map('n', '<A-h>', '<C-w>h')
map('n', '<A-j>', '<C-w>j')
map('n', '<A-k>', '<C-w>k')
map('n', '<A-l>', '<C-w>l')
map('i', '<A-h>', '<C-\\><C-n><C-w>h')
map('i', '<A-j>', '<C-\\><C-n><C-w>j')
map('i', '<A-k>', '<C-\\><C-n><C-w>k')
map('i', '<A-l>', '<C-\\><C-n><C-w>l')
map('t', '<A-h>', '<C-\\><C-n><C-w>h')
map('t', '<A-j>', '<C-\\><C-n><C-w>j')
map('t', '<A-k>', '<C-\\><C-n><C-w>k')
map('t', '<A-l>', '<C-\\><C-n><C-w>l')

-- window resize
map('n', '<ESC><C-h>', ':vert resize -1<CR>', {silent=true})
map('n', '<ESC><C-l>', ':vert resize +1<CR>', {silent=true})
map('n', '<ESC><C-j>', ':resize +1<CR>', {silent=true})
map('n', '<ESC><C-k>', ':resize -1<CR>', {silent=true})

-- next/prev tab
map('n', '<A-1>', 'gT')
map('n', '<A-2>', 'gt')
map('i', '<A-1>', '<ESC>gT')
map('i', '<A-2>', '<ESC>gt')
map('t', '<A-1>', '<C-\\><C-n>gT')
map('t', '<A-2>', '<C-\\><C-n>gt')

-- switch to tab x (<ALT>+<F1>, ..., <ALT>+<F12>)
vim.cmd([[
function TabPageGoTo(i)
    if a:i > tabpagenr('$')
        return
    endif
    execute 'tabnext ' .. a:i
endfunction]])
local i = 49
local k, f
while i < 61 do
    k = '<F' .. i .. '>'
    f = ':call TabPageGoTo(' .. (i-48) .. ')<CR>'
    map('n', k, f)
    map('i', k, '<ESC>' .. f)
    map('t', k, '<C-\\><C-N>' .. f)
    i = i + 1
end

-- plugins
map('n', '<leader>\\', ':NvimTreeToggle<CR>')
map('n', '<CR>', ':ToggleBufExplorer<CR>')

-- execute current line as vim command, usefull when change settings
vim.cmd([[
function USER_vimexecuteline()
    if b:current_syntax == 'vim'
        let l = getline('.')
        execute l
        echo l
    endif
endfunction]])
map('n', '<A-e>', ':call USER_vimexecuteline()<CR>', {silent=true})
