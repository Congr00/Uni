function Lagrange(n, f, a, b, vec=eq_nodes(n, a, b))
	function poly(x)
		res = 0
		for k = 0:n
		lambda = 1.0
			for j = 0:n
				if j != k
					lambda *= (x - vec[j+1])/(vec[k+1] - vec[j+1])
				end
			end
		res += f(vec[k+1]) * lambda
		end
		return res
	end
	return poly
end

function Baricentric_Lagrange(n, f, a, b , vec=eq_nodes(n, a, b), ch=false)
	lambda = zeros(n+1)
	if  ch
		for k = 0:n
			lambda[k+1] = (-1)^k * sin(((2 * k + 1)*pi)/(2*n + 2))
		end
	else
		for k = 0:n
			lambda[k+1]= 1.0
				for j = 0:n
					if j != k
						lambda[k+1] *= (vec[k+1] - vec[j+1])
					end
				end
				lambda[k+1] = lambda[k+1]^(-1)
		end
	end
	function poly(x)
		res = 0
		res2 = 0
		f_sum = 0
		for k = 0:n
			if x == vec[k+1]
				return f(vec[k+1])
			end
        end
		for k = 0:n
            res += (lambda[k+1])/(x - vec[k+1])
            res2 += ((lambda[k+1])*f(vec[k+1]))/(x - vec[k+1])
		end
		return res2 / res
	end
	return poly
end

function Werner_Lagrange(n, f, a, b, vec=eq_nodes(n, a, b))
	w = zeros(n+1, n+1)
	w[1,1] = 1.0
	for i = 1:n
		for k = 0:i-1
			w[i+1,k+1] = w[i,k+1]/(vec[k+1] - vec[i+1])
			w[k+2,i+1] = w[k+1,i+1] - w[i+1,k+1]
		end
	end
	function poly(x)
		res = 0
		res2 = 0
		f_sum = 0
		for k = 0:n
			if x == vec[k+1]
				return f(vec[k+1])
			end
        end
		for k = 0:n
            res += (w[n+1,k+1])/(x - vec[k+1])
            res2 += (w[n+1,k+1]*f(vec[k+1]))/(x - vec[k+1])
		end
		return res2 / res
	end
	return poly    
end

function eq_nodes(n, a, b)
	x = [0.0]
	pop!(x) 
	for k = 0:n
		push!(x ,a + (b - a)*k/(n))
	end	
	return x
end

function ch_nodes(n, a, b)
    x = [0.0]
    n += 1
	pop!(x) 
	for k = 1:n
		push!(x , 0.5*(a + b) + 0.5*(b - a)cos((2*k - 1)*pi/(2*n)))
	end	
	return x
end

function rd_nodes(n, a, b)
    x = []
    for k = 0:n
        push!(x, rand(Float64) + rand(a:(b-1)))
    end
    return sort(x)
end

function max_error(f, L, a, b)
    err = 0.0
    for i in a:+0.01:b
        tmp = (abs(f(i) - L(i)))
        if tmp > err
            err = tmp
        end
    end
    return err
end