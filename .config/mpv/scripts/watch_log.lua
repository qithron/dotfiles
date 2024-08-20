local opts = {
    -- colon separated
    filter = "",
    log_file = mp.command_native({ "expand-path", "~~state/" }) .. "/watch-log.txt",
}

require("mp.options").read_options(opts)

mp.add_hook("on_unload", 50, function()
    local per = mp.get_property_number("percent-pos")
    if per == nil or per <= 90 then
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

    local path = mp.get_property_native("path")

    if is_path_incorrect(path) then
        if path:match("^/") ~= nil then
            return
        end

        path = mp.get_property_native("working-directory")
        if is_path_incorrect(path) then
            return
        end
    end

    local file = io.open(opts.log_file, "a")
    if file == nil then
        return
    end

    local sp = mp.command_native({
        name = "subprocess",
        playback_only = false,
        capture_stdout = true,
        args = { "date", "+%Y%m%d%H%M%S" },
    })

    if sp.status ~= 0 then
        return
    end

    file:write(string.format("%s %s\n", sp.stdout:match("%d*"), mp.get_property("filename/no-ext")))
    file:flush()
    file:close()
end)
