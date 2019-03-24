#!/usr/bin/env lua

utf8.normalize = function(string)
    local result = ''
    for _, c in utf8.codes(string) do
        if c <= 127 then
            result = result..string.char(c)
        end
    end
    return result
end

print(utf8.normalize('Księżyc:\nNów'))