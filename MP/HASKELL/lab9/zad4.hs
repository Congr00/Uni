import Prelude

fib :: Integer -> Integer
fib 0 = 1
fib 1 = 1
fib n = fib(n-1) + fib(n-2)


fibb n = fibbs !! (n-1) where
		fibbs = 1:1:zipWith (+) fibbs (tail fibbs)

main = do
	putStrLn $ show (map fibb [1,2,3,4,5,6,7,8,9,10])


