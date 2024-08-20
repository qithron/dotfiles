local lint = require("lint")
local group = vim.api.nvim_create_augroup("lint", { clear = false })

local function toggle()
    local id = vim.api.nvim_get_current_buf()
    local pattern = string.format("<buffer=%d>", id)
    local aucmds = vim.api.nvim_get_autocmds({
        group = group,
        pattern = pattern,
    })

    if next(aucmds) then
        vim.api.nvim_del_autocmd(aucmds[1].id)
        vim.diagnostic.reset(nil, id)
        return
    end

    lint.try_lint()
    vim.api.nvim_create_autocmd({
        "BufWritePost", "FileChangedShellPost"
    }, {
        group = group,
        pattern = pattern,
        callback = function() lint.try_lint() end,
    })
end

lint.linters_by_ft = {
    bash = { "shellcheck" },
    dash = { "shellcheck" },
    sh = { "shellcheck" },
    zsh = { "zsh" },
}

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = group,
    pattern = "sh,zsh,bash",
    callback = toggle,
})

vim.api.nvim_create_user_command("LintToggle", toggle, {})
vim.api.nvim_create_user_command("LintToggleAll", function()
    local aucmds = vim.api.nvim_get_autocmds({
        group = group,
        pattern = "*",
    })

    if next(aucmds) then
        vim.api.nvim_del_autocmd(aucmds[1].id)
        vim.diagnostic.reset()
        return
    end

    lint.try_lint()
    vim.api.nvim_create_autocmd({
        "BufReadPost", "BufWritePost", "FileChangedShellPost"
    }, {
        group = group,
        pattern = "*",
        callback = function() lint.try_lint() end,
    })
end, {})
