Łukasz Klasiński
Haskell Course
List 07
01-05-2020

> {-# LANGUAGE Rank2Types, GADTs, InstanceSigs, FlexibleInstances, MultiParamTypeClasses, UndecidableInstances, IncoherentInstances, AllowAmbiguousTypes #-}

> module Lab7 where

> import Data.List(unfoldr)

ex 1

> class Ord a => Prioq t a where
>     empty :: t a
>     isEmpty :: t a -> Bool
>     single :: a -> t a
>     insert :: a -> t a -> t a
>     merge :: t a -> t a -> t a
>     extractMin :: t a -> (a, t a)
>     findMin :: t a -> a
>     deleteMin :: t a -> t a
>     fromList :: [a] -> t a
>     toList :: t a -> [a]
>     insert = merge . single
>     single = flip insert empty
>     extractMin t = (findMin t, deleteMin t)
>     findMin = fst . extractMin
>     deleteMin = snd . extractMin
>     fromList = foldr insert empty
>     toList = unfoldr (\ t -> if isEmpty t then Nothing else Just (extractMin t))

> data PEmpty a = PEmpty deriving Show
> data PFork t a = PFork (t a) a (t a) deriving Show
> data Pennant t a = Pennant a (t a) deriving Show
> data PList t a = PNil
>     | PZero (PList (PFork t) a)
>     | POne (Pennant t a) (PList (PFork t) a) deriving Show
> newtype PHeap a = PHeap (PList PEmpty a) deriving Show

> instance Ord a => Prioq PHeap a where
>     empty = PHeap PNil
>     isEmpty (PHeap PNil) = True
>     isEmpty _            = False
>     merge (PHeap h1) (PHeap h2) = PHeap $ merge' h1 h2
>         where
>             merge' :: Ord a => PList t a -> PList t a -> PList t a
>             merge' (POne tree t1) (PZero t2) = POne tree $ merge' t1 t2
>             merge' (PZero t2) (POne tree t1) = POne tree $ merge' t1 t2
>             merge' (PZero t1) (PZero t2) = PZero $ merge' t1 t2
>             merge' (POne tree1 t1) (POne tree2 t2) = PZero $ merge' (mergeP tree1 tree2) $ merge' t1 t2
>                 where
>                 mergeP :: Ord a => Pennant t a -> Pennant t a -> PList (PFork t) a
>                 mergeP (Pennant x1 t1') (Pennant x2 t2')
>                     | x1 <= x2  = POne (Pennant x1 (PFork t1' x2 t2')) PNil
>                     | otherwise = POne (Pennant x2 (PFork t1' x1 t2')) PNil
>             merge' t PNil = t
>             merge' PNil t = t
>     single x = PHeap $ POne (Pennant x PEmpty) PNil
>     extractMin :: Ord a => PHeap a -> (a, PHeap a)
>     extractMin (PHeap tree) = case min' tree of
>                                 Just(v) -> let (h, l) = extract v (const []) tree in (v, squish $ foldr insert (PHeap h) l)
>                                 Nothing -> error "Empty heap"
>         where
>             min' :: Ord a => PList t a -> Maybe a
>             min' (POne (Pennant x _) t) = case min' t of
>                     Just(x') -> Just $ min x x'
>                     Nothing  -> Just x
>             min' (PZero t) = min' t
>             min' (PNil) = Nothing
>             extract :: Ord a => a -> (t a -> [a]) -> PList t a -> (PList t a, [a])
>             extract v r (POne p@(Pennant v' pt) t)
>                 | v' == v   = (PZero t, r pt)
>                 | otherwise = case t of
>                     PNil -> (PNil, r pt)
>                     _    -> let (r1, r2) = extract v (list r) t in (POne p $ r1, r2)
>             extract v r (PZero t) = let (r1, r2) = extract v (list r) t in (PZero r1, r2)
>             extract _ _ _ = (PNil, [])
>             list :: (t a -> [a]) -> PFork t a -> [a]
>             list r (PFork t1 t t2) = r t1 ++ t : r t2
>             squish :: Ord a => PHeap a -> PHeap a
>             squish h = let (PHeap g) = h in case min' g of
>                 Nothing -> PHeap PNil
>                 _       -> h

ex 2
W zasadzie kalka z 1

> data BEmpty a = BEmpty deriving Show
> data BCons l a = BCons (BFork l a) (l a) deriving Show
> data BFork l a = BFork a (l a) deriving Show
> data BList l a = BNil
>     | BZero (BList (BCons l) a)
>     | BOne (BFork l a) (BList (BCons l) a) deriving Show
> newtype BHeap a = BHeap (BList BEmpty a) deriving Show

> instance Ord a => Prioq BHeap a where
>     empty = BHeap BNil
>     single x = BHeap (BOne (BFork x BEmpty) BNil)
>     isEmpty (BHeap BNil) = True
>     isEmpty _ = False
>     merge (BHeap x1) (BHeap x2) = BHeap $ merge' x1 x2
>         where   
>             merge' :: Ord a => BList t a -> BList t a -> BList t a
>             merge' (BZero t1) (BOne tree t2) = BOne tree $ merge' t1 t2
>             merge' (BOne tree t2) (BZero t1) = BOne tree $ merge' t1 t2
>             merge' (BZero t1) (BZero t2) = BZero $ merge' t1 t2
>             merge' (BOne tree1 t1) (BOne tree2 t2) = BZero (merge' (mergeB tree1 tree2) (merge' t1 t2))
>             merge' t BNil = t
>             merge' BNil t = t
>             mergeB :: Ord a => BFork l a -> BFork l a -> BList (BCons l) a
>             mergeB (BFork e1 t1) (BFork e2 t2)
>                 | e1 < e2  = BOne (BFork e1 (BCons (BFork e2 t2) t1)) BNil
>                 | otherwise = BOne (BFork e2 (BCons (BFork e1 t2) t1)) BNil

>     extractMin :: Ord a => BHeap a -> (a, BHeap a)
>     extractMin (BHeap tree) = case min' tree of
>                                 Just(v) -> let (h, l) = extract v (const []) tree in (v, squish $ foldr insert (BHeap h) l)
>                                 Nothing -> error "Empty heap"
>         where
>             min' :: Ord a => BList t a -> Maybe a
>             min' (BOne (BFork x _) t) = case min' t of
>                     Just(x') -> Just $ min x x'
>                     Nothing  -> Just x
>             min' (BZero t) = min' t
>             min' (BNil) = Nothing
>             extract :: Ord a => a -> (t a -> [a]) -> BList t a -> (BList t a, [a])
>             extract v r (BOne f@(BFork v' pt) t)
>                 | v' == v   = (BZero t, r pt)
>                 | otherwise = case t of
>                     BNil -> (BNil, r pt)
>                     _    -> let (r1, r2) = extract v (list r) t in (BOne f $ r1, r2)
>             extract v r (BZero t) = let (r1, r2) = extract v (list r) t in (BZero r1, r2)
>             extract _ _ _ = (BNil, [])
>             list :: (t a -> [a]) -> BCons t a -> [a]
>             list r (BCons (BFork x l) t) = x : r l ++ r t
>             squish :: Ord a => BHeap a -> BHeap a
>             squish h = let (BHeap g) = h in case min' g of
>                 Nothing -> BHeap BNil
>                 _       -> h

ex 3

> data Expr a where
>     C :: a -> Expr a
>     P :: (Expr a, Expr b) -> Expr (a,b)
>     Not :: Expr Bool -> Expr Bool
>     (:+), (:-), (:*) :: Expr Integer -> Expr Integer -> Expr Integer
>     (:/) :: Expr Integer -> Expr Integer -> Expr (Integer,Integer)
>     (:<), (:>), (:<=), (:>=), (:!=), (:==) :: Expr Integer -> Expr Integer -> Expr Bool
>     (:&&), (:||) :: Expr Bool -> Expr Bool -> Expr Bool
>     (:?) :: Expr Bool -> Expr a -> Expr a -> Expr a
>     Fst :: Expr (a,b) -> Expr a
>     Snd :: Expr (a,b) -> Expr b

> eval :: Expr a -> a
> eval (C x) = x
> eval (P (e1,e2)) = (eval e1, eval e2)
> eval (Not e) = not $ eval e
> eval ((:+) e1 e2)   = eval e1 + eval e2
> eval ((:-) e1 e2)   = eval e1 - eval e2
> eval ((:*) e1 e2)   = eval e1 * eval e2
> eval ((:/) e1 e2)   = divMod (eval e1) (eval e2)
> eval ((:<=) e1 e2)  = eval e1 <= eval e2
> eval ((:<) e1 e2)   = eval e1 < eval e2
> eval ((:>=) e1 e2)  = eval e1 >= eval e2
> eval ((:>) e1 e2)   = eval e1 > eval e2
> eval ((:!=) e1 e2)  = eval e1 /= eval e2
> eval ((:==) e1 e2)  = eval e1 == eval e2
> eval ((:&&) e1 e2)  = eval e1 && eval e2
> eval ((:||) e1 e2)  = eval e1 || eval e2
> eval ((:?) b e1 e2) = if eval b then eval e1 else eval e2
> eval (Fst e) = fst $ eval e
> eval (Snd e) = snd $ eval e

ex 6

> newtype Church = Church (forall a. (a -> a) -> (a -> a))

> cpred :: Church -> Church
> cpred (Church n) = Church $ \f x -> n (\g h -> h (g f)) (\_ -> x) (\u -> u)

> isZero :: Church -> Bool
> isZero (Church n) = n (const False) True

> instance Eq Church where
>     (==) x1 x2
>         | isZero x1 && isZero x2 = True
>         | isZero x1 = False
>         | isZero x2 = False
>         | otherwise = (cpred x1) == (cpred x2)

> instance Ord Church where
>     (<=) x1 x2
>         | isZero x1 && isZero x2 = True
>         | isZero x1 = True
>         | isZero x2 = False
>         | otherwise = (cpred x1) <= (cpred x2)

> instance Show Church where
>    show c
>         | isZero c = "x"
>         | otherwise = "f " ++ show (cpred c)

> instance Num Church where
>     (Church x1) + (Church x2) = Church $ \f -> x1 f . x2 f
>     (Church x1) * (Church x2) = Church $ x1 . x2
>     x1 - x2@(Church x2')
>         | x1 <= x2  = 0
>         | otherwise = (x2' cpred) x1
>     abs = id
>     signum x1
>         | isZero x1 = 0
>         | otherwise = 1
>     fromInteger n = aux n 0
>         where
>             aux k acc
>                 | k == acc  = Church $ \_ m -> m
>                 | otherwise = Church $ \f -> f . x f
>                     where (Church x) = aux k (acc+1)

ex 7

> newtype CList x = CList (forall a. (x -> a -> a) -> a -> a)

> emptyC :: CList x
> emptyC = CList $ \_ x -> x
> consC :: x -> CList x -> CList x
> consC h (CList t) = CList $ \c n -> c h (t c n) 
> appendC :: CList x -> CList x -> CList x
> appendC (CList l1) (CList l2) = CList $ \t c -> l1 t (l2 t c)
> fromListC :: [x] -> CList x
> fromListC list = foldr consC emptyC list
> toListC :: CList x -> [x]
> toListC (CList x) = x (:) []