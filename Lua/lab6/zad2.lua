#!/usr/bin/env lua

package.path = '../lib/?.lua;'..package.path
lib = require"lib"

Frac = {}
Frac.mt = {}

setmetatable(Frac, {["__call"] = function(...) return Frac.new(select(2, ...)) end})

function Frac.new(f, d)
    local frac = {f,d}
    setmetatable(frac, Frac.mt)
    return Frac.cut(frac)
end

function Frac.cut(f)
    f = Frac.check(f)

    local gcd = lib.gcd(f[1], f[2])
    f[1] = f[1] / gcd
    f[2] = f[2] / gcd
    return f
end

function Frac.check(f)
    if math.type(f) == 'integer' then
        return Frac.new(f,1)
    end
    if getmetatable(f) ~= Frac.mt then
        error("Non frac variable")
    end
    return f
end

function Frac.add(f1, f2)
   if math.type(f1) == 'float' or math.type(f2) == 'float'  then
        return Frac.tofloat(f1) + Frac.tofloat(f2)
   end
   f1 = Frac.check(f1)
   f2 = Frac.check(f2)
   local lcm = lib.lcm(f1[2], f2[2])
   f1[1] = f1[1] * lcm / f1[2] + f2[1] * lcm / f2[2]
   f1[2] = lcm    
   return Frac.cut(f1)
end

function Frac.sub(f1, f2)
    if math.type(f1) == 'float' or math.type(f2) == 'float'  then
        return Frac.tofloat(f1) - Frac.tofloat(f2)
    end
    f1 = Frac.check(f1)
    f2 = Frac.check(f2)
    return Frac.add(f1, Frac.minus(f2))
end

function Frac.mul(f1, f2)
    if math.type(f1) == 'float' or math.type(f2) == 'float'  then
        return Frac.tofloat(f1) * Frac.tofloat(f2)
    end 
    f1 = Frac.check(f1)
    f2 = Frac.check(f2)
    f1[1] = f1[1] * f2[1]
    f1[2] = f1[2] * f2[2]
    return Frac.cut(f1)
end

function Frac.div(f1, f2)
    if math.type(f1) == 'float' or math.type(f2) == 'float'  then
        return Frac.tofloat(f1) / Frac.tofloat(f2)
    end
    f1 = Frac.check(f1)
    f2 = Frac.check(f2)
    local tmp = f2[1]
    f2[1] = f2[2]
    f2[2] = tmp
    return Frac.mul(f1, f2)
end

function Frac.minus(f)
    if math.type(f) == 'float' then
        return -f
    end       
    f = Frac.check(f)
    f[1] = -f[1]
    return f 
end

function Frac.pow(f, w)
    if math.type(w) ~= 'integer' then
        error('zly wykladnik potegowania')
    end
    if math.type(f) == 'float' then
        return math.pow(f, w)
    end 
    f = Frac.check(f)
    f[1] = math.pow(f[1], w)
    f[2] = math.pow(f[2], w)
    return Frac.cut(f)
end

function Frac.tofloat(f)
    if math.type(f) == 'float' then
        return f
    end
    f = Frac.check(f)
    return f[1] / f[2]
end

function Frac.tostring(f)
    if math.type(f) == 'float' then
        return f
    end       
    f = Frac.check(f)
    local div = math.floor(f[1] / f[2])
    if f[2] == 1 then
        return div
    end
    if div ~= 0 then
        f[1] = f[1] - div * f[2]
    end
    if div == 0 then return math.floor(f[1]) .. '/' .. math.floor(f[2]) end
    return div .. ' i ' .. math.floor(f[1]) .. '/' .. math.floor(f[2])
end

function Frac.cat(v1, v2)
    return tostring(v1) .. tostring(v2)
end

Frac.mt.__add = Frac.add
Frac.mt.__sub = Frac.sub
Frac.mt.__mul = Frac.mul
Frac.mt.__div = Frac.div
Frac.mt.__unm = Frac.minus
Frac.mt.__pow = Frac.pow
Frac.mt.__tostring = Frac.tostring
Frac.mt.__concat = Frac.cat
Frac.mt.__le = function(f1, f2)
    Frac.check(f1)
    Frac.check(f2)
    local lcm = lib.lcm(f1[2], f2[2])
    lcm = lcm / f1[2]
    f1[1] = f1[1] * lcm
    f2[1] = f2[1] * lcm
    return f1[1] <= f2[1]     
end
Frac.mt.__lt = function(f1, f2)
    return f1 <= f2 and not (f2 <= f1)
end
Frac.mt.__eq = function(f1, f2)
    return f1 <= f2 and f2 <= f1
end


print('Result: ' .. Frac(2,3) + Frac(3, 4) .. ' fajne')
print(Frac.tofloat(Frac(2,3) * Frac(3,4)))
print(Frac(2,3) < Frac(3,4))
print(Frac(2,3) == Frac.new(8,12))
print(Frac(2,3) > Frac.new(8,12))
print(Frac(5,10) / Frac.new(1,2))

print(Frac(2,3) + 2)
print(Frac(2,3) + 2.5)
print(Frac(2,3) ^ 3)

print(Frac(2,4))

print(2.5 + Frac(2,3))
print(-Frac(5,15))