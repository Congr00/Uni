
def palindrome?(string)
    string = string.gsub(/[^\wżźćńółęąśŻŹĆĄŚĘŁÓŃ]/, "").downcase
    string == string.reverse
end

def count_words(string)
    res = {}
    string.downcase.split().each do |word|
        word = word.gsub(/[^\wżźćńółęąśŻŹĆĄŚĘŁÓŃ]/, "")
        if word != "" 
            res[word] == nil ? res[word] = 1 : res[word] += 1
        end
    end
    res
end

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

$testCases1 = {
     "A man, a plan, a canal -- Panama" =>  true,
     "Madam, I'm Adam!" => true,
     "Abracadabra" => false,
     "" => true,
     "To nie jest palindrom ....." => false, 
     "O, ty z Katowic, Iwo? Tak, Zyto.%%$@#@!.....    K" => false,
     "Lorem ipsum dolor sit amet, consectetur" => false,
     "adipiscing elit, sed do eiusmod tempor" => false,
     "incididunt ut labore et dolore magna aliqua." => false,
     "Ut enim ad minim veniam, quis nostrud exercitation" => false,
     "ullamco laboris nisi ut aliquip ex ea commodo consequat." => false,
     "Duis aute irure dolor in reprehenderit in" => false,
     "voluptate velit esse cillum dolore eu fugiat" => false,
     "nulla pariatur. Excepteur sint occaecat" => false,
     "cupidatat non proident, sunt in culpa qui" => false,
     "officia deserunt mollit anim id est laborum." => false,
     "Ikar łapał raki." => true,
     "Igor łamał rogi." => true,
     "Kobyła ma mały bok." => true,
     "Może jutro ta dama da tortu jeżom." => true,
     "Wódy żal dla żydów." => true,
     "Zakopane na pokaz." => true,
     "Elf układał kufle." => true,
     "A to kanapa pana Kota." => true,
     "Tolo ma samolot." => true,
     "Ma tarapaty ta para tam." => true,
     "Wół utył i ma miły tułów." => true,
     "Marzena pokazała Zakopane z ram." => true,
     "A to idiota." => true,
     "Atak kata." => true,
     "Kamil ślimak." => true,
     "Satyra rota to rarytas." => true,
     "Ile Roman ładny dyndał na moreli?" => true,
     "O, ty z Katowic, Iwo? Tak, Zyto.%%$@#@!.....    " => true
}


$testCases2 = {
    "A man, a plan, a canal -- Panama" => {"a"=>3, "man"=>1, "plan"=>1, "canal"=>1, "panama"=>1},
    "Madam, I'm Adam!" => {"madam"=>1, "im" =>1, "adam"=>1},
    "Abracadabra" => {"abracadabra" => 1},
    "" => {},
    "To nie jest palindrom ....." => {"to" => 1, "nie" =>1, "jest"=>1, "palindrom"=>1}, 
    "dużo razy a jest w tym zdaniu a ponieważ a jest aarne, to a można powtażać a razy" => {"dużo"=>1, "razy"=>2, "a"=>5, "jest"=>2, "w"=>1, "tym"=>1, "zdaniu"=>1, "ponieważ"=>1, "aarne"=>1, "to"=>1, "można"=>1, "powtażać"=>1}
}

$testCases3 = {
    ["a", "a", "a", "b", "b"] => true,
    ["a", "b", "c", "b", "c"] => false,
    ["a", "a", "a", "a", "a"] => false,
    ["a", "c", "a", "c", "b", "c", "b"] => true,
    ["a", "b", "a", "a", "c"] => false
}

def tests(tcase, fun, tag)
    tcase.each do |pal, res|  
        assert(fun.call(pal) == res) 
    end
    p "Tests " + tag + " OK"    
end

tests($testCases1, method(:palindrome?), "ex1")
tests($testCases2, method(:count_words), "ex2")
tests($testCases3, method(:same32?), "ex3")