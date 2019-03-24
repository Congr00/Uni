#!/usr/bin/env lua

function printf(tab)    

  local function rec_printf(tab)
    local str = ''
    for i=1, table.maxn(tab) do
        if type(tab[i]) == 'table' then
          str = str..'{'..rec_printf(tab[i])..'}' 
        else
          str = str..tostring(tab[i])
        end
        if i ~= #tab then
          str = str..', '
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

tests = {
  {{'ala', 'ma', 127, 'kotów'}, "{'ala', 'ma', 127, 'kotów'}"},
  {{'to są', {}, {2, 'tablice'}, 'zagnieżdżone?', {true}}, "{'to są', {}, {2, 'tablice'}, 'zagnieżdżone?', {true}}"},
  {nil, "nil"},
  {true, "true"},
  {1999.9991, "1999.9991"},
  {{1999.9991, 1999.9991, {nil, 2.0}, {true}}, "{1999.9991, 1999.9991, {nil,2.0}, {true}}"},
  {{{{{{{{{}}}}}}}}, "{{{{{{{{}}}}}}}}"},
  {{{{{{{{{nil},nil, 2}}}}}}}, "{{{{{{{{nil},nil, 2}}}}}}}"},
  {{{'jeden'}, {'dwa', {'trzy', 'cztery', {'pięć', {'sześć', {'siedem', {nil,nil,nil,nil, 2}}}}}}}, "{{'jeden'}, {'dwa', {'trzy', 'cztery', {'pięć', {'sześć', {'siedem', {nil,nil,nil,nil, 2}}}}}}}"},
  {{{1,2,3}, {3,4,5}, {5,6,7}}, "{{1,2,3}, {3,4,5}, {5,6,7}}"}
}

for _, t in ipairs(tests) do
  print('string of test:\n'..t[2]..'\nprintf:')
  printf(t[1])
  print('\n')
end
