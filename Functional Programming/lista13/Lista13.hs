import Control.Monad (liftM, ap)
import Control.Monad.State
{- Łukasz Klasiński -}

data Tree a = Leaf a | Branch (Tree a) (Tree a)
 deriving (Eq, Ord, Show, Read)

{-
label :: Tree a -> Tree(a, Int)
label tree = labelInt tree 0
    where
    labelInt :: Tree a -> Int -> Tree(a, Int)
    labelInt (Leaf a) n = Leaf (a, n)
    labelInt (Branch t1 t2) n = let lt1 = labelInt t1 n in
                                let lt2 = labelInt t2 ((getMax lt1)+1) in
                                    (Branch lt1 lt2)
getMax :: Tree(a, Int) -> Int
getMax (Leaf (_, n)) = n
getMax (Branch t1 t2) = let n1 = getMax t1 in
                        let n2 = getMax t2 in
                        if n1 > n2 then n1
                        else n2
-}

label :: Tree a -> Tree(a, Int)
label tree = let (_, t) = labelInt tree 0 in t
    where
    labelInt :: Tree a -> Int -> (Int, Tree(a, Int))
    labelInt (Leaf a) n = (n+1, Leaf (a, n))
    labelInt (Branch t1 t2) n = let (i1, lt1) = labelInt t1 n 
                                in let (i2, lt2) = labelInt t2 i1 
                                   in (i2, Branch lt1 lt2)

-- >>>  let t = Branch (Leaf 'a') (Leaf 'b') in label (Branch t t)
-- Branch (Branch (Leaf ('a',0)) (Leaf ('b',1))) (Branch (Leaf ('a',2)) (Leaf ('b',3)))
--

type TreeInt a = State Int a
mlabel :: Tree a -> Tree(a, Int)
mlabel tree = evalState (mrunL tree) 0

mrunL :: Tree a -> TreeInt (Tree (a, Int))
mrunL (Leaf a) = do n <- get
                    put (n+1)
                    return (Leaf (a, n))

mrunL (Branch t1 t2) = do nt1 <- mrunL t1
                          nt2 <- mrunL t2
                          return (Branch nt1 nt2)

-- >>>  let t = Branch (Leaf 'a') (Leaf 'b') in mlabel (Branch t t)
-- Branch (Branch (Leaf ('a',0)) (Leaf ('b',1))) (Branch (Leaf ('a',2)) (Leaf ('b',3)))
--
