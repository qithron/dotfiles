--[[
Simple playlist interface for both terminal and GUI mode, but prefer GUI mode.

Add line below to your input.conf to show the playlist via key e:
e script-binding simple_playlist_interface/show

Some temporary keys available when playlist visible:
+-------+-------
| o     | open selected entry
| ENTER | open selected entry
| ESC   | hide playlist
| k     | move up
| UP    | move up
| j     | move down
| DOWN  | move down
+-------+--------
--]]

local function unquote(str)
    if str ~= nil then
        str = string.gsub(str, "%%(%x%x)", function(hex)
            return string.char(tonumber(hex, 16))
        end)
    end
    return str
end

local opts = {
    -- Show only file base name?
    base_name_only = true,

    -- Playlist entry and selected entry format.
    gui_entry_format  = "  %s",
    gui_cursor_format = "> %s",
    term_entry_format  = "%s",
    term_cursor_format = "%s",

    -- This is terminal 256 colors.
    term_entry_color = 7,
    term_cursor_color = 10,

    -- Max number of characters, 0 = auto.
    gui_width = 0,
    term_width = 0,

    -- Max number of lines, 0 = auto.
    gui_height = 0,
    term_height = 0,

    -- Automatically hide playlist, 0 = never.
    -- TODO
    auto_hide = 5,

    -- Multiple keys can be set by separate them with space.
    -- This key bindings only available when playlist visible.
    keybinds_hide = "ESC",
    keybinds_open = "o ENTER",
    keybinds_move_up = "k UP",
    keybinds_move_down = "j DOWN",
}

require("mp.options").read_options(opts)

local cursor = 0
local scroll = 0
local kbd = {}

local function add_forced_key_bindings()
    for i = 1, #kbd do
        mp.add_forced_key_binding(kbd[i][1], kbd[i][2], kbd[i][3])
    end
end

local function del_forced_key_bindings()
    for i = 1, #kbd do
        mp.remove_key_binding(kbd[i][2])
    end
end

local timer = mp.add_periodic_timer(opts.auto_hide, del_forced_key_bindings)
timer:kill()
timer.oneshot = true

local function get_osd_size()
    local on_term = false
    local font_size = mp.get_property_number("osd-font-size", 0)
    if font_size < 1 then
        font_size = 1
    end

    local width = mp.get_property_number("osd-dimensions/w", 0)
    if width < 1 then
        on_term = true
        width = mp.get_property_number("term-size/w", 0)
        if width < 1 then
            width = 0
        elseif opts.term_width > 0 then
            width = opts.term_width
        end
    elseif opts.gui_width > 0 then
        width = opts.gui_width
    else
        width = width / (font_size / 2)
    end

    local height = mp.get_property_number("osd-dimensions/h", 0)
    if height < 1 then
        on_term = true
        height = mp.get_property_number("term-size/h", 0) - 1
        if height < 1 then
            height = 0
        elseif opts.term_height > 0 then
            height = opts.term_height
        end
    elseif opts.gui_height > 0 then
        height = opts.gui_height
    else
        height = height / font_size
    end

    return width, height, on_term
end

local function make_line(index, max_width, is_cursor, on_term, fmt)
    local name = mp.get_property_native("playlist/"..index.."/filename", "")

    if name:match("^https?://") then
        name = name:match("^[^?]*")
        name = unquote(name)
    end

    if opts.base_name_only then
        name = name:match("[^/]*$")
    end

    fmt = fmt()

    if #fmt - 2 + #name > max_width then
        max_width = max_width - (#fmt - 2)

        local rem = max_width % 2
        local pre_len = (max_width - rem) / 2
        local suf_len = pre_len - 1

        if rem == 0 then
            suf_len = suf_len - 1
        end

        name = name:sub(1, pre_len) .. "…" .. name:sub(#name - suf_len)
    end

    if on_term then
        local color
        if is_cursor then
            color = opts.term_cursor_color
        else
            color = opts.term_entry_color
        end
        name = ("\x1b[38;5;%dm%s\x1b[0m"):format(color, name)
    end

    return fmt:format(name)
end

local function show_playlist()
    local playlist_max_index = mp.get_property_number("playlist-count", 0) - 1

    if playlist_max_index < 0 then
        return
    end

    if cursor > playlist_max_index then
        cursor = 0
    elseif cursor < 0 then
        cursor = playlist_max_index
    end

    local width, height, on_term = get_osd_size()
    if width == 0 or height == 0 then
        return
    end

    if height > playlist_max_index then
        height = playlist_max_index + 1
    end

    if cursor < scroll then
        scroll = cursor
    elseif cursor >= scroll + height then
       scroll = cursor - height + 1
    end

    local index = scroll
    local lines = {}

    for _ = 1, height, 1 do
        local is_cursor = index == cursor
        local line = make_line(index, width, is_cursor, on_term, function()
            if is_cursor then
                if on_term then
                    return opts.term_cursor_format
                else
                    return opts.gui_cursor_format
                end
            else
                if on_term then
                    return opts.term_entry_format
                else
                    return opts.gui_entry_format
                end
            end
        end)

        index = index + 1
        lines[#lines + 1] = line
    end

    timer:kill()
    timer:resume()
    add_forced_key_bindings()
    mp.osd_message(table.concat(lines, "\n"), opts.auto_hide)
end

local function hide_playlist()
    timer:kill()
    del_forced_key_bindings()
    mp.osd_message("")
end

local function move_up()
    cursor = cursor - 1
    show_playlist()
end

local function move_down()
    cursor = cursor + 1
    show_playlist()
end

local function open()
    hide_playlist()
    mp.commandv("script-binding", "random/tmp_disable")
    mp.set_property_number("playlist-pos", cursor)
end

mp.register_event("file-loaded", function()
    if timer:is_enabled() then
        hide_playlist()
    end
    mp.commandv("script-binding", "random/restore")
    cursor = mp.get_property_number("playlist-pos", 0)
end)

local keybind_name_prefix = "simple_playlist_interface_"

for k in opts.keybinds_hide:gmatch("%w+") do
    table.insert(kbd, { k, keybind_name_prefix .. #kbd, hide_playlist })
end

for k in opts.keybinds_open:gmatch("%w+") do
    table.insert(kbd, { k, keybind_name_prefix .. #kbd, open })
end

for k in opts.keybinds_move_up:gmatch("%w+") do
    table.insert(kbd, { k, keybind_name_prefix .. #kbd, move_up })
end

for k in opts.keybinds_move_down:gmatch("%w+") do
    table.insert(kbd, { k, keybind_name_prefix .. #kbd, move_down })
end

mp.add_key_binding(nil, "show", show_playlist)
