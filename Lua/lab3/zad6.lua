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


function lreverser(source, target)

    if source ~= nil then
        io.input(assert(io.open(source, 'r')))
    end
    if target ~= nil then
        io.output(assert(io.open(target, 'w')))
    end

    local mem = {}
    local i = 1
    for line in io.lines() do
        mem[i] = line
        i = i+1
    end


    for j=#mem, 1, -1 do
        io.write(mem[j])
        io.write('\n')
    end

    io.output():close()
    io.input():close()
end

lreverser('zad6_in.txt', 'zad6_out.txt')
lreverser()
--lreverser('zad6_out.txt')