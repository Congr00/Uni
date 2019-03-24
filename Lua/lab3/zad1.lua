#!/usr/bin/env lua

function reverse(arr)
    local i,j = 1, #arr
    while i < j do
        arr[i], arr[j] = arr[j], arr[i]
        i = i+1
        j = j-1
    end
end

utf8.reverse = function(string)
    local codes = table.pack(utf8.codepoint(string, 1, -1))
    reverse(codes)
    return utf8.char(table.unpack(codes))
end

print(utf8.reverse('Księżyc'))
print(utf8.reverse('Ksiezyc'))
print(utf8.reverse('ĄŻĆÓąź'))