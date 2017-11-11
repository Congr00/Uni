include("program.jl")
# losowanie liczb we wskazanym przedziale
function random(count=100, a=0, b=10,file="rnd.out")
    rng = MersenneTwister(23421)
    open(file, "w") do f
        for i in 1:count
            r = randn(rng, Float64) + rand([a,b])
            write(f, "$r\n")
        end
    end
end
function random_array(count=100, a=0, b=0, e=0)
    res = []
    rng = MersenneTwister(23421)
        for i in 1:count
            r = (randn(rng, Float64) + rand([a,b]))
            push!(res, r)
        end
    return res
end
#zwraca tablicę z [x1, x2]*n elementami x1, x2
function multiply(x1, x2, n, s=0)
    res = [0.0]
    pop!(res) 
    for i in 1:n
        push!(res, x1)
        push!(res, x2)
    end
    if s == 1
        return sort(res)
    elseif s == -1
        return sort(res, rev=true)
    else
        return res
    end
end
#
function plot_test(mult, n, expected_res, sort, x1, x2, start)
    res = Array{BigFloat,1}[[],[],[]]
    for i in 1:n
        tmp = test(multiply(x1, x2, start*i*mult, sort),expected_res*i*mult*start,true)
        push!(res[1], tmp[1])
        push!(res[2], tmp[2])
        push!(res[3], tmp[3])
    end
    return res
end

function plot_test2(mult, n, input::Array{Float64, 1}, start=100, exp=0)
    res = Array{BigFloat,1}[[],[],[]]
    for i in start:+mult:n
        tmp = test(input[1:(start + i)], 0, true)
        #tmp = test(input[1:(start + i*mult)], exp, true)
        push!(res[1], tmp[1])
        push!(res[2], tmp[2])
        push!(res[3], tmp[3])    
    end
    return res
end

function test(input_arr::Array{Float64,1}, expected_res=0, ret=false)
    n = sum_naive(input_arr)
    b = sum_binary(input_arr)
    k = sum_kahan(input_arr)
    if !ret
        if expected_res != 0
            @printf("result for naive sum:\n%.16f\nerr: %.e\n", n, abs(expected_res - n))
            @printf("result for binary sum:\n%.16f\nerr: %.e\n", b, abs(expected_res - b))
            @printf("result for kahan sum:\n%e.16f\nerr: %.e\n", k, abs(expected_res - k))
        else
            @printf("result for naive sum:\n%.16f\n", n)
            @printf("result for binary sum:\n%.16f\n", b)
            @printf("result for kahan sum:\n%.16f\n", k)
        end
    end
    if ret
        return [abs(k - expected_res - n),abs(k - expected_res - b),abs(k - expected_res - k)]
    end
end

function lff(file, sort=0, n=0)
   f = open(file)
   lines = readlines(f)
   x = zeros(Float64, length(lines))
   for ln = 1:length(lines)
      x[ln] = parse(Float64, lines[ln])
   end
   close(f)
   if sort == 0
        return x
   elseif sort == 1
        return sort!(x)
   else
        return sort!(x, rev=true)
   end
end

function Eq_Array(n, f)
    res = [BigFloat(0.0)]
    pop!(res)
    for i in 1:n
        push!(res, BigFloat(f(i)))
    end
    res
end