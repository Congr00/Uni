#!/usr/bin/env lua

function moveinto( tab1, i1, j1, tab2, i2 )
    if i2 == nil then
        local tmp = tab2
        tab2 = i2
        tab2 = tab1
        i2 = tmp
    end
    local cnt = 0
    local i = table.maxn(tab2) + (j1 - i1 + 1)
    while i >= i2+(j1-i1+1) do
        tab2[i] = tab2[i-(j1-i1+1)]
        i = i - 1
    end
    for i=i1, j1 do
       tab2[i2+cnt] = tab1[i]
       cnt = cnt+1
    end
end

function printf(tab)    

    local function rec_printf(tab)
      local str = ''
      for i=1, table.maxn(tab) do
          if type(tab[i]) == 'table' then
            str = str..'{'..rec_printf(tab[i])..'}' 
          else
            str = str..tostring(tab[i])
          end
          if i ~= table.maxn(tab) then
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

tab1 = {3,4,nil,6,7}
tab2 = {1,nil,3,7,nil,8}

tests = {
    {{2,4,4}, "{1,nil,3,4,nil,6,7,nil,8}"},
    {{1,6,1}, "{3,4,nil,6,7,nil,1,nil,3,7,nil,8}"},
    {{1,5,1}, "{3,4,nil,6,7,1,nil,3,7,nil,8}"},
    {{1,6,6}, "{1,nil,3,7,nil,3,4,nil,6,7,nil,8}"}
}

for _, t in pairs(tests) do
    print(t[2])
    tab1 = {3,4,nil,6,7}
    tab2 = {1,nil,3,7,nil,8}    
    moveinto(tab1, t[1][1], t[1][2], tab2, t[1][3])
    printf(tab2)
    print("\n")
end


tab1 = {3,4,nil,6,7}
tab2 = {1,nil,3,7,nil,8}    
print("{3,4,3,4,nil,6,7}")
moveinto(tab1,1,2,1)
printf(tab1)
print("\n")
tab1 = {3,4,nil,6,7}
tab2 = {1,nil,3,7,nil,8}    
print("{3,4,nil,3,4,6,7}")
moveinto(tab1,1,2,4)
printf(tab1)

