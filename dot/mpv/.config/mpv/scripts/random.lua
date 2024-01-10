local mp = require('mp')
mp.options = require("mp.options")
mp.utils = require("mp.utils")

local opt = {
    off = true
}

local prev_value = opt.off

mp.options.read_options(opt)

mp.add_hook("on_after_end_file", 50, function()
    if opt.off then
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

local function save()
    prev_value = opt.off
end

local function toggle(off)
    if off == nil then
        opt.off = not opt.off
    else
        opt.off = off
    end

    save()
    mp.osd_message("Random: " .. mp.utils.to_string(not opt.off))
end

mp.add_key_binding(nil, "toggle", toggle)
mp.add_key_binding(nil, "enable", function() toggle(false) end)
mp.add_key_binding(nil, "disable", function() toggle(true) end)
mp.add_key_binding(nil, "tmp_disable", function() opt.off = true end)
mp.add_key_binding(nil, "save", save)
mp.add_key_binding(nil, "restore", function() opt.off = prev_value end)
