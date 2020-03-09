{-# LANGUAGE ParallelListComp #-}

import Data.List (delete)

zipF :: [a] -> [b] -> [(a,b)]
zipF [] [] = []
zipF (a:as) (b:bs) = (a,b) : zipF as bs

zipC :: [a] -> [b] -> [(a,b)]
zipC [] [] = []
zipC xs ys = [(l,k) | l <- xs | k <- ys]

subseqF :: [a] -> [[a]]
subseqF [] = [[]]
subseqF (x:xs) = foldr (\ ys zss -> (x:ys) : zss) yss yss where
    yss = subseqF xs

subseqC :: [a] -> [[a]]
subseqC [] = [[]]
subseqC [a] = [[a], []]
subseqC a = concat $ [ [ys, x : ys] | let (x:xs) = a, ys <- subseqC xs ]

-- >>> subseqC [1,2,3,4]
-- [[4],[1,4],[2,4],[1,2,4],[3,4],[1,3,4],[2,3,4],[1,2,3,4],[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]
--

ipermF :: [a] -> [[a]]
ipermF [] = [[]]
ipermF (x:xs) = concatMap insert (ipermF xs) where
    insert [] = [[x]]
    insert ys'@(y:ys) = (x:ys') : map (y:) (insert ys)

insertC :: a -> [a] -> [[a]]
insertC x [] = [[x]]
insertC x (h:t) = [x:(h:t) | y <- map (h:) (insertC x t)]

-- >>> insertC 1 [2,3]
-- [[1,2,3]]
--

ipermC :: Ord a => [a] -> [[a]]
ipermC []= [[]]
ipermC (h:t) = [ x | x <- (concatMap (insertC h) (ipermC t))]
-- >>> ipermC [1,2,3]
-- [[1,1,1]]
--

spermF :: [a] -> [[a]]
spermF [] = [[]]
spermF xs = concatMap (\ (y,ys) -> map (y:) (spermF ys)) (select xs) where
    select [y] = [(y,[])]
    select (y:ys) = (y,ys) : map (\ (z,zs) -> (z,y:zs)) (select ys)

spermC :: Ord a => [a] -> [[a]]
spermC []= [[]]
spermC l = [a:x | a <- l, x <- (spermC $ delete a l)]
-- >>> spermC [1,2,3]
-- <interactive>:756:2: error:
--     Variable not in scope: spermC :: [Integer] -> t
--

qsortF :: Ord a => [a] -> [a]
qsortF [] = []
qsortF (x:xs) = qsortF (filter (<= x) xs) ++ [x] ++ qsortF (filter (> x) xs)

qsortC :: Ord a => [a] -> [a]
qsortC [] = []
qsortC [a] = [a]
qsortC l = [ x | let (h:t) = l, x <- (qsortC (filter (<= h) t) ++ [h] ++ qsortC (filter (> h) t))]

-- >>> qsortC [-1,4,63,5,6,3,0]
-- [-1,0,3,4,5,6,63]
--

(<+>) :: Ord a => [a] -> [a] -> [a]
[] <+> ys = ys
xs <+> [] = xs
xs'@(x:xs) <+> ys'@(y:ys)
    | x <= y = x : (xs <+> ys')
    | otherwise = y : (xs' <+> ys)


-- zad 3
data Combinator = S | K | Combinator :$ Combinator
infixl :$

-- zad 5
data BST a = NodeBST (BST a) a (BST a) | EmptyBST deriving Show

searchBST :: Ord a => a -> BST a -> Maybe a
searchBST x EmptyBST = Nothing
searchBST x (NodeBST l n r) = if x == n then Just(n)
                                        else searchBST x (if n < x then r else l)

-- >>> searchBST 7 (NodeBST (NodeBST (NodeBST EmptyBST 1 EmptyBST) 3 (NodeBST (NodeBST EmptyBST 4 EmptyBST) 6 (NodeBST EmptyBST 7 EmptyBST))) 8 (NodeBST EmptyBST 10 (NodeBST (NodeBST EmptyBST 13 EmptyBST) 14 EmptyBST)))
-- Just 7
--

insertBST :: Ord a => a -> BST a -> BST a
insertBST x EmptyBST = NodeBST EmptyBST x EmptyBST
insertBST x tree@(NodeBST l n r)
    | n ==x = tree
    | n < x = NodeBST l n $ insertBST x r
    | n >=x = NodeBST (insertBST x l) n r

tree = (NodeBST (NodeBST (NodeBST EmptyBST 1 EmptyBST) 3 (NodeBST (NodeBST EmptyBST 4 EmptyBST) 6 (NodeBST EmptyBST 7 EmptyBST))) 8 (NodeBST EmptyBST 10 (NodeBST (NodeBST EmptyBST 13 EmptyBST) 14 EmptyBST)))

-- >>> insertBST 9 (NodeBST (NodeBST (NodeBST EmptyBST 1 EmptyBST) 3 (NodeBST (NodeBST EmptyBST 4 EmptyBST) 6 (NodeBST EmptyBST 7 EmptyBST))) 8 EmptyBST)
-- NodeBST (NodeBST (NodeBST EmptyBST 1 EmptyBST) 3 (NodeBST (NodeBST EmptyBST 4 EmptyBST) 6 (NodeBST EmptyBST 7 EmptyBST))) 8 (NodeBST EmptyBST 9 EmptyBST)
--

-- zad 6
deleteMaxBST :: Ord a => BST a -> (BST a , a)
deleteMaxBST EmptyBST = error "Empty tree"
deleteMaxBST (NodeBST l n EmptyBST) = (l, n)
deleteMaxBST (NodeBST l n r) = (NodeBST l n newR, res)
    where
        (newR, res) = deleteMaxBST r

-- >>> deleteMaxBST tree
-- (NodeBST (NodeBST (NodeBST EmptyBST 1 EmptyBST) 3 (NodeBST (NodeBST EmptyBST 4 EmptyBST) 6 (NodeBST EmptyBST 7 EmptyBST))) 8 (NodeBST EmptyBST 10 (NodeBST EmptyBST 13 EmptyBST)),14)
--

findMinBST :: Ord a => BST a -> a
findMinBST (NodeBST EmptyBST n r) = n
findMinBST (NodeBST l n r) = findMinBST l

deleteBST :: Ord a => a -> BST a -> BST a
deleteBST _ t@EmptyBST = t
deleteBST x (NodeBST EmptyBST _ EmptyBST) = EmptyBST
deleteBST x (NodeBST l n r)
    | x < n  = NodeBST (deleteBST x l) n r
    | x >  n = NodeBST l n (deleteBST x r)
    | x == n = case (l,r) of
                (EmptyBST, r) -> r
                (l, EmptyBST) -> l
                _ -> NodeBST l nn (deleteBST nn r)
                    where nn = findMinBST r
-- >>> deleteBST 8 tree
-- NodeBST (NodeBST (NodeBST EmptyBST 1 EmptyBST) 3 (NodeBST (NodeBST EmptyBST 4 EmptyBST) 6 (NodeBST EmptyBST 7 EmptyBST))) 10 (NodeBST (NodeBST EmptyBST 13 EmptyBST) 14 EmptyBST)
--

-- zad 7
data Tree23 a = Node2 (Tree23 a) a (Tree23 a)
              | Node3 (Tree23 a) a (Tree23 a) a (Tree23 a)
              | Empty23 deriving Show

search23 :: Ord a => a -> Tree23 a -> Maybe a
search23 x Empty23 = Nothing
search23 x (Node2 l n r)
    | n == x = Just(n)
    | n < x  = search23 x r
    | n > x  = search23 x l
search23 x (Node3 l n1 m n2 r)
    | n1 == x = Just(n1)
    | n2 == x = Just(n2)
    | x < n1  = search23 x l
    | n1 < x && x < n2 = search23 x m
    | n2 < x = search23 x r

tree23 = (Node2 (Node2 Empty23 2 Empty23) 5 (Node3 (Node2 Empty23 6 Empty23) 7 Empty23 10 (Node3 Empty23 12 Empty23 15 Empty23)))

-- >>> search23 7 tree23
-- Just 7
--

data InsResult a = BalancedIns (Tree23 a) | Grown (Tree23 a) a (Tree23 a)

ins :: Ord a => a -> Tree23 a -> InsResult a
ins x Empty23 = BalancedIns (Node2 Empty23 x Empty23)
ins x (Node2 l n r)
    | n == x = BalancedIns t
    | x < n  = BalancedIns (insert23 x l)
    | n < x  = BalancedIns (insert23 x r)
ins x (Node2 l n1 m n2 r)
    |

insert23 :: Ord a => a -> Tree23 a -> Tree23 a
insert23 x Empty23 = Node2 Empty23 x Empty23

