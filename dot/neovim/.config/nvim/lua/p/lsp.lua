local lsp = require("lsp-zero").preset({
    name = "recommended",
    suggest_lsp_servers = false,
    manage_luasnip = true,
    manage_nvim_cmp = true,
    sign_icons = { error = "E", warn = "W", hint = "H", info = "I" }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>h", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>dn", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>dN", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>/", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>ref", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>ren", function() vim.lsp.buf.rename() end, opts)
end)

lsp.setup()
vim.diagnostic.config({ virtual_text = true })
vim.cmd("LspStart")
