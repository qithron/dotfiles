local MOD = require('nvim-treesitter.configs')

MOD.setup({
    ensure_installed = {
        "c", "lua", "rust", "python",
        "fish", "bash", "vim",
        "html", "markdown", "help",
    },
    auto_install = true,
    highlight = {
        enable = true,
        disable = {},
    }
})
