local opts = {
    -- colon separated
    filter = "",
    filter_always = "",
}

require("mp.options").read_options(opts)

local function do_filter(path, filter)
    if path == nil or #filter == 0 then
        return false
    end

    for patt in string.gmatch(filter, "[^:]+") do
        if patt == "*" or path:match(patt) ~= nil then
            mp.command("write-watch-later-config")
            return true
        end
    end

    return false
end

mp.add_hook("on_unload", 50, function()
    if mp.get_property_number("time-remaining", 1) < 2 then
        return
    end

    local time_pos = mp.get_property_number("time-pos", 0)
    if time_pos == 0 then
        return
    end

    local path = mp.get_property_native("path", nil)
    if do_filter(path, opts.filter_always) then
        return
    end

    local wdir = mp.get_property_native("working-directory", nil)
    if do_filter(wdir, opts.filter_always) then
        return
    end

    if time_pos < 30 then
        return
    end

    _ = do_filter(path, opts.filter) or do_filter(wdir, opts.filter)
end)
