mp.options = require("mp.options")
mp.utils = require("mp.utils")

local opt = {
    off = true
}

mp.options.read_options(opt)

local last_state = opt.off

mp.add_hook("on_after_end_file", 50, function(t)
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

    --mp.commandv("playlist-play-index", index)
    mp.set_property_number("playlist-pos", index)
end)

mp.add_key_binding(nil, "toggle", function()
    opt.off = not opt.off
    print(opt.off)
end)

mp.add_key_binding(nil, "disable", function()
    opt.off = true
end)

mp.add_key_binding(nil, "enable", function()
    opt.off = false
end)

mp.add_key_binding(nil, "save", function()
    last_state = opt.off
end)

mp.add_key_binding(nil, "restore", function()
    opt.off = last_state
end)
