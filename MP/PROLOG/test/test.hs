
merge :: Ord a => [a] -> [a] -> [a]
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys) = if x < y then x:(merge xs (y:ys)) else y:(merge (x:xs) ys)



-- >>> merge [1,10,3] [4,5,6]
-- [1,4,5,6,10,3]
--


bum :: Ord a => [a] -> [a]
bum list = let mapped = map (\x -> [x]) list in head (bum3 mapped)

bum2 :: Ord a => [[a]] -> [[a]]
bum2 [] = []
bum2 (x:[]) = [x]
bum2 (h:t) =
    case t of
        (h2:t2) -> (merge h h2):(bum2 t2)
        _ -> t
bum3 :: Ord a => [[a]] -> [[a]]
bum3 [] = []
bum3 (l:[]) = [l]
bum3 (h:t) = bum3 (bum2 (h:t))

-- >>> :type flip flip
-- flip flip :: b -> (a -> b -> c) -> a -> c
--
