local function volume(arg)
    mp.command_native({
        name = "subprocess",
        args = { "volume", arg },
        detach = true,
    })
end

mp.add_key_binding(nil, "inc", function(x) volume("+" .. x) end)
mp.add_key_binding(nil, "dec", function(x) volume("-" .. x) end)
