return require("packer").startup(function(use)

    use "wbthomason/packer.nvim"

    use "nvim-lualine/lualine.nvim"

    use "mfussenegger/nvim-lint"

    use "kyazdani42/nvim-tree.lua"

    use {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },

            -- Autocompletion
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
        }
    }

end)
