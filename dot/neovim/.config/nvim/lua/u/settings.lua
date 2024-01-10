vim.o.shell = "/bin/zsh"
vim.o.spell = false
vim.o.spelllang = "en_us"
vim.o.encoding = "utf-8"
vim.o.mouse = ""

vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,"
               .. "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,"
               .. "sm:block-blinkwait175-blinkoff150-blinkon175"

vim.o.runtimepath = "/usr/share/vim/vimfiles," .. vim.o.runtimepath

vim.o.shellpipe = ""

vim.o.wrap = false
vim.o.scrolloff = 9
vim.o.sidescrolloff = 0
vim.o.equalalways = false
vim.o.colorcolumn = "80"
vim.o.number = false
vim.o.relativenumber = true
vim.o.signcolumn = "yes:1"
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
vim.o.autoindent = true
vim.o.smartindent = true

vim.o.list = true
vim.o.listchars = "tab:\\x20\\x20,trail:•"

vim.o.showtabline = 0
vim.o.laststatus = 2
vim.o.cmdheight = 1

user.term = {}

user.term.term_open = function()
    if vim.call("winnr", "#") == 0 then
        vim.cmd("setlocal ch=0 ls=0")
    end
    vim.cmd("setlocal nonu nornu scl=no")
    vim.cmd("startinsert")
end

user.term.buf_enter = function()
    if vim.call("winnr", "#") == 0 then
        vim.cmd("setlocal ch=0 ls=0")
    end
    vim.cmd("startinsert")
end

user.term.term_enter = function()
    if vim.call("winnr", "#") == 0 then
        vim.cmd("setlocal ch=0 ls=0")
    end
end

user.term.term_leave = function()
    if vim.call("winnr", "#") == 0 then
        vim.cmd("setlocal ch=1 ls=2")
    end
end

-- autocmd
vim.cmd([[augroup user
    au BufNewFile,BufRead *.pyp setf python
    au BufNewFile,BufRead *.pyh setf pyhtml
    au BufNewFile,BufRead watch-log.txt setf watchlog

    au TermOpen * lua user.term.term_open()
    au BufEnter term://* lua user.term.buf_enter()
    au TermEnter * lua user.term.term_enter()
    au TermLeave * lua user.term.term_leave()
augroup END]])

-- terminal in new tab
vim.cmd("command! TabTerm tab vs | terminal")

-- split in new tab
vim.cmd("command! Tnew tab vs")

-- spell
vim.cmd("command! Fsp se spell!")
vim.cmd("command! Fid se spell | se spelllang=id")
vim.cmd("command! Fen se spell | se spelllang=en_us")

-- HTML
vim.g.html_indent_script1 = "auto"
vim.g.html_indent_style1 = "auto"
vim.g.html_indent_attribute = 0
