local join_path = require("mp.utils").join_path

mp.add_key_binding(nil, "mark", function()
    local path = join_path(
        mp.get_property_native("working-directory"),
        mp.get_property_native("path"))

    mp.command_native({
        name = "subprocess",
        args = { "mpv-mark", path },
        detach = true,
    })
end)
