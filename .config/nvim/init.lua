require("keybinds")
require("terminal")

vim.api.nvim_create_user_command("Ss", "set spell!", {})
vim.api.nvim_create_user_command("Si", "set spelllang=id", {})
vim.api.nvim_create_user_command("Se", "set spelllang=en", {})
vim.api.nvim_create_user_command("SortWord", -- TODO: not working
    [[call join(sort(split(getreg('"'))), ' ')]],
    { range = true })

vim.cmd.colorscheme("commonsense")

vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,"
               .. "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,"
               .. "sm:block-blinkwait175-blinkoff150-blinkon175"

vim.o.foldenable = false
vim.o.list = true
vim.o.listchars = "tab:→ ,trail:•"
vim.o.mouse = ""
vim.o.spell = false
vim.o.termguicolors = false
vim.o.timeout = false
vim.o.title = true
vim.o.titlestring = "nvim: %f"

vim.o.cmdheight = 1
vim.o.equalalways = false
vim.o.laststatus = 2
vim.o.scrolloff = 9
vim.o.showtabline = 0
vim.o.sidescrolloff = 0
vim.o.wrap = false

vim.o.colorcolumn = "80"
vim.o.number = false
vim.o.numberwidth = 2
vim.o.relativenumber = true
vim.o.signcolumn = "yes:1"

vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = false
vim.o.writebackup = true

vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.tabstop = 4

local lazy_nvim = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazy_nvim) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazy_nvim,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:", "ErrorMsg" }, { "\n" },
            { out, "WarningMsg" }, { "\n" },
            { "Press any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazy_nvim)

require("lazy").setup({
    { "akinsho/toggleterm.nvim", version = "*", config = true },
    { "lewis6991/gitsigns.nvim" },
    { "mfussenegger/nvim-lint" },
    { "mikavilpas/yazi.nvim", event = "VeryLazy" },
    { "nvim-lualine/lualine.nvim" },

    { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },

    { "nvim-lua/plenary.nvim" },
    { "j-morano/buffer_manager.nvim" },
})
