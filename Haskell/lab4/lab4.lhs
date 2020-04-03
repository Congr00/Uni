Łukasz Klasiński
Haskell Course
List 04
03-04-2020

> {-# LANGUAGE ViewPatterns #-}
> {-# LANGUAGE FlexibleInstances #-}
> {-# LANGUAGE UndecidableInstances #-}
> {-# LANGUAGE IncoherentInstances #-}
> {-# LANGUAGE AllowAmbiguousTypes #-}

> import Data.List(partition, permutations, intercalate)

> data BTree t a = Node (t a) a (t a) | Leaf
> class BT t where
>     toTree :: t a -> BTree t a

> data UTree a = UNode (UTree a) a (UTree a) | ULeaf
> instance BT UTree where
>     toTree ULeaf = Leaf
>     toTree (UNode l x r) = Node l x r

> flatten' :: UTree a -> [a]
> flatten' ULeaf = []
> flatten' (UNode l x r) = flatten' l ++ [x] ++ flatten' r

> qsort' :: Ord a => [a] -> [a]
> qsort' [] = []
> qsort' (x:xs) = qsort' [y | y <- xs, y < x] ++ [x] ++ qsort' [y | y <- xs, y >= x]

--
ex 1
--

> flatten :: UTree a -> [a]
> flatten = flatten_aux []
>     where
>     flatten_aux a ULeaf = a
>     flatten_aux a (UNode l x r) = let r' = flatten_aux a r
>                                   in flatten_aux (x:r') l

> qsort :: Ord a => [a] -> [a]
> qsort = qsort_aux []
>     where
>     qsort_aux a []     = a
>     qsort_aux a (x:xs) = let l = x:qsort_aux a rs
>                          in qsort_aux l ls
>             where (ls,rs) = partition (< x) xs

--
ex 2
--

> queens :: Int -> [[Int]]
> queens n = filter (\x -> ok (+) x == n && ok (-) x == n) $ permutations [0..n-1]
>     where
>         ok f l = length $ filterSame $ qsort $ zipWith f [0..] l
>         filterSame [] = []
>         filterSame [x] = [x]
>         filterSame (x:y:xs) = if x == y then filterSame (x:xs) else x:(filterSame (y:xs))

--
ex3
--

> data BinTree = BinTree :/\: BinTree | BinTreeLeaf deriving Show

zgodnie z poleceniem mam fun pomocniczą buildTree, które zwraca krotkę z drzewami o (n, n+1) wierzchołkach.
Niestety może chyba nie do końca rozumiem polecenie, bo nie widzę przydatności liczenia n+1 drzewa.

> binTree :: Int -> BinTree
> binTree 0 = BinTreeLeaf
> binTree n
>     | even n    = let (n', _) = buildTree n in n'
>     | otherwise = let (n', _  ) = buildTree n in n'
>     where
>         buildTree x
>             | even x    = (div2 :/\: div21, div21 :/\: div21)
>             | otherwise = (div2 :/\: div2 , div2  :/\: div21)
>             where 
>                 div2  = binTree $ (x-1) `div` 2
>                 div21 = binTree $ (x-1) `div` 2 + 1

--
ex 5
--

> class Queue q where
>     emptyQ :: q a
>     isEmptyQ :: q a -> Bool
>     put :: a -> q a -> q a
>     get :: q a -> (a, q a)
>     get q = (top q, pop q)
>     top :: q a -> a
>     top = fst . get
>     pop :: q a -> q a
>     pop = snd . get

> data SimpleQueue a = SimpleQueue { front :: [a], rear :: [a] } deriving Show
> instance Queue SimpleQueue where
>     emptyQ   = SimpleQueue [] []
>     isEmptyQ q = case (front q, rear q) of
>         ([], []) -> True
>         _        -> False
>     put a q = case (front q) of
>         [] -> SimpleQueue [a] (rear q)
>         xs -> SimpleQueue xs $ a:(rear q)
>     get q = (top q, pop q)
>     top q = case fq of
>         [] -> case rq of
>             [] -> error "Empty queue"
>             _  -> top $ SimpleQueue (reverse rq) []
>         h:_    -> h
>         where
>             fq = front q
>             rq = rear q
>     pop q = case fq of
>         [] -> case rq of
>             [] -> error "Empty queue"
>             _  -> pop $ SimpleQueue (reverse rq) []
>         _:t    -> SimpleQueue t rq
>         where
>             fq = front q
>             rq = rear q

--
ex 6
--

> primes :: [Integer]
> primes = 2:[ p | p <- [3..], and [ p `mod` q /= 0 | q <- take (floor $ sqrt $ fromIntegral p) primes, q /= p ]]

--
ex7
--
 
> fib :: [Integer]
> fib = 0:1:zipWith (+) fib (tail fib)

--
ex8
--

> (<+>) :: Ord a => [a] -> [a] -> [a]
> (<+>) [] l2 = l2
> (<+>) l1 [] = l1
> (<+>) l1@(h1:t1) l2@(h2:t2)
>     | h2 < h1   = h2:(l1 <+> t2)
>     | h1 == h2  = h2:(t1 <+> t2)
>     | otherwise = h1:(t1 <+> l2)

> d235 :: [Integer]
> d235 = 1:[d | d <- foldl (<+>) [] [mul 2 d235, mul 3 d235, mul 5 d235]]
>     where mul x = map (*x)

--
ex9
--

> bin :: UTree Int
> bin = bin' 1
>     where bin' a = UNode (bin' $ a * 2) a (bin' $ a * 2 + 1)

prosta funkcja pomocnicza, żeby sobie wyświetlić labely drzewa

> treeLabels :: UTree a -> Int -> [a]
> treeLabels t w = flip aux w t [] where
>     aux _ 0 acc = acc
>     aux ULeaf _ acc = acc
>     aux (UNode l x r) z acc = aux l (z `div` 2) (x : aux r (z `div` 2) acc ) 

--
ex10
--

> data RoseTree a = RNode a [RoseTree a]

> cycBin :: UTree Int
> cycBin = UNode cycBin 1 cycBin

dobre byłoby użyć repeat cycRose, ale trzeba mieć jedno (:)

> cycRose :: RoseTree Int
> cycRose = RNode 1 $ rep cycRose
>     where rep x = x:rep x

--
ex11
--

> showFragList :: Show a => Int -> [a] -> String
> showFragList 0 _ = "[]"
> showFragList x l = '[':tail (frag_aux x l)  where
>     frag_aux x' l'
>         | x' <= 0   = ",\8230]\n"
>         | otherwise = case l' of 
>                 []    -> ",\8230]\n"
>                 (h:t) -> ',':(show h) ++ frag_aux (x'-1) t

> showFragTree :: (BT t, Show a) => Int -> t a -> String
> showFragTree _ (toTree -> Leaf) = " Leaf "
> showFragTree 0 _ = " \8230 "
> showFragTree n (toTree -> Node l x r) = " Node (" ++ showFragTree (n-1) l ++ ") " ++ show x ++ " (" ++ showFragTree (n-1) r ++ ") "
> showFragTree _ _ = ""

Tutaj bya wskazówka na użycie showFragList, ale nie widzę na to sposobu, ponieważ
w showFragList używamy "show h" więc nie jesteśmy w stanie przekazać informacji ile
elementów chcemy wyświetlić (bo w RoseTree mamy nieskończoną tablicę), a inaczej się zapętli.

> showFragRose :: Show a => Int -> RoseTree a -> String
> showFragRose i t = showFragRose' i t
>     where
>     showFragRose' 0 _ = " \8230 "
>     showFragRose' n (RNode x l) = " RNode " ++ show x ++ " [ " ++ intercalate "," (map (uncurry showFragRose) $ take n $ zip (repeat (n-1)) l) ++ end
>         where end = if (length $ take (n+1) l) < n then " ] " else  if n > 1 then ", \8230 ] " else " ] "

--
ex12
--

> data Cyclist a = Elem (Cyclist a) a (Cyclist a)

> fromList :: [a] -> Cyclist a
> fromList [] = error "Empty list"
> fromList xs = Elem (fromList $ getElem (-1) xs) (head xs) (fromList $ getElem 1 xs)
>     where
>     getElem n ys
>             | n > 0  = getElem (n-1) (tail ys ++ [head ys])
>             | n < 0  = getElem (n+1) ((last ys):(init ys))
>             | otherwise = ys

> toList :: Cyclist a -> [a]
> toList (Elem _ x r) = x:toList r

> forward, backward :: Cyclist a -> Cyclist a
> forward (Elem _ _ r)  = r
> backward (Elem l _ _) = l

> label :: Cyclist a -> a
> label (Elem _ x _) = x

--
ex13
--

> enumInts :: Cyclist Integer
> enumInts = enumInts' 0
>     where
>     enumInts' :: Integer -> Cyclist Integer
>     enumInts' x = Elem (enumInts' $ (head . tail) [x,(x-1)..]) x (enumInts' $ (head . tail) [x..])
