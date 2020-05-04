

l = 0.0
p = 1.0
n = 10.0
pp = [ 1 / n, (n-2) / n, 1 / n]

def next(i, l, p):
    if i == 0:
        nl = 0
    else:
        nl = l + sum(pp[0:i]) * (p - l)
    np = l + sum(pp[0:(i+1)]) * (p - l)
    l, p = kompress(nl, np)
    print('new (l,p) : ({0},{1})'.format(l, p))
    return kompress(l, p)

def kompress(l, p):
    if (l <= 0 and p < 0.5):
        print('E1: ({0},{1})'.format(l, p))
        return (2*l, 2*p)
    elif (l >= 0.5 and p < 1):
        print('E2: ({0},{1})'.format(l, p))
        return (2 * (l - 0.5), 2 * (p - 0.5))
    elif (l >= 0.25 and p < 0.75):
        print('E3: ({0},{1})'.format(l, p))
        return (2 * (l - 0.25), 2 * (p - 0.25))
    return (l, p)

(l, p) = next(1, l, p)
for i in range(0, 30):
    (l, p) = next(1, l, p)
