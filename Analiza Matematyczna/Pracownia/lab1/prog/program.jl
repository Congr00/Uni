setprecision(32)

function sum_kahan(x)
    n = length(x)
    if (n == 0)   return(0)  end

    s = x[1]
    c = 0
    for i in 2:n
        t = s + x[i]
        if ( abs(s) >= abs(x[i]) )
            c += ( (s-t) + x[i] )
        else
            c += ( (x[i]-t) + s )
        end
        s = t
    end

    s + c
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
