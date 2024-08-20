mp.add_key_binding(nil, "execute", function()
    mp.osd_message("executing ...")

    local d = "/data/data/is.xyz.mpv"
    local _, _, exit_code = os.execute("test -O " .. d)

    if exit_code ~= 0 then
        mp.msg.warn("directory not owned")
        return
    end

    local c = [[
    d=$1
    df=$d/files
    ds=$d/shared_prefs

    chmod 755 $d
    find $df $ds -user "$(whoami)" -type d -print0 | xargs -0 chmod a+x
    find $df $ds -user "$(whoami)"         -print0 | xargs -0 chmod a+r
    ]]

    mp.command_native({
        name = "subprocess",
        args = { "sh", "-c", c, "--", d },
        detach = true,
    })
end)
