vim.o.spell = false
vim.o.spelllang = 'en_us'
vim.o.shell = '/bin/fish'
vim.o.encoding = 'utf-8'
vim.o.clipboard = 'unnamedplus'
vim.o.laststatus = 2

vim.o.runtimepath = '/usr/share/vim/vimfiles,' .. vim.o.runtimepath

vim.o.wrap = false
vim.o.scrolloff = 9
vim.o.sidescrolloff = 0
vim.o.equalalways = false
vim.o.colorcolumn = '80'
vim.o.number = false
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.numberwidth = 2
vim.o.foldenable = false

vim.o.backup = false
vim.o.writebackup = true
vim.o.swapfile = false
vim.o.undofile = false

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.autoindent = false
vim.o.smartindent = false
vim.o.smarttab = false

vim.o.list = true
vim.o.listchars = 'tab:\\x20\\x20,trail:•'

-- tabline
vim.o.showtabline = 1
vim.cmd([[
function USER_tabline()
    let s = ''
    for i in range(tabpagenr('$'))
        if i + 1 == tabpagenr()
            let s ..= '%#TabLineSel#'
        else
            let s ..= '%#TabLine#'
        endif
        let s ..= ' ' .. (i+1) .. ' '
    endfor
    let s ..= '%#TabLineFill#%T'
    return s
endfunction
]])
vim.o.tabline = '%!USER_tabline()'

-- autocmd
vim.cmd([[
augroup user
    " terminal autocmd
    autocmd BufEnter term://* startinsert
    autocmd TermOpen * setlocal nonu nornu scl=no | startinsert
augroup END
]])

-- terminal in new tab
vim.cmd('command! TERM tab vs | terminal')

-- split in new tab
vim.cmd('command! TNEW tab vs')

-- HTML
vim.g.html_indent_script1 = "auto"
vim.g.html_indent_style1 = "auto"
vim.g.html_indent_attribute = 0
