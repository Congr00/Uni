#!/usr/bin/env lua

package.path = '../lib/?.lua;'..package.path
lib = require"lib"


function unpath(path)
    local res = {}
    local sep = package.config:sub(1,1)
    local name, ext = path:match(sep..'?([^'..sep..']-)%.?(%w-)$')

    for folder in path:gmatch('([^'..sep..']-)'..sep) do
        res[#res+1] = folder
    end

    res[#res+1] = {name, ext}
    return res
end

paths = {'~/hidden - name/Teaching/2016 _Lua/[ Lab ]/Lecture._+230104.pdf',
        'single_file.2009.txt.pdf',
        'C:/Windows/system32/winduws.exe',
        '~/.invisible/settings 299043/secret__/dont_open. warning.exe',
        arg[0]     
}


for _,path in ipairs(paths) do
    print(path)
    lib.printf(unpath(path))
    print('')
end
