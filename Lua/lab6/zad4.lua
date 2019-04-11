#!/usr/bin/env lua

package.path = '../lib/?.lua;'..package.path
lib = require"lib"

CVector = {}
setmetatable(CVector, {["__call"] = function(...) return CVector.new(select(2, ...)) end})

function CVector.new(data)
    if data == nil then error('nil') end
    if data.len ~= nil and data.table ~= nil then data = data.table end
    local vec = {}
    vec.len = table.maxn(data)
    vec.table = data
    return setmetatable(vec, {__index = CVector})
end

function CVector:at(i)
    if i > self.len then error('wrong index') end
    return self.table[i+1]
end

function CVector:clear()
    self.len = 0
    self.table = {}
end 

function CVector:empty()
    return self.len == 0
end

function CVector:push_back(val)
    self.table[self.len+1] = val
    self.len = self.len + 1
end

function CVector:pop_back()
    if self.len == 0 then error('vector is empty') end
    self.len = self.len - 1
    self.table[self.len+1] = nil
    return self.table[self.len+1]
end

function CVector:tostring()
    local res = "["
    for i=1, self.len-1 do
        if self.table[i] == nil then res = res .. 'nil' .. ', '
        else res = res .. self.table[i] .. ', ' end
    end
    if self.table[self.len] == nil then return res .. 'nil]' end
    return res .. self.table[self.len] .. ']'
end

function CVector:erase(i, j)
    if j == nil then j = self.len+1 end
    if j < i then return end
    local n_data = {}
    for k=1, i do data[k] = self.table[k] end
    for k=j, self.len do data[k] = selftable[k] end
    self.table = n_data
    self.len = self.len - (j - i)
end

function CVector:insert(i, e)
    if i < 0 or i > self.len then error('wrong index') end
    local n_data = {}
    local cnt = 0
    for k=1, i do n_data[k] = self.table[k]; cnt = cnt + 1 end
    if e == nil then error('nil') end
    if e.len ~= nil and e.table ~= nil then e = e.table end    
    for k=1, #e do n_data[cnt+1] = e[k]; cnt = cnt + 1 end
    for k=i+1, self.len do n_data[cnt+1] = self.table[k]; cnt = cnt + 1 end
    self.table = n_data
    self.len = cnt
end

function CVector:size()
    return self.len
end

local v = CVector{'a','d','e'}
local w = CVector(v)

print(v:tostring(), w:tostring())
print(v:empty(), CVector{}:empty())
v:insert(1, {2,3})
print(v:tostring())
print(v:pop_back())
print(v:tostring())
print(v:size())
v:push_back(nil)
print(v:tostring())
print(v:size())
print(w:tostring())
v:insert(5, w)
print(v:tostring())
print(v:size())
