--Łukasz Klasiński
--Haskell Course
--List 06
--17-04-2020

{-# LANGUAGE MultiParamTypeClasses #-}

import Control.Monad

-- zad 1

natPairs :: [(Integer, Integer)]
natPairs = natPairs' 0
    where 
        natPairs' :: Int -> [(Integer, Integer)]
        natPairs' m = [(toInteger x, toInteger y) | (x,y) <- zip [0..m] [m,m-1..0]] ++ natPairs' (m+1)

(><) :: [a] -> [b] -> [(a,b)]
(><) a b = aux 0
    where aux m = case cond $ m+1 of
            False -> [(a !! x, b !! y) | (x,y) <- zip [0..m] [m,m-1..0]] ++ aux (m+1)
            True  -> []
          cond m = length (take m a) /= m || length (take m b) /= m

-- zad 2

class Set s where
    empty :: s a
    search :: Ord a => a -> s a -> Maybe a
    insert :: Ord a => a -> s a -> s a
    delMax :: Ord a => s a -> Maybe (a, s a)
    delete :: Ord a => a -> s a -> s a

class Dictionary d where
    emptyD :: d k v
    searchD :: Ord k => k -> d k v -> Maybe v
    insertD :: Ord k => k -> v -> d k v -> d k v
    deleteD :: Ord k => k -> d k v -> d k v

data KeyValue key value = KeyValue { key :: key, value :: value }
newtype SetToDict s k v = SetToDict (s (KeyValue k v))

instance Eq a => Eq (KeyValue a b) where
  (==) (KeyValue a _) (KeyValue b _) = a == b

instance Ord a => Ord (KeyValue a b) where
  compare (KeyValue a _) (KeyValue b _) = a `compare` b

instance Set s => Dictionary (SetToDict s) where
  emptyD = SetToDict empty
  searchD k (SetToDict s) = fmap value $ search (KeyValue k undefined) s
  insertD k v (SetToDict s) = SetToDict $ insert (KeyValue k v) s
  deleteD k (SetToDict s) = SetToDict $ delete (KeyValue k undefined) s

data PrimRec = Zero | Succ | Proj Int Int
    | Comb PrimRec [PrimRec] | Rec PrimRec PrimRec

arityCheck :: PrimRec -> Maybe Int
arityCheck Zero = Just 1
arityCheck Succ = Just 1
arityCheck (Proj n i) = if 1 > i || i > n then Nothing else Just n
arityCheck (Comb f g) = do   af  <- arityCheck f
                             ags <- mapM arityCheck g
                             let gh = head ags
                             guard $ length ags == af
                             guard $ all (== gh) ags
                             return gh
arityCheck (Rec g h) = do   ag <- arityCheck g
                            ah <- arityCheck h
                            guard $ ag + 2 == ah
                            return $ ag + 1

-- zad 4

evalPrimRec :: PrimRec -> [Integer] -> Integer
evalPrimRec r a = case arityCheck r of
        Nothing -> error "Wrong function arity"
        Just af -> if length a /= af then error "Wrong number of arguments for f"
                   else if (length $ filter (< 0) a) /= 0 then error "Negative numbers in arguments"
                   else evalPrimRec' r a
    where
        evalPrimRec' Zero _    = 1
        evalPrimRec' Succ args = head args + 1
        evalPrimRec' (Proj _ i) args = args !! (i-1)
        evalPrimRec' (Comb f g) args = evalPrimRec f $ map (flip evalPrimRec args) g
        evalPrimRec' re@(Rec g h) args = case head args of
                            0 -> evalPrimRec g $ targs
                            n -> evalPrimRec h $ (n-1):(evalPrimRec re $ (n-1):targs):targs
                        where targs = tail args

-- zad 5

data Nat = S Nat | Z deriving Show

iter :: (a -> a) -> a -> Nat -> a
iter _ g Z = g
iter f g (S n) = f (iter f g n)

rec' :: (Nat -> a -> a) -> a -> Nat -> a
rec' f g n = snd $ iter (\(x,y) -> (S x, f (S x) y)) (Z, g) n

-- zad 6

tailf :: [a] -> [a]
tailf l = fst $ foldr (\a (b, n) -> if n /= ll then (a:b, n+1) else (b, n+1)) ([], 0) l
    where ll = length l - 1

reversef :: [a] -> [a]
reversef = foldr (flip (++) . pure) []

zipf :: [a] -> [b] -> [(a,b)]
zipf a b = fst $ foldr (\x (y, n) -> ((x,b !! (n-1)):y, n-1)) ([], l) (take l a)
    where l = min (length a) (length b)

-- zad 7
data RAList a = RAZero (RAList (a,a)) | RAOne a (RAList (a,a)) | RANil deriving Show

data List t a = Cons a (t a) | Nil deriving Show
class ListView t where
    viewList :: t a -> List t a
    toList :: t a -> [a]
    cons :: a -> t a -> t a
    nil :: t a

instance ListView RAList where
    nil = RANil
    toList l = case l of
        RANil -> []
        (RAZero xs)  -> concatMap catPair (toList xs)
        (RAOne x xs) -> x : concatMap catPair (toList xs)
        where   catPair (a,b) = [a, b]
    viewList r = case toList r of
                        []    -> Nil
                        (h:t) -> Cons h (foldr cons nil t)
    cons x RANil = RAOne x nil
    cons x (RAOne v RANil) = RAZero $ RAOne (v,x) nil
    cons x (RAOne v (RAZero xs)) = RAZero $ RAOne (v,x) xs
    cons x (RAOne v xs) = RAZero $ RAZero (rotate (v,x) xs)
        where
            rotate :: a -> RAList a -> RAList (a,a)
            rotate a (RAOne b RANil) = RAOne (a,b) nil
            rotate a (RAOne b ys) = RAZero $ rotate (a,b) ys
            -- to stop exshaustive warnings
            rotate _ _ = nil
    cons x (RAZero xs) = RAOne x xs

