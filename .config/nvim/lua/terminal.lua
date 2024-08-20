vim.api.nvim_del_autocmd(vim.api.nvim_get_autocmds({
    group = "nvim_terminal",
    event = "TermClose",
    pattern = "*",
})[1].id)

local function term_close()
    if vim.call("winnr", "#") ~= 0 then
        vim.api.nvim_feedkeys("\x1c\x0e", "n", false)
    end
end

local function term_enter()
    if vim.call("winnr", "#") == 0 then
        vim.cmd("set ch=0 ls=0")
    else
        vim.keymap.set("t", "<A-e>", "<C-\\><C-N>:ToggleBufExplorer<CR>")
        vim.keymap.set("t", "<A-h>", "<C-\\><C-N><C-w>h")
        vim.keymap.set("t", "<A-j>", "<C-\\><C-N><C-w>j")
        vim.keymap.set("t", "<A-k>", "<C-\\><C-N><C-w>k")
        vim.keymap.set("t", "<A-l>", "<C-\\><C-N><C-w>l")
    end
end

local function term_leave()
    if vim.call("winnr", "#") == 0 then
        vim.cmd("set ch=1 ls=2")
    else
        vim.keymap.set("t", "<A-e>", ":ToggleBufExplorer<CR>")
        vim.keymap.del("t", "<A-h>")
        vim.keymap.del("t", "<A-j>")
        vim.keymap.del("t", "<A-k>")
        vim.keymap.del("t", "<A-l>")
    end
end

local function term_buf_enter()
    vim.cmd("startinsert")
    term_enter()
end

local function term_open()
    vim.cmd("setlocal nonu nornu scl=no")
    term_buf_enter()
end

local augroup = vim.api.nvim_create_augroup("u_terminal", {})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = augroup,
    pattern = "term://*",
    callback = term_buf_enter,
})

vim.api.nvim_create_autocmd({ "TermClose" }, {
    group = augroup,
    pattern = "*",
    callback = term_close,
})

vim.api.nvim_create_autocmd({ "TermEnter" }, {
    group = augroup,
    pattern = "*",
    callback = term_enter,
})

vim.api.nvim_create_autocmd({ "TermLeave" }, {
    group = augroup,
    pattern = "*",
    callback = term_leave,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
    group = augroup,
    pattern = "*",
    callback = term_open,
})
