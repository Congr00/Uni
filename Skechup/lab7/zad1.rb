def palindrome(string)
    string = string.gsub(/[^\wżźćńółęąśŻŹĆĄŚĘŁÓŃ]/, "").downcase
    string == string.reverse
end

def assert(expr)
    raise "Wrong test case" unless expr
end

$palTrueCases = [
    "Ikar łapał raki.",
    "Igor łamał rogi.",
    "Kobyła ma mały bok.",
    "Może jutro ta dama da tortu jeżom.",
    "Wódy żal dla żydów.",
    "Zakopane na pokaz.",
    "Elf układał kufle.",
    "A to kanapa pana Kota.",
    "Tolo ma samolot.",
    "Ma tarapaty ta para tam.",
    "Wół utył i ma miły tułów.",
    "Marzena pokazała Zakopane z ram.",
    "A to idiota.",
    "Atak kata.",
    "Kamil ślimak.",
    "Satyra rota to rarytas.",
    "Ile Roman ładny dyndał na moreli?",
    "O, ty z Katowic, Iwo? Tak, Zyto.%%$@#@!.....    "
]
$palFalseCases = [
    "To nie jest palindrom .....",
    "O, ty z Katowic, Iwo? Tak, Zyto.%%$@#@!.....    K",
    "Lorem ipsum dolor sit amet, consectetur",
    "adipiscing elit, sed do eiusmod tempor",
    "incididunt ut labore et dolore magna aliqua.", 
    "Ut enim ad minim veniam, quis nostrud exercitation",
    "ullamco laboris nisi ut aliquip ex ea commodo consequat.", 
    "Duis aute irure dolor in reprehenderit in", 
    "voluptate velit esse cillum dolore eu fugiat", 
    "nulla pariatur. Excepteur sint occaecat", 
    "cupidatat non proident, sunt in culpa qui", 
    "officia deserunt mollit anim id est laborum."
]

def tests()
    for pal in $palTrueCases do assert(palindrome(pal) == true) end
    p 'true tests OK'
    for pal in $palFalseCases do assert(palindrome(pal) == false) end
    p 'false tests OK'    
end

tests()