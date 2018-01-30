function spline(nodes, n)

end

function DiffQuot(f, x, n)
    b = Array{Float64}(n)
    for k = 0:n-1
        b[k+1] = f(x[k+1])
    end
    for j = 1:n-1
        for k = n-1:-1:j
            b[k+1] = (b[k+1] - b[k]) / (x[k+1] - x[k-j+1])
        end
    end
    return b
end
