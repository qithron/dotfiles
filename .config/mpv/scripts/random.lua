local to_string = require("mp.utils").to_string
local opts = {
    enable = false,
    keep_episode = true,
}

require("mp.options").read_options(opts)

local prev_index = 1
local prev_title = ""
local prev_value = opts.enable

local function random_index()
    local count = mp.get_property_number("playlist-count")
    local index

    for _ = 1, count do
        index = math.random(count)
        if index ~= prev_index then
            break
        end
    end

    return index
end

local function get_entry_title_at(index)
    return mp.get_property_native("playlist/" .. index-1 .. "/filename", ".")
        :gsub("^[^/]+/", "") -- basename
        :gsub(" S%d*P? ", " ") -- common suffix
        :gsub(" %[%d%d*%] .*", "") -- sequence number
end

local function keep_episode()
    local index = prev_index + 1
    if prev_title == get_entry_title_at(index) then
        return index
    end

    for _ = 1, 9 do
        index = random_index()
        if prev_title ~= get_entry_title_at(index) then
            break
        end
    end

    local title = get_entry_title_at(index)
    if title == nil then
        return random_index()
    end

    while title == get_entry_title_at(index - 1) do
        index = index - 1
    end

    prev_title = title
    return index
end

mp.add_hook("on_after_end_file", 50, function()
    if not opts.enable then
        return
    end

    local index
    if opts.keep_episode then
        index = keep_episode()
    else
        index = random_index()
    end

    prev_index = index
    mp.set_property_number("playlist-pos-1", index)
end)

local function toggle(v)
    if v == nil then
        v = not opts.enable
    end

    opts.enable = v
    prev_value = opts.enable
    mp.osd_message("Random: " .. to_string(opts.enable))
end

local function toggle_episode(v)
    if v == nil then
        v = not opts.keep_episode
    end

    opts.keep_episode = v
    mp.osd_message("Random Keep Episode: " .. to_string(opts.keep_episode))
end

local function restore()
    opts.enable = prev_value

    local index = mp.get_property_number("playlist-pos-1", 1)
    local title = get_entry_title_at(index)
    if title ~= nil then
        prev_title = title
    end
    prev_index = index
end

local function next_episode()
    prev_title = ""
    mp.command("playlist-next")
end

mp.add_key_binding(nil, "toggle", toggle)
mp.add_key_binding(nil, "toggle_keep_episode", toggle_episode)
mp.add_key_binding(nil, "enable", function() toggle(true) end)
mp.add_key_binding(nil, "disable", function() toggle(false) end)
mp.add_key_binding(nil, "tmp_disable", function() opts.enable = false end)
mp.add_key_binding(nil, "restore", restore)
mp.add_key_binding(nil, "next_episode", next_episode)
