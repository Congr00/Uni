include("random.jl")

setprecision(32)

function sum_kahan(x)
    res = BigFloat(0.0)
    err = BigFloat(0.0)
    for i in x
        y = BigFloat(i - err)
        tmp = BigFloat(res + y)
        err = (tmp - res) - y
        res = tmp
    end
    return res
end

function sum_naive(x)
    res = BigFloat(0.0)
    for i in x
        res += i
    end
    return res
end

function sum_binary(x)
    if length(x) == 1
        return BigFloat(x[1])
    elseif length(x) == 2
        return BigFloat(x[1] + x[2])
    else
        return BigFloat(sum_binary(x[1:(floor(Int64,length(x) / 2))]) + sum_binary(x[(floor(Int64,length(x) / 2) + 1):length(x)]))
    end
end

function test(input_arr::Array{Float64,1}, expected_res=0, ret=false)
    n = sum_naive(input_arr)
    b = sum_binary(input_arr)
    k = sum_kahan(input_arr)
    js = sum(input_arr)
    jk = sum_kbn(input_arr)
    if !ret
        if expected_res != 0
            @printf("result for naive sum:\n%.32f\nerr: %.e\n", n, abs(expected_res - n))
            @printf("result for binary sum:\n%.32f\nerr: %.e\n", b, abs(expected_res - b))
            @printf("result for kahan sum:\n%.32f\nerr: %.e\n", k, abs(expected_res - k))
            @printf("result for julia sum:\n%.32f\nerr: %.e\n", js, abs(expected_res - js))
            @printf("result for julia kah sum:\n%.32f\nerr: %.e\n", jk, abs(expected_res - jk))        
        else
            @printf("result for naive sum:\n%.32f\n", n)
            @printf("result for binary sum:\n%.32f\n", b)
            @printf("result for kahan sum:\n%.32f\n", k)
            @printf("result for julia sum:\n%.32f\n", js)
            @printf("result for julia kah sum:\n%.32f\n", jk)
        end
    end
    if ret
        return [abs(expected_res - n),abs(expected_res - b),abs(expected_res - k),abs(expected_res - js),abs(expected_res - jk)]
    end
end

function plot_test(mult, n, expected_res, sort, x1, x2, start)
    res = Array{BigFloat,1}[[],[],[],[],[]]
    for i in 1:n
        tmp = test(multiply(x1, x2, start*i*mult, sort),expected_res*i*mult*start,true)
        push!(res[1], tmp[1])
        push!(res[2], tmp[2])
        push!(res[3], tmp[3])
        push!(res[4], tmp[4])
        push!(res[5], tmp[5])
    end
    return res
end

function lff(file, sort=0)
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