vim.api.nvim_set_hl(0, "Indent", {
    force = true,
    ctermfg = 8,
    ctermbg = nil,
})

require("ibl").setup {
    indent = {
        highlight = "Indent",
        char = { "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₀" },
    },
}
