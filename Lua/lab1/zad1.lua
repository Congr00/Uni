#!/usr/bin/env lua

function printf(tab)    

  local function to_string(item)
    if type(item) == 'nil' then
      return 'nil'
    else
      return tostring(item)
    end
  end

  local function rec_printf(tab)
    local str = ''
    for i=1, table.maxn(tab) do
        if type(tab[i]) == 'table' then
          str = str..'{'..rec_printf(tab[i])..'}' 
        else
          str = str..to_string(tab[i])
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
    str = to_string(tab)
  end
  print(str)
end

tests = {
  [{'ala', 'ma', 127, 'kotów'}] = "{'ala', 'ma', 127, 'kotów'}",
  [{'to są', {}, {2, 'tablice'}, 'zagnieżdżone?', {true}}] = "{'to są', {}, {2, 'tablice'}, 'zagnieżdżone?', {true}}",
  --[nil] = "nil",
  [true] = "true",
  [1999.9991] = "1999.9991",
  [{1999.9991, 1999.9991, {nil}, {true}}] = "{1999.9991, 1999.9991, {nil}, {true}}",
  [{{{{{{{{}}}}}}}}] = "{{{{{{{{}}}}}}}}",
  [{{{{{{{{nil},nil, 2}}}}}}}] = "{{{{{{{{nil},nil, 2}}}}}}}",
  [{{'jeden'}, {'dwa', {'trzy', 'cztery', {'pięć', {'sześć', {'siedem', {nil,nil,nil,nil}}}}}}}] = "{{'jeden'}, {'dwa', {'trzy', 'cztery', {'pięć', {'sześć', {'siedem', {nil,nil,nil,nil}}}}}}}"
}

for k, v in pairs(tests) do
  print('string of test:\n'..v..'\nprintf:')
  printf(k)
  print('\n')
end
