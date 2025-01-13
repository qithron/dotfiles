local map = vim.keymap.set
vim.g.mapleader = " "

-- basic
map("", "<C-j>", "9j")
map("", "<C-k>", "9k")
map("", "<LEADER>", "<NOP>")
map("n", "<LEADER>l", ":noh<CR>")
map("n", "<LEADER>gh", ":Gitsigns preview_hunk<CR>")
map("n", "<LEADER>L", "/^$^<CR>")
map("n", "<LEADER>d", ":.!1datetime<CR>")
map("n", "<LEADER>f", "0ely$jv$")
map("n", "<LEADER>q", ":q<CR>")
map("n", "<LEADER>Q", ":q!<CR>")
map("n", "<LEADER>t", "/\\ctodo<CR>")
map("n", "<LEADER>w", ":w<CR>")
map("n", "<LEADER>i", ":Inspect<CR>")
map("n", "<A-e>", ":Yazi<CR>")
map("n", "<A-t>", ":ToggleTerm direction=float<CR>")
map("v", "F", ":!1py-format-words<CR>")
map("v", "T", ":sort i<CR>")

-- mouse scroll
for _, mode in pairs({ "n", "i", "v", "c", "t" }) do
    map(mode, "<ScrollWheelUp>", "<UP>")
    map(mode, "<ScrollWheelDown>", "<DOWN>")
end

-- command line mode
map("c", "<A-h>", "<UP>")
map("c", "<A-j>", "<RIGHT>")
map("c", "<A-k>", "<LEFT>")
map("c", "<A-l>", "<DOWN>")

-- github/ThePrimeagen/init.lua
map("x", "<LEADER>p", "\"_dP")
map("n", "<LEADER>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<LEFT><LEFT><LEFT>]])
map("v", "<LEADER>y", "\"+y")
map("n", "<LEADER>Y", "\"+Y")

-- diagnostic
map("n", "<LEADER>h", function() vim.diagnostic.open_float() end)
map("n", "<LEADER>n", function() vim.diagnostic.goto_next({
    severity = { min = vim.diagnostic.severity.WARN } }) end)
map("n", "<LEADER>p", function() vim.diagnostic.goto_prev({
    severity = { min = vim.diagnostic.severity.WARN } }) end)
map("n", "<LEADER>N", function() vim.diagnostic.goto_next({
    severity = { min = vim.diagnostic.severity.ERROR } }) end)
map("n", "<LEADER>P", function() vim.diagnostic.goto_prev({
    severity = { min = vim.diagnostic.severity.ERROR } }) end)

-- prev buffer
map("n", "<LEADER>`", ":b#<CR>")
map("n", "<A-`>", ":b#<CR>")
map("i", "<A-`>", "<ESC>:b#<CR>")

-- window focus
map("n", "<A-h>", "<C-w>h")
map("n", "<A-j>", "<C-w>j")
map("n", "<A-k>", "<C-w>k")
map("n", "<A-l>", "<C-w>l")
map("i", "<A-h>", "<ESC><C-w>h")
map("i", "<A-j>", "<ESC><C-w>j")
map("i", "<A-k>", "<ESC><C-w>k")
map("i", "<A-l>", "<ESC><C-w>l")

-- window resize
map("n", "<A-C-h>", ":vert resize -1<CR>", { silent = true })
map("n", "<A-C-l>", ":vert resize +1<CR>", { silent = true })
map("n", "<A-C-j>", ":resize +1<CR>", { silent = true })
map("n", "<A-C-k>", ":resize -1<CR>", { silent = true })

-- next tab
map("n", "<C-A-i>", "gt")
map("i", "<C-A-i>", "<ESC>gt")
map("t", "<C-A-i>", "<C-\\><C-N>gt")
map("n", "<S-Tab>", "gt")
map("i", "<S-Tab>", "<ESC>gt")
map("t", "<S-Tab>", "<C-\\><C-N>gt")

-- grep current word in current working dir
map("n", "<A-8>", function()
    local cword = vim.fn.expand("<cword>")
    if cword and #cword > 2 then
        vim.cmd(string.format([[exe '!grep -nrs "\<%s\>"']], cword))
    end
end, { silent = true })
