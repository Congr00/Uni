#!/usr/bin/env lua

package.path = '../lib/?.lua;'..package.path
lib = require"lib"

Vector = {}
Vector.mt = {}
Vector.len_err = 'cant make operation on vectors of diff sizes'

setmetatable(Vector, {["__call"] = function(...) return Vector.new(select(2, ...)) end})

function Vector.new(list)
    local vect = {}
    for n, l in ipairs(list) do vect[n] = l end
    vect.len = #vect
    setmetatable(vect, Vector.mt)    
    return vect
end

function Vector.check(v)
    if getmetatable(v) ~= Vector.mt then
        error("Non vector variable")
    end
end

function Vector.add(v1, v2)
    Vector.check(v1)
    Vector.check(v2)
    if v1.len ~= v2.len then
        error(Vector.len_err)
    end
    local res = {}
    for _, l in ipairs(v1) do
        res[#res+1] = l + (v2[#res+1])
    end
    return Vector.new(res)
end

function Vector.minus(v)
    Vector.check(v)
    return v * -1
end

function Vector.sub(v1, v2) 
    return v1 + (-v2)
end

function Vector.mul(v1, v2)
    -- scalar mul
    if type(v1) == 'number' or type(v2) == 'number' then
        v1, v2 = Vector.scalarswitch(v1, v2)
        local res = {}
        for _, l in ipairs(v1) do res[#res+1] = l * v2 end
        return Vector.new(res)
    end
    -- vector dot product
    Vector.check(v1)
    Vector.check(v2)

    if v1.len ~= v2.len then error(Vector.len_err) end

    local res = 0
    for n = 1, v1.len do res = res + (v1[n]*v2[n]) end
    return res
end

function Vector.scalarswitch(v1, v2)
    if type(v1) ~= 'number' then
        if type(v2) ~= 'number' then
            error('no scalar values')
        end
        Vector.check(v1)
        return v1, v2
    else
        Vector.check(v2)
        return v2, v1        
    end    
end

function Vector.div(v1, v2)
    v1, v2 = Vector.scalarswitch(v1, v2)
    local res = {}
    for _, l in ipairs(v1) do res[#res+1] = l / v2 end
    return Vector.new(res)    
end

function Vector.tostring(v)
    local res = "("

    for n=1, v.len do
        res = res .. v[n] .. ','
        if n == v.len-1 then break end
    end 
    return res .. v[v.len] .. ")"
end

function Vector.cat(v1, v2)
    return tostring(v1) .. tostring(v2)
end

function Vector.lenop(v)
    -- 2nd vector norm
    local res = 0
    for _, l in ipairs(v) do res = res + l ^ 2 end 
    return math.sqrt(res)    
end

function Vector.index(v, key)
    return rawget(v, key)
end

function Vector.ipairs(v)
    Vector.check(v)
    return function(t, i)        
    local vec = t[1]
    local i = t[2]
    if i > vec.len then return nil end
    t[2] = t[2] + 1
    return Vector.base(i, vec.len), vec[i]
    end, {v, 1}, _
end

function Vector.base(k, n)
    local res = {}
    for i=1,n do
        if i == k then res[i] = 1
        else res[i] = 0 end
    end
    return Vector.new(res)
end

Vector.mt.__add = Vector.add
Vector.mt.__sub = Vector.sub
Vector.mt.__mul = Vector.mul
Vector.mt.__div = Vector.div
Vector.mt.__unm = Vector.minus
Vector.mt.__tostring = Vector.tostring
Vector.mt.__concat = Vector.cat
Vector.mt.__len = Vector.lenop
Vector.mt.__index = Vector.index
Vector.mt.__ipairs = Vector.ipairs

Vector.mt.__eq = function(v1, v2)
    for l=1, v1.len do
        if v1[l] ~= v2[l] then
            return false
        end
    end
    return true
end

print(Vector{1,2,3} + Vector{-2,0,4})
print(Vector{1,2,3} * 2)
print(2 * Vector{1,2,3})
print(Vector{1,2,3} * Vector{2,2,-1})
print('norm: ' .. #Vector{4,3})
print(-Vector{1,2,3})
print(Vector{3,3,3} / 3)
print(Vector{3,12,1} - Vector{4,2,1})

print(Vector{1,2,3} * 2 == 3 * Vector{1,2,3})

print(Vector{1,2,3} * 2 == 2 * Vector{1,2,3})
print(Vector{3,4,5,6}[3])

for k, v in ipairs(Vector{2,2,3,5,7}) do print(k, '->', v) end