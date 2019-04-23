def count_words(string)
  res = {}
  string.downcase.split.each do |word|
    word = word.gsub(/[^\wżźćńółęąśŻŹĆĄŚĘŁÓŃ]/, '')
    if word != ''
      res[word] == nil? ? res[word] = 1 : res[word] += 1
    end
  end
  res
end

def assert(expr)
  raise 'Wrong test case' unless expr
end

test_cases = {
  'A man, a plan, a canal -- Panama' => {'a'=>3, 'man' => 1, 'plan' => 1, 'canal' => 1, 'panama' => 1},
  'Madam, I\'m Adam!' => {'madam' => 1, 'im' => 1, 'adam' => 1},
  'Abracadabra' => {'abracadabra' => 1},
  '' => {},
  'To nie jest palindrom .....' => {'to' => 1, 'nie' =>1, 'jest'=>1, 'palindrom'=>1}, 
  'dużo razy a jest w tym zdaniu a ponieważ a jest aarne, to a można powtażać a razy' => {'dużo'=>1, 'razy'=>2, 'a'=>5, 'jest'=>2, 'w'=>1, 'tym'=>1, 'zdaniu'=>1, 'ponieważ'=>1, 'aarne'=>1, 'to'=>1, 'można'=>1, 'powtażać'=>1}
}

def test
  test_cases.each do |pal, res|
    assert(count_words(pal) == res)
  end
  p 'Tests OK'
end

test
