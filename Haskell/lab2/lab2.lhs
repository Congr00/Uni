Łukasz Klasiński
Haskell Course
List 02
12-03-2020

> {-# LANGUAGE ParallelListComp #-}

> import Data.List (delete)

--
ex 1
--

> zipF :: [a] -> [b] -> [(a,b)]
> zipF [] [] = []
> zipF (a:as) (b:bs) = (a,b) : zipF as bs

> zipC :: [a] -> [b] -> [(a,b)]
> zipC [] [] = []
> zipC xs ys = [(l,k) | l <- xs | k <- ys]

> subseqF :: [a] -> [[a]]
> subseqF [] = [[]]
> subseqF (x:xs) = foldr (\ ys zss -> (x:ys) : zss) yss yss where
>     yss = subseqF xs

> subseqC :: [a] -> [[a]]
> subseqC [] = [[]]
> subseqC [a] = [[a], []]
> subseqC a = concat $ [ [ys, x : ys] | let (x:xs) = a, ys <- subseqC xs ]

> ipermF :: [a] -> [[a]]
> ipermF [] = [[]]
> ipermF (x:xs) = concatMap insert (ipermF xs) where
>     insert [] = [[x]]
>     insert ys'@(y:ys) = (x:ys') : map (y:) (insert ys)

> insertC :: a -> [a] -> [[a]]
> insertC x [] = [[x]]
> insertC x ys@(h:t) = [x:ys] ++ [ y | y <- map (h:) (insertC x t)]

> ipermC :: Ord a => [a] -> [[a]]
> ipermC []= [[]]
> ipermC (h:t) = [ x | x <- (concatMap (insertC h) (ipermC t))]

> spermF :: [a] -> [[a]]
> spermF [] = [[]]
> spermF xs = concatMap (\ (y,ys) -> map (y:) (spermF ys)) (select xs) where
>     select [y] = [(y,[])]
>     select (y:ys) = (y,ys) : map (\ (z,zs) -> (z,y:zs)) (select ys)

> spermC :: Ord a => [a] -> [[a]]
> spermC [] = [[]]
> spermC l = [a:x | a <- l, x <- (spermC $ delete a l)]

> qsortF :: Ord a => [a] -> [a]
> qsortF [] = []
> qsortF (x:xs) = qsortF (filter (<= x) xs) ++ [x] ++ qsortF (filter (> x) xs)

> qsortC :: Ord a => [a] -> [a]
> qsortC [] = []
> qsortC [a] = [a]
> qsortC (h:t) = [ x | x <- (qsortC [f | f <- t , f <= h] ++ [h] ++ qsortC ([f | f <- t, f > h]))]

-- 
ex 3
--

> data Combinator = S | K | Combinator :$ Combinator
> infixl :$

> instance Show Combinator where
>     show S = "S"
>     show K = "K"
>     show (l :$ r@(_ :$ _)) = show l ++ "(" ++ show r ++ ")"
>     show (l :$ r) = show l ++ show r

--
ex 5
--

> data BST a = NodeBST (BST a) a (BST a) | EmptyBST deriving Show

> searchBST :: Ord a => a -> BST a -> Maybe a
> searchBST x EmptyBST = Nothing
> searchBST x (NodeBST l n r) = if x == n then Just(n)
>                                         else searchBST x (if n < x then r else l)

--
ex 6
--

> insertBST :: Ord a => a -> BST a -> BST a
> insertBST x EmptyBST = NodeBST EmptyBST x EmptyBST
> insertBST x tree@(NodeBST l n r)
>     | n ==x = tree
>     | n < x = NodeBST l n $ insertBST x r
>     | n >=x = NodeBST (insertBST x l) n r

--
ex 7
--

> deleteMaxBST :: Ord a => BST a -> (BST a , a)
> deleteMaxBST EmptyBST = error "Empty tree"
> deleteMaxBST (NodeBST l n EmptyBST) = (l, n)
> deleteMaxBST (NodeBST l n r) = (NodeBST l n newR, res)
>     where
>         (newR, res) = deleteMaxBST r

> findMinBST :: Ord a => BST a -> a
> findMinBST (NodeBST EmptyBST n r) = n
> findMinBST (NodeBST l n r) = findMinBST l

> deleteBST :: Ord a => a -> BST a -> BST a
> deleteBST _ EmptyBST = EmptyBST
> deleteBST x (NodeBST EmptyBST _ EmptyBST) = EmptyBST
> deleteBST x (NodeBST l n r)
>     | x < n  = NodeBST (deleteBST x l) n r
>     | x >  n = NodeBST l n (deleteBST x r)
>     | x == n = case (l,r) of
>                 (EmptyBST, r) -> r
>                 (l, EmptyBST) -> l
>                 _             -> NodeBST l nn (deleteBST nn r)
>                     where nn = findMinBST r

--
ex 7
--

