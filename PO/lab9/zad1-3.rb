class Funkcja
		@@fun = proc{|x| x*x+2*x-8}
	def initialize(x)
		@@fun = x
	end
	def value(x)
		return @@fun.call(x)
	end
	def zerowe(a,b,e)
		result = Array.new(0)
		while a <= b
				tmp = (@@fun.call(a)*1000000.0).round/1000000.0
			if	tmp == 0
				result << a
			end
			a = (((a + e)*1000000.0).round/1000000.0)
		end	
		if	result.length == 0
				return nil
		end
		return result
	end
	@@dokladnosc = 10000
	def pole(a,b)
		delta = (b - a)/@@dokladnosc
		result, d_res = 0.0
		@@dokladnosc.times do |i|
			x = a + i * delta.to_f
			d_res = @@fun.call(x) * delta.to_f
			result = result + d_res
			i+=1
		end
		return result
	end
	@@div = 0.001
	def poch(x)
			return (((@@fun.call(x+1e-3)) - @@fun.call(x-1e-3)) / (2e-3)).round
	end
	def createPlot(a,b)
		file = File.open('plot.dat','w')
		file.write("#X  Y\n")
		while a <= b
			file.write(a)
			file.write("  ")
			file.write(@@fun.call(a))
			file.write("\n")
			a = (((a + @@div)*1000.0).round/1000.0)
		end
	end
end

fu = Funkcja.new
print fu.value(-4), "\n"
print fu.zerowe(-5, 20, 0.001), "\n"
print fu.pole(0.0,10.0), "\n"
print fu.poch(10), "\n"
fu.createPlot(-4,2)
