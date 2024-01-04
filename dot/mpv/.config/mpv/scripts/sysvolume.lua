mp.utils = require("mp.utils")

local function vol(arg)
    os.execute("volume " .. arg)
end

mp.add_key_binding(nil, "inc", function() vol("+5") end)
mp.add_key_binding(nil, "dec", function() vol("-5") end)
mp.add_key_binding(nil, "inc_low", function() vol("+1") end)
mp.add_key_binding(nil, "dec_low", function() vol("-1") end)
