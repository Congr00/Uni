
def same32?(list)
    hash = {"a"=>0, "b"=>0,  "c"=>0}
    for val in list do hash[val] += 1 end
    a = hash["a"]
    b = hash["b"]
    c = hash["c"]
    if a == 3 || b == 3 || c == 3 
        if a == 2 || b == 2 || c == 2
            return true
        end
    end 
    false
end

def assert(expr)
    raise "Wrong test case" unless expr
end

$testCases = {
    ["a", "a", "a", "b", "b"] => true,
    ["a", "b", "c", "b", "c"] => false,
    ["a", "a", "a", "a", "a"] => false,
    ["a", "c", "a", "c", "b", "c", "b"] => true,
    ["a", "b", "a", "a", "c"] => false
}

def tests()
    $testCases.each do |list, res|  
        assert(same32?(list) == res)
    end
    p "Tests OK"
    
end

tests()