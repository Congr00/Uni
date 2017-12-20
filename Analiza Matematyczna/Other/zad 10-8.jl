using Polynomials
using QuadGK
using Cubature


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
	pop!(x) 
	for k = 1:n
		push!(x ,cos(((2*k - 1)*pi)/(2*n)))
	end	
	return x    
end

function che_nodes(n, a, b)
    x = [0.0]
	pop!(x) 
	for k = 0:n
		push!(x ,cos((k*pi)/n))
	end	
	return x   
end

function max_error(f, L, a, b)
    err = 0.0
    for i in a:+0.001:b
        tmp = (abs(f(i) - L(i)))
        if tmp > err
            err = tmp
        end
    end
    return err
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

function Legendre_Poly(n)
    if n == 0
        return Poly([1])
    elseif n == 1
        return Poly([0,1])
    end
    p_x = Poly([0,1])
    t = Array{Poly}(n+1)
    t[1] = Poly([1])
    t[2] = Poly([0,1])
    for k in 1:(n-1)
        tmp = ((2*k+1)t[k+1]*p_x)
        tmp = tmp - ((k)t[k])
        tmk = (1/(k+1))
        tmp = (tmk)tmp
        t[k+2] = tmp
    end
    return t[n+1]
end

function Chebyshev_Poly(n)
    if n == 0
        return Poly([1])
    elseif n == 1
        return Poly([0,1])
    end
    p_x = Poly([0,1])
    t = Array{Poly}(n+1)
    t[1] = Poly([1])
    t[2] = Poly([0,1])
    y = 0.5
    for k in 1:(n-1)
        tmp = (2)(t[k+1]*p_x)
        tmp = tmp - t[k]
        t[k+2] = tmp
    end
    return t[n+1]
end

function scalar(f1, f2, a, b, x)
    return quadgk(x -> (f1(x)*f2(x)), -1., 1.)[1]
end

function scalar_cheb(f1, f2, a, b, x)
    p(x) = 1/(sqrt(1 - x^2))
    return quadgk(x -> (f1(x)*f2(x)*p(x)), -1., 1.)[1]
end

function cheb_optimal(n, f, Pn, a, b)
    function optimal(x)
        sum = 0.0
        for k in 0:n
            sum += scalar_cheb(f, Pn(k*2), 1.0, 1.0, x) * (Pn(k*2))(x)
            if k == 0
                sum *= 0.5
            end
        end
        return sum * (2.0 / pi)
    end
    return optimal
end

function find_optimal(n, f, Pn, a, b)
    function optimal(x)
        sum = 0.0
        for k in 0:n
            tmp = ((scalar(f, Pn(k), a, b, x)) / 2/(2*k+1))
            val = (Pn(k))(x)
            tmp *= val
            sum += tmp
        end
        return sum
    end
    return optimal
end

