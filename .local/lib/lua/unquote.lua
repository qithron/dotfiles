-- Date: Fri, 30 Aug 2024 03:55:13 +0000
--
-- Return a function to decode percent encoding string.

return function(str)
    if str ~= nil then
        str = string.gsub(str, "%%(%x%x)", function(hex)
            return string.char(tonumber(hex, 16))
        end)
    end
    return str
end
