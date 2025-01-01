vim.api.nvim_create_user_command("Lsp", function()
    local lsp = require("lsp-zero").preset({
        name = "system-lsp",
        suggest_lsp_servers = false,
        manage_luasnip = true,
        manage_nvim_cmp = true,
        sign_icons = { error = "E", warn = "W", hint = "H", info = "I" }
    })

    local cmp = require("cmp")
    cmp.setup({
        view = {
            docs = {
                auto_open = false
            }
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
            ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
        }),
    })

    lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = true }
        local map = vim.keymap.set
        local buf = vim.lsp.buf

        map("i", "<A-c>", cmp.complete, opts)
        map("n", "<LEADER>/", buf.workspace_symbol, opts)
        map("n", "<LEADER>a", buf.code_action, opts)
        map("n", "<LEADER>ref", buf.references, opts)
        map("n", "<LEADER>ren", buf.rename, opts)
        map("n", "gd", buf.definition, opts)
        map("n", "gt", buf.type_definition, opts)
        map("n", "K", buf.hover, opts)
    end)

    lsp.configure("lua_ls", {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim", "mp" },
                },
            }
        }
    })
    lsp.configure("rust_analyzer")

    lsp.setup()
    vim.cmd("LspStart")
    vim.api.nvim_del_user_command("Lsp")

    for _, method in ipairs({ "textDocument/didChange", "textDocument/diagnostic", "workspace/diagnostic" }) do
        local default_diagnostic_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context, config)
            if err ~= nil --[[or err.code == -32802]] then
                return
            end
            return default_diagnostic_handler(err, result, context, config)
        end
    end
end, {})
