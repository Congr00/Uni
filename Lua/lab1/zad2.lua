#!/usr/bin/env lua

function printf(tab)    
  local function rec_printf(tab)
    local str = ''

    for i=1, #tab do
        if type(tab[i]) == 'table' then
          str = str..'{'..rec_printf(tab[i])..'}' 
        else
          str = str..tostring(tab[i])
        end
        if i ~= #tab then
          str = str..', '
        elseif i < #tab then
          str = str..' '
        end    
    end
    return str
  end
  
  local str = '' 
  if type(tab) == 'table' then
    str = '{'..rec_printf(tab)..'}'
  else
    str = tostring(tab)
  end
  print(str)
end

function map(array, fun)
  local result = {}
  for i=1, #array do
    table.insert(result, fun(array[i]))
  end
  return result
end

function increment(n)
  return n+1
end

function app_fajny(str)
  return str..' fajny'
end

function sqrt_map(value)
  return math.sqrt(value)
end

tests = {
  {{1,2,3}, increment},
  {{'1','2','3'}, app_fajny},
  {{2,3,4,5,6,7}, sqrt_map},
  {{}, sqrt_map},
  {{{1,2,3},{4,5,6},{7,8,9}}, function(v) return map(v,sqrt_map) end}
}

for _, t in ipairs(tests) do
  printf(map(t[1],t[2]))
end
