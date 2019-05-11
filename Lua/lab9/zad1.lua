#!/usr/bin/env lua


package.path = '../lib/?.lua;'..package.path
lib = require"lib"

local fun = require'funcs'

print('summation tests')
print(fun.summation(1, 2, 3, 3.14, -10))
print(fun.summation())
--print(fun.summation(1,2,"test", 3))
print('filter tests')
lib.printf(fun.filter(function(x) return x > 10 end, {11,0,12,3}))
lib.printf(fun.filter(function(x) return x[#x] == 3 end, {{1,2,3},{4,5,6},{3}, {1,2,6}}))
print('reverse tests')
lib.printf(fun.reverse({1,2,3,{1,3}}))
lib.printf(fun.reverse({1,2,{1,3}}))
print('join tests')
lib.printf(fun.join({1}, {2,3}, {4,5,6}, {7,8,9,10}))
lib.printf(fun.join({-1,10,221,21, 1}, {2,3}, {4,5,6}, {7,8,9,10}))
print('merge tests')
local res = fun.merge({['key1'] = 'val1', ['key2'] = 'val2'}, {['key1'] = 'be', ['key3'] = 'val3'}, {['key3'] = 'meh', ['key1'] = 'mee'}, {['key4'] = 'val4'})

for key, value in pairs(res) do
    print(key, "=>", value)
end
