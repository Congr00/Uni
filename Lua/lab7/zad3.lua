#!/usr/bin/env lua

package.path = '../lib/?.lua;'..package.path
lib = require"lib"

Trie = {}
Trie.mt = {"Trie"}
setmetatable(Trie, {["__call"] = function(...) return Trie.new(select(2, ...)) end})

function Trie.newNode(seq,e)
    local node = {}
    node.preSeq = seq
    node.child = {}
    node.ending = e
    return node
end

-- returns node where search ended, sequence that is left and char that seq has in common with node sequence
function Trie.searchRec(node, seq, cnt)
  
    -- block default value
    --if node.preSeq == {1,2} then
     --   lib.printf(node.preSeq)
     --   lib.printf(seq)
    --print(cnt, #seq, 'lel')          
    --end
    if cnt == nil then cnt = 1 end
    -- kcolb
    if #seq == 0 then return node, seq, cnt end

    if node.preSeq[cnt] == seq[1] then          
        return Trie.searchRec(node, lib.subtab(seq, 2, #seq), cnt+1) end

    if #node.preSeq < cnt or node.preSeq[1] == '\0' or #node.preSeq < #seq then 
        if node.child[seq[1]] ~= nil then return Trie.searchRec(node.child[seq[1]], seq) end
        return node, seq, cnt
    end

    return node, seq, cnt
end

function Trie.recInsert(node, seq, root)
    local node, rseq, cnt = Trie.searchRec(node, seq)
    --lib.printf(node.preSeq)
    --lib.printf(rseq)
    --print(cnt, #rseq)
    -- insert at root
    if rseq == seq then
        node.child[rseq[1]] = Trie.newNode(rseq, true)
    -- insert word while keeping other
    elseif #node.preSeq == cnt-1 and #rseq ~= 0 then 
        node.child[rseq[1]] = Trie.newNode(rseq, true)
    --insert word that is prefix of existing node
    elseif #rseq == 0 and #node.preSeq == cnt-1 then
        node.ending = true
        root.s = root.s-1
    
    elseif #rseq == 0 then 
        local oldChild = node.child
        local newPre = lib.subtab(node.preSeq, 1, cnt-1)
        local newPost = lib.subtab(node.preSeq, cnt, #node.preSeq)
        node.child = {}
        node.child[newPost[1]] = Trie.newNode(newPost, true)
        node.child[newPost[1]].child = oldChild
        node.preSeq = newPre
    --insert word while splitting node
    elseif node.preSeq[cnt] ~= rseq[1] then
        local oldChild = node.child
        local newPre = lib.subtab(node.preSeq, 1, cnt-1)
        local newPost = lib.subtab(node.preSeq, cnt, #node.preSeq)
        node.child = {}
        node.child[newPost[1]] = Trie.newNode(newPost, true)
        node.child[newPost[1]].child = oldChild
        node.preSeq = newPre
        node.child[rseq[1]] = Trie.newNode(rseq, true)
        node.ending = false
    end
end

function Trie:find(seq)   
    local node, rseq, cnt = Trie.searchRec(self.root, seq)   
    if node.ending == true and #rseq == 0 and cnt-1 == #node.preSeq then return true end
    return false

end

function Trie:size() return self.s end

function Trie:capacity()
    return 1+Trie.capacityRec(self.root)
end

function Trie.capacityRec(node)
    local cnt = 0
    for k in pairs(node.child) do cnt = cnt + Trie.capacityRec(node.child[k]) + 1 end       
    return cnt
end



function Trie.new(sseq)
    if sseq ~= nil then
        if sseq.root ~= nil and sseq.cap ~= nil then
            -- copy trie into new object
            return setmetatable(sseq, {__index = Trie})
        end
    end
    local trie = {}
    trie.root = Trie.newNode({'\0'})
    trie.s = 0
    if sseq ~= nil then
        for _, seq in ipairs(sseq) do 
            Trie.recInsert(trie.root, seq) 
            trie.s  = trie.s + 1
        end
    end
    return setmetatable(trie, {__index = Trie,
        __len = function(...) return Trie.size(...) end,
        __add = function(...) return Trie.merge(...)end    
    })
end

function Trie:add(seq)
    self.s = self.s + 1
    Trie.recInsert(self.root, seq, self)
end

function Trie:string()
    local stack = {}
    local s2 = {}
    local res = ""
    table.insert( stack, self.root )
    while(#stack ~= 0) do
        local node = stack[#stack]
        stack[#stack] = nil
        res = res .. string.fromArray(node.preSeq)   
        for k in pairs(node.child) do
            table.insert( s2, node.child[k] )
        end
        res = res .. '|'
        if #stack == 0 then
            stack = s2
            s2 = {}
            res = res .. '\n'
        end
    end
    return res
end

function Trie.nodeChildCnt(node)
    local cnt = 0
    for k in pairs(node.child) do cnt = cnt + 1 + #node.child[k].preSeq end
    return cnt     
end



function Trie:merge(right) 
    self.s = self.s + right.s
    return Trie.mergeRec(self.root, right.root, self) 
end
function Trie.mergeRec(left, right, root)
    if right == nil then return end      
    for k in pairs(right.child) do       
        node, rseq, cnt = Trie.searchRec(left, right.child[k].preSeq)       
        if rseq == right.child[k].preSeq then
            node.child[rseq[1]] = right.child[k]
        -- insert word while keeping other
        elseif #node.preSeq == cnt-1 and #rseq ~= 0 then 
            node.child[rseq[1]] = right.child[k]
        --insert word that is prefix of existing node
        elseif #rseq == 0 and #node.preSeq == cnt-1 then
            node.ending = true
            root.s = root.s - 1
            Trie.mergeRec(node, right.child[k])
        
        elseif #rseq == 0 then 
            local oldChild = node.child
            local newPre = lib.subtab(node.preSeq, 1, cnt-1)
            local newPost = lib.subtab(node.preSeq, cnt, #node.preSeq)
            node.child = {}
            node.child[newPost[1]] = Trie.newNode(newPost, true)
            node.child[newPost[1]].child = oldChild
            node.preSeq = newPre
            node.ending = right.child[k].ending
            Trie.mergeRec(node, right.child[k], root)
        --insert word while splitting node
        elseif node.preSeq[cnt] ~= rseq[1] then
            local oldChild = node.child
            local newPre = lib.subtab(node.preSeq, 1, cnt-1)
            local newPost = lib.subtab(node.preSeq, cnt, #node.preSeq)
            node.child = {}
            node.child[newPost[1]] = Trie.newNode(newPost, true)
            node.child[newPost[1]].child = oldChild
            node.preSeq = newPre
            node.child[rseq[1]] = right.child[k]
            node.ending = false      
        end     
    end
end

local t = Trie.new()
local r = Trie.new{('toaster'):array(), ('toasting'):array()}

r:add(('toasters'):array())

print(r:string())
r:add(('toast'):array())
r:add(('toasts'):array())
r:add(('to'):array())
print(r:string())

print(r:find(('toasters'):array()))


---[[
local t = Trie.new ()
local r = Trie.new { {1 ,2 ,3 ,4 ,5} , {1 ,2 ,6 ,6 ,6 } }
print ( t : size () , r : size ()) --> 0 2
print ( t : capacity () , r : capacity ()) --> 1 5
print ( r : find {1 ,2 ,3}) --> false
print ( r : find {1 ,2 ,3 ,4 ,5}) --> true
t : add {'a','bb','ccc'}
t:add {1 ,2 ,3}
print (#t , t : capacity ()) --> 2 3
print(t:string(), r:string())



---[[
print(#t, #r)
t : merge ( r )
t:add({1,2,6,7,7})
t:add({'a', 'bb', 'ccc'})
print (# t ) --> 4
--[[
print ( t : find {1 ,2 ,3}) --> false
print(t:find({1,2,3,4,5}))
print(t:find({1,2,6,6,6}))
print(t:find({1,2}))
print(t:find({1,2,6,7}))
--]]
print(t:string())
--print (( r + Trie.new {1 ,2 ,6 ,7 ,7 , 'a'}): capacity ()) --> 7

--]]