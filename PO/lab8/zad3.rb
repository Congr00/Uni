class Jawna
	@@slowo = ""
	def initialize(word)
		@@slowo = word
	end
	def zaszyfruj(klucz)
		hashed = ""
		@@slowo.each_char{|x| hashed << klucz[x]}
		return Zaszyfrowane.new(hashed)
	end
	def to_s
		return @@slowo
	end
end

class Zaszyfrowane
	@@hashed = ""
	def initialize(hash)
		@@hashed = hash
	end		
	def odszyfruj(klucz)
		dehashed = ""
		@@hashed.each_char{|char|
			klucz.map{|x|
				if char == x[1]
					dehashed << x[0]
				end
			}
		}
		return Jawna.new(dehashed)
	end
	def to_s
		return @@hashed
	end
end


klucz = {
	'a' => 'b',
	'b' => 'r',
	'r' => 'y',
	'y' => 'u',
	'u' => 'a'
}

jawna = Jawna.new("rubyruby")
zaszyf = jawna.zaszyfruj(klucz)
zaszyf.odszyfruj(klucz)
print zaszyf.to_s, "\n"
