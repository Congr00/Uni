function random(count=100, a=0, b=10, mode=0, file="rnd.out")
    open(file, "w") do f
        if mode == 0
            for i in 1:count
                r = randn()
                write(f, "$r\n")
            end
        end
    end
end

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