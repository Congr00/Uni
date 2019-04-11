#!/usr/bin/env lua

package.path = '../lib/?.lua;'..package.path
lib = require"lib"

function chain(...)
    local args = {}
    for n, k in ipairs({...}) do
        args[n] = {}
        for _, l in ipairs(k) do table.insert(args[n], l) end
    end
    return function(state)
        while true do
            if state[1] == nil then
                return nil 
            elseif #state[1] == 0 then
                table.remove( state, 1)
            else
                break
            end
        end
        local res = state[1][1]
        table.remove(state[1], 1)
        return res
    end, args
end

y = {'a', 'b', 'c'}

for x in chain(y, {40, 50}, {}, {6, 7}, {}) do
    print(x)
end

lib.printf(y)

for _ in chain() do
    print(_)
end

