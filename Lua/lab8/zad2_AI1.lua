
math.randomseed (os.time())
local function rng () return math.random (3) end
AI = function ( mysymbol , board )
    while true do
    local x , y = rng () , rng ()
        if board [ x ][ y ] == ' ' then
            return x , y
        end
    end
end