local MOD = require('lint')
local USR = {}

-------------------------------------------------------------------------------
-- TODO use this globaly by default
-- :h watch-file
local w = vim.loop.new_fs_event()
local function on_change(err, fname, status)
    -- Do work...
    vim.api.nvim_command('checktime')
    -- Debounce: stop/start.
    w:stop()
    user.watch_file(fname)
end
user.watch_file = function(fname)
    local fullpath = vim.api.nvim_call_function('fnamemodify', {fname, ':p'})
    w:start(fullpath, {}, vim.schedule_wrap(function(...)
        on_change(...) end))
end
vim.api.nvim_command(
    "command! -nargs=1 Watch call luaeval('user.watch_file(_A)', expand('<args>'))")
-------------------------------------------------------------------------------

MOD.linters_by_ft = {
    sh = {'shellcheck'},
    rust = {'rust_lint'},
    bash = {'shellcheck'},
    python = {'pylint'},
    c = {'cppcheck'},
    lua = {'luacheck'},
}

local group = vim.api.nvim_create_augroup('lint', {})
USR.toggle = function()
    local id = vim.api.nvim_get_current_buf()
    local pattern = '<buffer=' .. id .. '>'
    local aucmds = vim.api.nvim_get_autocmds({group='lint', pattern=pattern})
    if next(aucmds) then
        vim.api.nvim_del_autocmd(aucmds[1].id)
        vim.diagnostic.reset(nil, id)
    else
        MOD.try_lint()
        vim.api.nvim_create_autocmd({
                'BufWritePost', 'FileChangedShellPost'
            }, {
                group = group,
                pattern = pattern,
                callback = function() MOD.try_lint() end,
        })
    end
end

USR.toggle_all = function()
    local aucmds = vim.api.nvim_get_autocmds({group='lint', pattern='*'})
    if next(aucmds) then
        vim.api.nvim_del_autocmd(aucmds[1].id)
        vim.diagnostic.reset()
    else
        MOD.try_lint()
        vim.api.nvim_create_autocmd({
                'BufReadPost', 'BufWritePost', 'FileChangedShellPost'
            }, {
                group = group,
                pattern = '*',
                callback = function() MOD.try_lint() end,
        })
    end
end

USR.try_lint = function()
    MOD.try_lint()
end

USR.clear_all = function()
    vim.diagnostic.reset()
end

vim.api.nvim_create_autocmd({'FileType'}, {
    pattern = 'sh,python',
    group = 'user',
    callback = function() user.lint.toggle() end,
})

---- custom linters -----------------------------------------------------------

-- python: pylint
MOD.linters.pylint.cmd = 'pylint-default'

-- rust: rust_lint
local format = '%E%f:%l:%c: %\\d%#:%\\d%# %.%\\{-}'
            .. 'error:%.%\\{-} %m,%W%f:%l:%c: %\\d%#:%\\d%# %.%\\{-}'
            .. 'warning:%.%\\{-} %m,%C%f:%l %m,%-G,%-G'
            .. 'error: aborting %.%#,%-G'
            .. 'error: Could not compile %.%#,%E'
            .. 'error: %m,%Eerror[E%n]: %m,%-G'
            .. 'warning: the option `Z` is unstable %.%#,%W'
            .. 'warning: %m,%Inote: %m,%C %#--> %f:%l:%c'

MOD.linters.rust_lint = {
    cmd = 'rust-vim-lint',
    stdin = false,
    append_fname = true,
    args = {},
    stream = 'both',
    ignore_exitcode = false,
    env = nil,
    parser = require('lint.parser').from_errorformat(format)
}

user.lint = USR
