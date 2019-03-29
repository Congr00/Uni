local lib = {}

function lib.printf(tab)    

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

function lib.map(array, fun)
    local result = {}
    for i=1, #array do
      table.insert(result, fun(array[i]))
    end
    return result
end

function lib.reverse(arr)
    local i,j = 1, #arr
    while i < j do
        arr[i], arr[j] = arr[j], arr[i]
        i = i+1
        j = j-1
    end
end

utf8.reverse = function(string)
    local codes = table.pack(utf8.codepoint(string, 1, -1))
    lib.reverse(codes)
    return utf8.char(table.unpack(codes))
end

utf8.normalize = function(string)
    local result = ''
    for _, c in utf8.codes(string) do
        if c <= 127 then
            result = result..string.char(c)
        end
    end
    return result
end

function lib.zip(...)
  local args = {...}
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

return lib

