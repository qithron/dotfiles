vim.api.nvim_del_autocmd(vim.api.nvim_get_autocmds({
    group = "nvim_terminal",
    event = "TermClose",
    pattern = "*",
})[1].id)

local function term_close()
    vim.api.nvim_feedkeys("\x1c\x0e", "n", false)
end

local function term_enter()
    if vim.call("winnr", "#") == 0 then
        vim.cmd("set ch=0 ls=0")
    end
end

local function term_leave()
    if vim.call("winnr", "#") == 0 then
        vim.cmd("set ch=1 ls=2")
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
