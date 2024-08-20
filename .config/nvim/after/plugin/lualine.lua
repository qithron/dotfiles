local lualine = require("lualine")

local col = {
    whi = "#ffffff",
    bla = "#000000",
    red = "#ff0000",
    yel = "#ffff00",
    gre = "#00ff00",
    cya = "#00ffff",
    blu = "#0000ff",
    mag = "#ff00ff",
}

local theme = {
    normal = {
        a = { fg = col.mag, bg = col.gre, gui = "bold" },
        b = { fg = col.whi, bg = nil },
        c = { fg = col.whi, bg = nil },
        z = { fg = col.whi, bg = nil }
    },
    insert = {
        a = { fg = col.blu, bg = col.yel, gui = "bold" },
        z = { fg = col.whi, bg = nil }
    },
    replace = {
        a = { fg = col.cya, bg = col.red, gui = "bold" },
        z = { fg = col.whi, bg = nil }
    },
    visual = {
        a = { fg = col.red, bg = col.cya, gui = "bold" },
        z = { fg = col.whi, bg = nil }
    },
    inactive = {
        a = { fg = col.bla, bg = col.whi },
        z = { fg = col.whi, bg = nil }
    }
}

local line_count = function()
    return vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf())
end

local word_count = function()
    return tostring(vim.fn.wordcount().words)
end

local filename = {
    "filename",
    symbols = {
        modified = "[+]",
        readonly = "[-]",
        unnamed = "[?]",
    },
    file_status = true,
    path = 1,
    shorting_target = 40,
}

local sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { filename },
    lualine_x = { "filetype", "encoding", "filesize", word_count, line_count },
    lualine_y = { "location" },
    lualine_z = { "progress" }
}

lualine.setup({
    options = {
        icons_enabled = false,
        theme = theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = " ", right = " " },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
    },
    sections = sections,
    inactive_sections = sections,
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
})