> data Tree23 a = Node2 (Tree23 a) a (Tree23 a)
>               | Node3 (Tree23 a) a (Tree23 a) a (Tree23 a)
>               | Empty23 deriving Show

> search23 :: Ord a => a -> Tree23 a -> Maybe a
> search23 x Empty23 = Nothing
> search23 x (Node2 l n r)
>     | n == x = Just(n)
>     | n < x  = search23 x r
>     | n > x  = search23 x l
> search23 x (Node3 l n1 m n2 r)
>     | n1 == x = Just(n1)
>     | n2 == x = Just(n2)
>     | x < n1  = search23 x l
>     | n1 < x && x < n2 = search23 x m
>     | n2 < x = search23 x r

--
ex 8
--

> data InsResult a = BalancedIns (Tree23 a) | Grown (Tree23 a) a (Tree23 a)

> ins :: Ord a => a -> Tree23 a -> InsResult a
> ins x Empty23 = Grown Empty23 x Empty23
> ins x t@(Node2 Empty23 n Empty23)
>     | n == x = BalancedIns t
>     | n < x  = BalancedIns (Node3 Empty23 n Empty23 x Empty23)
>     | n > x  = BalancedIns (Node3 Empty23 x Empty23 n Empty23)
> ins x t@(Node2 l n r)
>     | n == x = BalancedIns t
>     | x < n  = BalancedIns $ case ins x l of
>                     -- rot right node2
>                     BalancedIns t' -> Node2 t' n r
>                     Grown l' x' r' -> Node3 l' x' r' n r
>     | x > n  = BalancedIns $ case ins x r of
>                     -- rot left node2
>                     BalancedIns t' -> Node2 l n t'
>                     Grown l' x' r' -> Node3 l n l' x' r'
> ins x t@(Node3 l n1 m n2 r)
>     | n1 == x || n2 == x = BalancedIns t
>     | x < n1 = case l of
>                 Empty23 -> Grown (Node2 Empty23 x Empty23) n1 (Node2 m n2 r)
>                 _       -> case ins x l of
>                     -- rot right node3
>                     BalancedIns t' -> BalancedIns(Node3 t' n1 m n2 r)
>                     Grown l' x' r' -> Grown (Node2 l' x' r') n1 (Node2 m n2 r)
>     | n1 < x && x < n2 = case m of
>                           Empty23 -> Grown (Node2 l n1 Empty23) x (Node2 Empty23 n2 r)
>                           _       -> case ins x m of
>                               -- rot middle node3
>                                 BalancedIns t' -> BalancedIns(Node3 t' n1 m n2 r)
>                                 Grown l' x' r' -> Grown (Node2 l n1 l') x' (Node2 r' n2 r)
>     | n2 < x = case r of
>                 Empty23 -> Grown (Node2 l n1 m) n2 (Node2 Empty23 x Empty23)
>                 _       -> case ins x r of
>                     -- rot left node3
>                     BalancedIns t' -> BalancedIns(Node3 t' n1 m n2 r)
>                     Grown l' x' r' -> Grown (Node2 l n1 m) n2 (Node2 l' x' r')


> insert23 :: Ord a => a -> Tree23 a -> Tree23 a
> insert23 x t = case ins x t of
>         BalancedIns t -> t
>         Grown l n r -> Node2 l n r

--
ex 10
--

> data Tree234 a = N2 (Tree234 a) a (Tree234 a)
>     | N3 (Tree234 a) a (Tree234 a) a (Tree234 a)
>     | N4 (Tree234 a) a (Tree234 a) a (Tree234 a) a (Tree234 a)
>     | E234 deriving Show

> data RBTree a = Black (RBTree a) a (RBTree a)
>     | Red (RBTree a) a (RBTree a)
>     | RBTEmpty deriving Show

> from234 :: Tree234 a -> RBTree a
> from234 E234 = RBTEmpty
> from234 (N2 l n r) = Black (from234 l) n (from234 r) 
> from234 (N3 l n1 m n2 r) = Black (from234 l) n1 (Red (from234 m) n2 (from234 r))
> from234 (N4 l n1 m1 n2 m2 n3 r) = Black (Red (from234 l) n1 (from234 m1)) n2 (Red (from234 m2) n3 (from234 r))

> to234 :: RBTree a -> Tree234 a
> to234 RBTEmpty = E234
> to234 (Black RBTEmpty n RBTEmpty) = N2 E234 n E234
> to234 (Black RBTEmpty n (Red l n2 r)) = N3 E234 n (to234 l) n2 (to234 r)
> to234 (Black (Red l n2 r) n RBTEmpty) = N3 (to234 l) n2 (to234 r) n E234
> to234 (Black (Red l n1 m1) n2 (Red m2 n3 r)) = N4 (to234 l) n1 (to234 m1) n2 (to234 m2) n3 (to234 r)
> to234 _ = E234