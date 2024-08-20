local to_string = require("mp.utils").to_string
local opts = { enable = false }

require("mp.options").read_options(opts)
local prev_value = opts.enable

mp.add_hook("on_after_end_file", 50, function()
    if not opts.enable then
        return
    end

    math.randomseed(os.time())

    local count = mp.get_property_number("playlist-count")
    local index = math.random(0, count - 1)

    if count > 1 then
        local current_index = mp.get_property_number("playlist-pos") - 1

        if index == current_index then
            index = (index + 1) % count
        end
    end

    mp.set_property_number("playlist-pos", index)
end)

local function toggle(v)
    if v == nil then
        opts.enable = not opts.enable
    else
        opts.enable = v
    end

    prev_value = opts.enable
    mp.osd_message("Random: " .. to_string(opts.enable))
end

mp.add_key_binding(nil, "toggle", toggle)
mp.add_key_binding(nil, "enable", function() toggle(true) end)
mp.add_key_binding(nil, "disable", function() toggle(false) end)
mp.add_key_binding(nil, "tmp_disable", function() opts.enable = false end)
mp.add_key_binding(nil, "restore", function() opts.enable = prev_value end)
