
class Fixnum
	def czynniki
		result = Array.new(0)
		num = self
		while num != 0
			if (self % num) == 0
				result << num
			end
			num = num - 1
		end
		return result
	end
	def ack(y)
		return ack_rec(self, y)
	end
	def ack_rec(n, m)
		if n == 0
			return m + 1
		end
		if m == 0
			return ack_rec(n - 1,1)
		end
		return ack_rec(n - 1, ack_rec(n, m - 1))
	end
	def doskonala
		dzielniki = self.czynniki
		sum = 0
		dzielniki.each{|a| sum += a }
		sum -= self
		if sum == self
			return true
		end
		return false
	end
	def slownie
		slowa = ["zero","jeden", "dwa", "trzy", "cztery", "piec", "szesc", "siedem", "osiem", "dziewiec"]
		t = 10
		string = ""
		if t > self
			return slowa[self]
		end
		while t < self
			t *= 10
		end
		num = self
		while true
			t /= 10
			string << slowa[num/t] << " "
			if t == 1
				return string
			end
			num %= t
		end
	end
end

print 12.czynniki
print "\n"
print 2.ack(2)
print "\n"
print 28.doskonala
print "\n"
print 21693.slownie
print "\n"
