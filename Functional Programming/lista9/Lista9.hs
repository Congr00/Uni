import Data.List(splitAt)
import Data.List(length)
import Data.List(reverse)

{- Łukasz Klasiński -}

data Tree a = Leaf a | Node (Tree a) (Tree a)
    deriving (Eq,Ord,Show,Read)
data BTree a = BLeaf | BNode (BTree a) a (BTree a)
    deriving (Eq,Ord,Show,Read)
data MtreeL a = MTL a [MtreeL a]
    deriving (Eq,Ord,Show,Read)


{- zad1 -}
isBalanced :: Tree a -> Bool
isBalanced (Leaf _) = True
isBalanced (Node l r) = let c1 = count l in
                        let c2 = count r in
                        abs (c1 - c2) <= 1
    where
    count :: Tree a -> Integer
    count (Leaf _) = 1
    count (Node l r) = count l + count r

-- >>> isBalanced (Node(Node(Leaf 0)(Leaf 1))(Node(Leaf 0)(Leaf 1)))
-- True
--
-- >>> isBalanced (Node(Node(Leaf 0)(Leaf 1))(Leaf 1))
-- True
--
-- >>> isBalanced (Node(Node(Leaf 0)(Node(Leaf 0)(Leaf 0)))(Leaf 1))
-- False
--

{- zad2 -}
balance :: [a] -> Tree a
balance [] = error "Empty List!"
balance [hd] = Leaf hd
balance list = let len = length list in
               let (l1, l2) = splitAt (len `div` 2) list in
               Node(balance l1)(balance l2)

-- >>> balance [1,2,3,4,5,6,7,8,9,10,11]
-- Node (Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Node (Leaf 4) (Leaf 5)))) (Node (Node (Leaf 6) (Node (Leaf 7) (Leaf 8))) (Node (Leaf 9) (Node (Leaf 10) (Leaf 11))))
--
-- >>> isBalanced (balance [1,2,3,4,5,6,7,8,9,10,11])
-- True
--

{- zad3 -}
outsideLen :: BTree a -> Integer
outsideLen BLeaf = 0
outsideLen (BNode l _ r) = 2 + outsideLen l + outsideLen r

insideLen :: BTree a -> Integer
insideLen tree = insideLenAux 0 tree
    where
    insideLenAux :: Integer -> BTree a -> Integer
    insideLenAux sum BLeaf = 0
    insideLenAux sum (BNode l _ r) = sum + insideLenAux (sum+1) l + insideLenAux (sum+1) r

-- >>> outsideLen (BNode (BNode BLeaf 0 (BNode BLeaf 0 BLeaf)) 0 BLeaf)
-- 6
--
-- >>> insideLen (BNode (BNode BLeaf 0 (BNode BLeaf 0 BLeaf)) 0 BLeaf)
-- 3
--
t :: [Int] -> [Int]
t [] = []
t (h:[]) = [h]
t (h1:h2:tl) = if h1 == h2 then t (h2:tl) else h1:(h2:tl)

t2 :: [Int] -> [Int]
t2 l = let r = t l in reverse $ t $ reverse r 

-- >>> t2 [1,1,1,2,2,3,3]
-- [1,2,2,3]
--


{- zad4 -}
mtreePrefixIter :: MtreeL a -> (a -> b) -> [b]
mtreePrefixIter tree fn = mtreePrefixIterAux tree fn False
    where
    mtreePrefixIterAux :: MtreeL a -> (a -> b) -> Bool -> [b]
    mtreePrefixIterAux (MTL v []) fn False = [fn v]
    mtreePrefixIterAux (MTL _ []) fn True = []
    mtreePrefixIterAux (MTL v (hd:tl)) fn True = mtreePrefixIterAux hd fn False ++ mtreePrefixIterAux (MTL v tl) fn True 
    mtreePrefixIterAux (MTL v tree) fn False = fn v:mtreePrefixIterAux (MTL v tree) fn True

-- >>> mtreePrefixIter (MTL 0 [(MTL 1 [(MTL 3 [(MTL 5 [])]), (MTL 4 [])]),(MTL 3 [])]) (\a -> a)
-- [0,1,3,5,4,3]
--

mtreeBreadthIter :: MtreeL a -> (a -> b) -> [b]
mtreeBreadthIter tree fn = mtreeBreadthIterAux tree fn False
    where
        mtreeBreadthIterAux :: MtreeL a -> (a -> b) -> Bool -> [b]
        mtreeBreadthIterAux (MTL v []) fn False = [fn v]
        mtreeBreadthIterAux (MTL _ []) fn True = []
        mtreeBreadthIterAux (MTL v (hd:tl)) fn True = mtreeBreadthIterAux (MTL v tl) fn True ++ mtreeBreadthIterAux hd fn False
        mtreeBreadthIterAux (MTL v tree) fn False = fn v:mtreeBreadthIterAux (MTL v tree) fn True

-- >>> mtreeBreadthIter (MTL 0 [(MTL 1 [(MTL 3 [(MTL 5 [])]), (MTL 4 [])]),(MTL 2 [])]) (\a -> a)
-- [0,2,1,4,3,5]
--