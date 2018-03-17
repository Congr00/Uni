include("program.jl")

#losowanie liczb w zadanym przedziale [a:b], aby stworzyć liczby
#ujemne ustawić neg na wartość, która będzie odejmowana
function random_array(count=100, a=0, b=0, neg=0)
    res = []
        for i in 1:count
            r = (rand(Float64) + rand(a:b))
            r -= neg
            push!(res, r)
        end
    return res
end
#zwraca tablicę z [x1, x2]*n elementami x1, x2, s ustawia sortowanie
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
#funkcja pomocnicza do tworzenia danych do wykresu
function plot_ex(n, ex, input)
    res = Array{BigFloat,1}[[],[],[]]
    mul = 16
    while mul <= n
        tmp = test(input[1:mul],ex[Int(log2(mul)+1)],true)
        push!(res[1], tmp[1])
        push!(res[2], tmp[2])
        push!(res[3], tmp[3])
        mul *= 2
    end
    return res
end
#funkcja testująca 3 algorytmy 
function test(input_arr, expected_res=0, ret=false)
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
        return [abs(expected_res - n),abs(expected_res - b),abs(expected_res - k)]
    end
end
#funkcja do obliczania kolejnych wyrazów ciągu podanego wzorem f
function Eq_Array(n, f)
    res = [BigFloat(0.0)]
    pop!(res)
    for i in 0:(n-1)sin
        push!(res, BigFloat(f(i)))
    end
    res
end
#funkcja zwraca tablicę wartości bezwzględnych z podanej tablicy 
function abs_a(x)
    res = x
    for i in 1:(length(x))
        res[i] = abs(x[i])
    end
    return res
end
#funkcja wylicza kolejne wyrazy ciągu arytmetycznego
function arithm(a1, r, n)
    res = [BigFloat(a1)]
    for i in 2:n
        a1 = a1 + r
        push!(res, a1)
    end
    return res
end