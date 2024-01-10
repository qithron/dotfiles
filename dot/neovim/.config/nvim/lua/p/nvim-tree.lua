local MOD = require("nvim-tree")
local Api = require("nvim-tree.api")

local function on_attach(bufnr)
    local opts = {buffer = bufnr, noremap = true, silent = true, nowait = true}
    vim.keymap.set("n", "i", Api.node.open.preview, opts)
    vim.keymap.set("n", "I", Api.node.open.edit, opts)
    vim.keymap.set("n", "p", Api.tree.change_root_to_node, opts)
end

MOD.setup({
    remove_keymaps = true,
    on_attach = on_attach,
})
