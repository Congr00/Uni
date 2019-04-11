#!/usr/bin/env lua

package.path = '../lib/?.lua;'..package.path
lib = require"lib"

function zip(...)
    local args = {}
    for n, k in ipairs({...}) do
        args[n] = {}
        for _, l in ipairs(k) do            
            table.insert(args[n], l)
        end
    end    
    
    return function(state)
        local res = {}
        for _, arr in ipairs(state) do
            if arr[1] == nil then
                return nil 
            end
            res[#res+1] = arr[1]      
            table.remove(arr, 1)
        end
        return table.unpack(res)
    end , args
end

for x, y in zip({'a', 'b', 'c', 'd'}, {40, 50, 60}) do 
    print(x, y)
end

for x, y in zip() do
    print(x,y)
end

for x, y, z in zip({1,2,3}, {'1', '2', '3'}, {4,5,6,8}) do
    print(x,y,z)
end

for x in zip({1,2,3}) do
    print(x)
end

print(zip({1,2,3}))
print(zip({1,2,3}, {'a,b,c', '231'}))
