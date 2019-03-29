#!/usr/bin/env lua

package.path = '../lib/?.lua;'..package.path
lib = require"lib"

function chain(...)
    local args = {...}
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

for x in chain({'a', 'b', 'c'}, {40, 50}, {}, {6, 7}, {}) do
    print(x)
end

for _ in chain() do
    print(_)
end

