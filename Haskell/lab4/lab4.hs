{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE IncoherentInstances #-}
{-# LANGUAGE AllowAmbiguousTypes #-}


import Data.List(partition, permutations, intercalate)

data BTree t a = Node (t a) a (t a) | Leaf
class BT t where
    toTree :: t a -> BTree t a

data UTree a = UNode (UTree a) a (UTree a) | ULeaf
instance BT UTree where
    toTree ULeaf = Leaf
    toTree (UNode l x r) = Node l x r

flatten' :: UTree a -> [a]
flatten' ULeaf = []
flatten' (UNode l x r) = flatten' l ++ [x] ++ flatten' r

qsort' :: Ord a => [a] -> [a]
qsort' [] = []
qsort' (x:xs) = qsort' [y | y <- xs, y < x] ++ [x] ++ qsort' [y | y <- xs, y >= x]

-- zad 1

flatten :: UTree a -> [a]
flatten = flatten_aux []
    where
    flatten_aux a ULeaf = a
    flatten_aux a (UNode l x r) = let r' = flatten_aux a r
                                  in flatten_aux (x:r') l

qsort :: Ord a => [a] -> [a]
qsort = qsort_aux []
    where
    qsort_aux a []     = a
    qsort_aux a (x:xs) = let l = x:qsort_aux a rs
                         in qsort_aux l ls
            where (ls,rs) = partition (< x) xs

-- zad 2
queens :: Int -> [[Int]]
queens n = filter (\x -> ok (+) x == n && ok (-) x == n) $ permutations [0..n-1]
    where
        ok f l = length $ filterSame $ qsort $ zipWith f [0..] l
        filterSame [] = []
        filterSame [x] = [x]
        filterSame (x:y:xs) = if x == y then filterSame (x:xs) else x:(filterSame (y:xs))

-- >>> queens 5
-- [[1,3,0,2,4],[2,0,3,1,4],[2,4,1,3,0],[3,1,4,2,0],[1,4,2,0,3],[0,2,4,1,3],[3,0,2,4,1],[4,2,0,3,1],[0,3,1,4,2],[4,1,3,0,2]]
--

-- zad 4

data BinTree = BinTree :/\: BinTree | BinTreeLeaf deriving Show

binTree :: Int -> BinTree
binTree 0 = BinTreeLeaf
binTree n
    | even n    = let (n', _) = buildTree n in n'
    | otherwise = let (n', _  ) = buildTree n in n'
    where
        buildTree x
            | even x    = (div2 :/\: div21, div21 :/\: div21)
            | otherwise = (div2 :/\: div2 , div2  :/\: div21)
            where 
                div2  = binTree $ (x-1) `div` 2
                div21 = binTree $ (x-1) `div` 2 + 1

-- zad 5

class Queue q where
    emptyQ :: q a
    isEmptyQ :: q a -> Bool
    put :: a -> q a -> q a
    get :: q a -> (a, q a)
    get q = (top q, pop q)
    top :: q a -> a
    top = fst . get
    pop :: q a -> q a
    pop = snd . get

data SimpleQueue a = SimpleQueue { front :: [a], rear :: [a] } deriving Show
instance Queue SimpleQueue where
    emptyQ   = SimpleQueue [] []
    isEmptyQ q = case (front q, rear q) of
        ([], []) -> True
        _        -> False
    put a q = case (front q) of
        [] -> SimpleQueue [a] (rear q)
        xs -> SimpleQueue xs $ a:(rear q)
    get q = (top q, pop q)
    top q = case fq of
        [] -> case rq of
            [] -> error "Empty queue"
            _  -> top $ SimpleQueue (reverse rq) []
        h:_    -> h
        where
            fq = front q
            rq = rear q
    pop q = case fq of
        [] -> case rq of
            [] -> error "Empty queue"
            _  -> pop $ SimpleQueue (reverse rq) []
        _:t    -> SimpleQueue t rq
        where
            fq = front q
            rq = rear q

-- zad 6

primes :: [Integer]
primes = 2:[ p | p <- [3..], and [ p `mod` q /= 0 | q <- take (floor $ sqrt $ fromIntegral p) primes, q /= p ]]

-- >>> take 30 primes
-- [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113]
--

-- zad 7
fib :: [Integer]
fib = 0:1:zipWith (+) fib (tail fib)

-- >>> take 20 fib
-- [0,1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181]
--

-- zad 8
(<+>) :: Ord a => [a] -> [a] -> [a]
(<+>) [] l2 = l2
(<+>) l1 [] = l1
(<+>) l1@(h1:t1) l2@(h2:t2)
    | h2 < h1   = h2:(l1 <+> t2)
    | h1 == h2  = h2:(t1 <+> t2)
    | otherwise = h1:(t1 <+> l2)

d235 :: [Integer]
d235 = 1:[d | d <- foldl (<+>) [] [mul 2 d235, mul 3 d235, mul 5 d235]]
    where mul x = map (*x)
-- >>> take 20 d235
-- [1,2,3,4,5,6,8,9,10,12,15,16,18,20,24,25,27,30,32,36]
--

-- zad 9
bin :: UTree Int
bin = bin' 1
    where bin' a = UNode (bin' $ a * 2) a (bin' $ a * 2 + 1)

treeLabels :: UTree a -> Int -> [a]
treeLabels t w = flip aux w t [] where
    aux _ 0 acc = acc
    aux ULeaf _ acc = acc
    aux (UNode l x r) z acc = aux l (z `div` 2) (x : aux r (z `div` 2) acc ) 

-- >>> qsort $ treeLabels bin 16
-- [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
--

-- zad 10
data RoseTree a = RNode a [RoseTree a]

cycBin :: UTree Int
cycBin = UNode cycBin 1 cycBin

-- >>> treeLabels cycBin 16
-- [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
--

cycRose :: RoseTree Int
cycRose = RNode 1 $ rep cycRose
    where rep x = x:rep x

-- zad 11
showFragList :: Show a => Int -> [a] -> String
showFragList 0 _ = "[]"
showFragList x l = '[':tail (frag_aux x l)  where
    frag_aux x' l'
        | x' <= 0   = ",\8230]\n"
        | otherwise = case l' of 
                []    -> ",\8230]\n"
                (h:t) -> "," ++ (show h) ++ frag_aux (x'-1) t

-- >>> putStr $ showFragList 2 fib
-- [0,1,…]
--

showFragTree :: (BT t, Show a) => Int -> t a -> String
showFragTree _ (toTree -> Leaf) = " Leaf "
showFragTree 0 _ = " \8230 "
showFragTree n (toTree -> Node l x r) = " Node (" ++ showFragTree (n-1) l ++ ") " ++ show x ++ " (" ++ showFragTree (n-1) r ++ ") "
showFragTree _ _ = ""


-- >>> putStr $ showFragTree 3 cycBin
--  Node ( Node ( Node ( … ) 1 ( … ) ) 1 ( Node ( … ) 1 ( … ) ) ) 1 ( Node ( Node ( … ) 1 ( … ) ) 1 ( Node ( … ) 1 ( … ) ) ) 
--


showFragRose :: Show a => Int -> RoseTree a -> String
showFragRose i t = showFragRose' i t
    where
    showFragRose' 0 _ = " \8230 "
    showFragRose' n (RNode x l) = " RNode " ++ show x ++ " [ " ++ intercalate "," (map (uncurry showFragRose) $ take n $ zip (repeat (n-1)) l) ++ end
        where end = if (length $ take (n+1) l) < n then " ] " else  if n > 1 then ", \8230 ] " else " ] "

-- >>> putStr $ showFragRose 3 cycRose
--  RNode 1 [  RNode 1 [  RNode 1 [  …  ] , RNode 1 [  …  ] , … ] , RNode 1 [  RNode 1 [  …  ] , RNode 1 [  …  ] , … ] , RNode 1 [  RNode 1 [  …  ] , RNode 1 [  …  ] , … ] , … ] 
--

-- zad 12
data Cyclist a = Elem (Cyclist a) a (Cyclist a)

fromList :: [a] -> Cyclist a
fromList [] = error "Empty list"
fromList xs = Elem (fromList $ getElem (-1) xs) (head xs) (fromList $ getElem 1 xs)
    where
    getElem n ys
            | n > 0  = getElem (n-1) (tail ys ++ [head ys])
            | n < 0  = getElem (n+1) ((last ys):(init ys))
            | otherwise = ys

toList :: Cyclist a -> [a]
toList (Elem _ x r) = x:toList r

-- >>> take 10 $ toList $ fromList [1,2,3]
-- [1,2,3,1,2,3,1,2,3,1]
--

forward, backward :: Cyclist a -> Cyclist a
forward (Elem _ _ r)  = r
backward (Elem l _ _) = l

label :: Cyclist a -> a
label (Elem _ x _) = x

-- >>> label . forward . forward . forward . backward . forward . forward $ fromList [1,2,3]
-- 2
--

-- zad 13
enumInts :: Cyclist Integer
enumInts = enumInts' 0
    where
    enumInts' :: Integer -> Cyclist Integer
    enumInts' x = Elem (enumInts' $ (head . tail) [x,(x-1)..]) x (enumInts' $ (head . tail) [x..])

-- >>> label . forward . forward . forward . backward . forward . forward  $ enumInts
-- 4
--
