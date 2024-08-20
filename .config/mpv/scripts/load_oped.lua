local first_run = true

mp.add_hook("on_load", 50, function()
    if first_run then
        first_run = false
    else
        return
    end

    if mp.get_property_number("playlist-count", 0) ~= 1 then
        return
    end

    local fn = mp.get_property_native("filename", "")

    if fn:find("%[1%] N?C?OP") == nil then
        return
    end

    if fn:find("%[%d%d%]") then
        if fn:find("%[01%]") == nil then
            return
        end
    end

    local path = mp.get_property_native("path")

    local function get_dir_sep_pos()
        for i = #path, 1, -1 do
            if path:sub(i, i) == "/" then
                return i
            end
        end
        return 0
    end

    local dir_sep_pos = get_dir_sep_pos()
    local dir_name
    local base_name

    if dir_sep_pos == 0 then
        dir_name = "."
        base_name = path
    else
        dir_name = path:sub(1, dir_sep_pos-1)
        base_name = path:sub(dir_sep_pos+1)
    end

    local name_prefix = base_name:sub(1, base_name:find(" %[%d+%]")-1)

    local sp = mp.command_native({
        name = "subprocess",
        capture_stdout = true,
        args = { "sh", "-c", [[
            test -d "$1" || exit 1
            name=$(echo "$2" | sed -E 's/(\[|\]|\?|\*)/\\\1/g')
            find "$1" -name "$name \[[0-9]*\]*" | sort]],
            "--", dir_name, name_prefix
        },
    })

    if sp.status ~= 0 then
        return
    end

    local once = true
    local arg2 = "replace"
    for arg1 in sp.stdout:gmatch("[^\n]+") do
        mp.commandv("loadfile", arg1, arg2)
        if once then
            once = false
            arg2 = "append"
        end
    end
end)
