local opts = {
    -- colon separated
    filter = "",
}

require("mp.options").read_options(opts)

mp.add_hook("on_unload", 50, function()
    local tp = mp.get_property_number("time-pos", 0)
    local tr = mp.get_property_number("time-remaining", 0)

    if tp < 120 or tr < 1 then
        return
    end

    if #opts.filter == 0 then
        return
    end

    local function is_path_incorrect(path)
        if path == nil then
            return true
        end

        for patt in string.gmatch(opts.filter, "[^:]+") do
            if path:match(patt) ~= nil then
                return false
            end
        end

        return true
    end

    local path = mp.get_property_native("path", nil)

    if is_path_incorrect(path) then
        if path:match("^/") ~= nil then
            return
        end

        path = mp.get_property_native("working-directory", nil)
        if is_path_incorrect(path) then
            return
        end
    end

    mp.command("write-watch-later-config")
end)
