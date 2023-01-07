local MOD = require('lint')

MOD.linters_by_ft = {
    sh = {'shellcheck'},
    rust = {'clippy'},
    bash = {'shellcheck'},
    python = {'pylint'},
    c = {'cppcheck'},
    lua = {'luacheck'},
}

local group = vim.api.nvim_create_augroup('lint', {})
user.lint_toggle = function()
    local id = vim.api.nvim_get_current_buf()
    local pattern = '<buffer=' .. id .. '>'
    local aucmds = vim.api.nvim_get_autocmds({group='lint', pattern=pattern})
    if next(aucmds) then
        vim.api.nvim_del_autocmd(aucmds[1].id)
        vim.diagnostic.reset(nil, id)
    else
        MOD.try_lint()
        vim.api.nvim_create_autocmd({'BufWritePost'}, {
            group = group,
            pattern = pattern,
            callback = function() MOD.try_lint() end,
        })
    end
end

vim.api.nvim_create_autocmd({'FileType'}, {
    pattern = 'sh,python',
    group = 'user',
    callback = function() user.lint_toggle() end,
})

---- custom linters -----------------------------------------------------------

-- python: pylint
require('lint.linters.pylint').args = {
    '--disable', 'C0103', -- :invalid-name
    '--disable', 'C0112', -- :empty-docstring
    '--disable', 'C0114', -- :missing-module-docstring
    '--disable', 'C0115', -- :missing-class-docstring
    '--disable', 'C0116', -- :missing-function-docstring
    '--disable', 'W0622', -- :redefined-builtin
    '-f', 'json'
}

-- rust: clippy
local format = '%E%f:%l:%c: %\\d%#:%\\d%# %.%\\{-}'
format = format .. 'error:%.%\\{-} %m,%W%f:%l:%c: %\\d%#:%\\d%# %.%\\{-}'
format = format .. 'warning:%.%\\{-} %m,%C%f:%l %m,%-G,%-G'
format = format .. 'error: aborting %.%#,%-G'
format = format .. 'error: Could not compile %.%#,%E'
format = format .. 'error: %m,%Eerror[E%n]: %m,%-G'
format = format .. 'warning: the option `Z` is unstable %.%#,%W'
format = format .. 'warning: %m,%Inote: %m,%C %#--> %f:%l:%c'

MOD.linters.clippy = {
    cmd = 'clippy-driver',
    stdin = false,
    args = {},
    stream = 'both',
    ignore_exitcode = true,
    env = nil,
    parser = require('lint.parser').from_errorformat(format)
}
