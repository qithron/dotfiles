mp.add_key_binding(nil, "show", function()
    local path = mp.get_property_native("path", nil)
    if path == nil then
        return
    end
    mp.osd_message(path, 5000)
end)
