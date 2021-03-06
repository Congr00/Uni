
def palindrome?(string)
    string = string.gsub(/[^\wżźćńółęąśŻŹĆĄŚĘŁÓŃ]/, "").downcase
    string == string.reverse
end

def assert(expr)
    raise "Wrong test case" unless expr
end

$testCases = {
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

def tests()
    $testCases.each do |pal, res|  
        assert(palindrome?(pal) == res) 
    end
    p "Tests OK"
end

tests()