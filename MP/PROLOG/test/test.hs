data T a = A(a -> T a) | B (T a -> a)





evil :: [Integer] -> Bool
evil [] = False
evil (666:xs) = True
evil(_:xs) = evil xs

lucky :: [Integer]
lucky = 7:lucky


f x = x (f x)
g x y = (f x) . (f y)
h x y = f(g x y)

warbler k x = k x x
