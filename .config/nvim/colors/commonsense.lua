--[[ Date: Sat, 31 Aug 2024 12:00:00 +0000

Color scheme for 16 color term, because using GUI is last thing I ever do.
But I tempted to use 256 color instead, because tty support it.
Bold and italic are disabled, for great font such as Terminus.

Quick test:
au BufWritePost * colorscheme commonsense
--]]

vim.cmd.highlight("clear")
vim.g.colors_name = "commonsense"

local function hi(name, ctermfg_or_link, ctermbg)
    local ctermfg, link

    if type(ctermfg_or_link) == "number" then
        ctermfg = ctermfg_or_link
    else
        link = ctermfg_or_link
    end

    vim.api.nvim_set_hl(0, name, {
        link = link,
        force = true,
        ctermfg = ctermfg,
        ctermbg = ctermbg,
    })
end

-- NOTE: background color should only use BLACK or DIM_*
local BLACK = 0
local DIM_RED = 1
local DIM_GREEN = 2
local DIM_YELLOW = 3
local DIM_BLUE = 4
local DIM_MAGENTA = 5
local DIM_CYAN = 6
local DIM_WHITE = 7
local GREY = 8
local RED = 9
local GREEN = 10
local YELLOW = 11
local BLUE = 12
local MAGENTA = 13
local CYAN = 14
local WHITE = 15

hi("Normal")

hi("ColorColumn", GREY, DIM_WHITE)
hi("LineNr", DIM_WHITE)
hi("LineNrAbove", DIM_RED)
hi("LineNrBelow", DIM_BLUE)

hi("Comment", "Normal")

hi("Constant", DIM_WHITE)
hi("String", GREY)
hi("Character", "String")
hi("Number", MAGENTA)
hi("Boolean", "Number")
hi("Float", "Number")

hi("Identifier", DIM_BLUE)
hi("Function", BLUE)

hi("Statement", "Normal")
hi("Conditional", "Keyword")
hi("Repeat", "Keyword")
hi("Label", "Keyword")
hi("Operator", "Keyword")
hi("Keyword", RED)
hi("Exception", "Keyword")

hi("PreProc", DIM_RED)
hi("Type", YELLOW)

hi("Special", DIM_MAGENTA)
hi("Delimiter", "Keyword")
hi("SpecialComment", DIM_WHITE)
hi("Debug", "Todo")

hi("Error", BLACK, DIM_RED)
hi("Todo", BLACK, DIM_YELLOW)

if vim.o.background ~= "light" then
    return
end

-- TODO: should depends on terminal color setting or define here?
hi("Normal", BLACK, DIM_WHITE)
