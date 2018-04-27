import Data.List


merge_uniqe :: Ord a => [a] -> [a] -> [a]
merge_uniqe [] ys = ys
merge_uniqe xs [] = xs
merge_uniqe (x:xs) (y:ys)
            | x == y = merge_uniqe xs (y:ys)
            | x < y = x:(merge_uniqe xs (y:ys))
            | otherwise = y:(merge_uniqe (x:xs) ys)

d235 :: [Integer]
d235 = 1:(merge_uniqe (merge_uniqe (map (2*) d235) (map (3*) d235)) (map (5*) d235))


main = do
       print (take 10 d235)
