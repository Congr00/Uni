{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE IncoherentInstances #-}

import Data.Char (isSpace)

data BTree t a = Node (t a) a (t a) | Leaf
class BT t where
    toTree :: t a -> BTree t a

data UTree a = UNode (UTree a) a (UTree a) | ULeaf
instance BT UTree where
    toTree ULeaf = Leaf
    toTree (UNode l x r) = Node l x r

-- zad1

treeSize :: BT t => t a -> Int
treeSize (toTree -> Leaf)       = 0
treeSize (toTree -> Node l _ r) = treeSize l + treeSize r + 1
treeSize _ = 0

treeHeight :: BT t => t a -> Int
treeHeight (toTree -> Leaf)       = 0
treeHeight (toTree -> Node l _ r) = 1 + max (treeHeight l) (treeHeight r)
treeHeight _ = 0

treeLabels :: BT t => t a -> [a]
treeLabels = flip aux [] where
    aux (toTree -> Leaf) acc       = acc
    aux (toTree -> Node l x r) acc = aux l (x : aux r acc)
    aux _ _ = []

treeFold :: BT t => (b -> a -> b -> b) -> b -> t a -> b
treeFold _ e (toTree -> Leaf)       = e
treeFold n e (toTree -> Node l x r) = n (treeFold n e l) x (treeFold n e r)
treeFold _ e _ = e

newtype Unbalanced a = Unbalanced { fromUnbalanced :: BTree Unbalanced a }
instance BT Unbalanced where
    toTree = fromUnbalanced

-- zad2
searchBT :: (Ord a, BT t) => a -> t a -> Maybe a
searchBT _ (toTree -> Leaf) = Nothing
searchBT x (toTree -> Node l n r) 
    | n < x     = searchBT x l
    | n > x     = searchBT x r
    | otherwise = Just n
searchBT _ _ = Nothing

toUTree :: BT t => t a -> UTree a
toUTree (toTree -> Leaf)       = ULeaf
toUTree (toTree -> Node l x r) = UNode (toUTree l) x (toUTree r)
toUTree _ = ULeaf

toUnbalanced :: BT t => t a -> Unbalanced a
toUnbalanced (toTree -> Leaf) = Unbalanced Leaf
toUnbalanced (toTree -> Node l x r) = Unbalanced $ Node (toUnbalanced l) x (toUnbalanced r)

-- zad3

printTree :: (BT t, Show a) => t a -> String
printTree(toTree -> Leaf) = "-"
printTree(toTree -> Node l x r) = wrap l ++ show x ++ wrap r
  where
      wrap (toTree -> Leaf)           = " - " 
      wrap x = " (" ++ show x ++ ") "

-- >>> UNode ULeaf 5 $ UNode ULeaf 2 ULeaf
--  - 5 ( - 2 - ) 
--

-- zad 4

instance (BT t, Show a) => Show (t a) where
    show x = (concatMap (++ "\n" )) $ bfsIter height [x] [ if y == ((height) `div` 2) then "\9472" else " " | y <- [0..(height-1)]]
        where
            height = 2 ^ (treeHeight x) -1

assciNode :: (BT t, Show a) => Int -> t a -> [String]
assciNode h (toTree -> Leaf) = [" " | _ <- [0..h]]
assciNode h (toTree -> Node l n r) = [charInserter y h n (isLeaf l) (isLeaf r) | y <- [0..h]]
    where
    isLeaf (toTree -> Leaf) = True
    isLeaf _ = False

    charInserter y h n st sb
        | y == h `div` 2 = show n
        | y < qrt  = " "
        | y == qrt = if sb then " " else "\9484"
        | y > qrt && y < h `div` 2 = if sb then " " else "\9474"
        | y > h `div` 2 && y < (h - qrt) = if st then " " else "\9474"
        | y == (h - qrt) = if st then " " else "\9492"
        | y > (h - qrt) = " "
            where
                qrt = h `div` 4

bfsIter :: (BT t, Show a) => Int -> [t a] -> [String] -> [String] 
bfsIter 0 _ acc = filter (not . all isSpace) acc
bfsIter h xs acc = bfsIter (h `div` 2) (concat (map nodeList xs)) $ zipWith (++) acc $ concat $ divInserter (map (assciNode (h-1)) xs) [" "]
    where
        divInserter [] _  = []
        divInserter [x] _ = [x]
        divInserter (h:t) d = h:d:divInserter t d

        nodeList t@(toTree -> Leaf) = [t,t]
        nodeList (toTree -> Node l _ r) = [r,l]


-- >>> UNode (UNode ULeaf 2 (UNode ULeaf 21 ULeaf)) 5 (UNode (UNode ULeaf 11 ULeaf) 3 (UNode (UNode ULeaf 11 ULeaf) 9 (UNode ULeaf 21 ULeaf)))
--    ┌21
--   ┌9 
--   │└11
--  ┌3  
--  ││  
--  │└11 
--  │   
-- ─5   
--  │   
--  │┌21 
--  ││  
--  └2  
-- <BLANKLINE>
--

-- zad6

class BT t => BST t where
    node :: t a -> a -> t a -> t a
    leaf :: t a

instance BST UTree where
    node = UNode
    leaf = ULeaf
instance BST Unbalanced where
    node l x r = Unbalanced $ Node l x r
    leaf = Unbalanced Leaf

class Set s where
    empty :: s a
    search :: Ord a => a -> s a -> Maybe a
    insert :: Ord a => a -> s a -> s a
    delMax :: Ord a => s a -> Maybe (a, s a)
    delete :: Ord a => a -> s a -> s a

instance BST s => Set s where
    empty = leaf
    search = searchBT
    insert x (toTree -> Leaf) = node leaf x leaf
    insert x (toTree -> Node l n r)
        | x < n     = node (insert x l) n r
        | otherwise = node l n (insert x r)
    delMax (toTree -> Leaf) = Nothing
    delMax (toTree -> Node l n (toTree -> Leaf)) = Just(n, l)
    delMax (toTree -> Node l n r) = Just (n', node l n r')
        where Just(n', r') = delMax r
    delete _ (toTree -> Leaf) = leaf
    delete x (toTree -> Node (toTree -> Leaf) n (toTree -> Leaf)) = if n == x then leaf else node leaf n leaf
    delete x (toTree -> Node l n r)
        | x < n  = node (delete x l) n r
        | x > n  = node l n (delete x r)
        | x == n = case (l,r) of
                (toTree -> Leaf, r) -> r
                (l, toTree -> Leaf) -> l
                _ -> node l nn (delete nn r)
                    where nn = minimum $ treeLabels r

-- >>>  delete 21 $ UNode (UNode ULeaf 2 (UNode ULeaf 3 ULeaf)) 5 (UNode (UNode ULeaf 7 ULeaf) 6 (UNode (UNode ULeaf 8 ULeaf) 9 (UNode ULeaf 21 ULeaf)))
--   ┌9 
--   │└8
--  ┌6  
--  ││  
--  │└7 
--  │   
-- ─5   
--  │   
--  │┌3 
--  ││  
--  └2  
-- <BLANKLINE>
--

--zad7

data WBTree a = WBNode (WBTree a) a Int (WBTree a) | WBLeaf

instance BT WBTree where
    toTree WBLeaf = Leaf
    toTree (WBNode l x _ r) = Node l x r

wbsize :: WBTree a -> Int
wbsize (WBNode _ _ n _) = n
wbsize WBLeaf = 0


instance BST WBTree where
    leaf = WBLeaf
    node l x r = let (sl, sr) = (wbsize l, wbsize r)
                     p        = WBNode l x (sl+sr+1) r
            in
                if sl + sr < 2 then p
                else if sr > ω * sl then        -- right subtree too big
                    let WBNode rl _ _ rr = r 
                        (srl, srr)       = (wbsize rl, wbsize rr)
                    in if srl < srr then single_rot_l p else double_rot_l p
                else if sl > ω * sr then        -- left subtree too big
                    let WBNode ll _ _ lr = l
                        (sll, slr)       = (wbsize ll, wbsize lr)
                    in if slr < sll then single_rot_r p else double_rot_r p
                else p
            where ω = 5

single_rot_l (toTree -> Node x a (toTree -> Node y b z))                        = node (node x a y) b z
single_rot_r (toTree -> Node (toTree -> Node x a y) b z)                        = node x a (node y b z)
double_rot_l (toTree -> Node x a (toTree -> Node (toTree -> Node y1 b y2) c z)) = node (node x a y1) b (node y2 c z)
double_rot_r (toTree -> Node (toTree -> Node x a (toTree -> Node y1 b y2)) c z) = node (node x a y1) b (node y2 c z)

-- >>>  foldl (flip insert) WBLeaf [0..10]
--     ┌10
--    ┌9 
--    │└8
--   ┌7  
--   ││  
--   │└6 
--   │   
--  ┌5   
--  ││   
--  ││   
--  ││   
--  │└4  
--  │    
--  │    
--  │    
-- ─3    
--  │    
--  │    
--  │    
--  │┌2  
--  ││   
--  ││   
--  ││   
--  └1   
--   │   
--   │   
--   │   
--   └0  
-- <BLANKLINE>
--

-- zad 8

data HBTree a = HBNode (HBTree a) a Int (HBTree a) | HBLeaf

instance BT HBTree where
    toTree HBLeaf = Leaf
    toTree (HBNode l x _ r) = Node l x r

hbheight :: HBTree a -> Int
hbheight (HBNode _ _ h _) = h
hbheight HBLeaf = 0

instance BST HBTree where
    leaf = HBLeaf
    node l x r = let (sl, sr) = (hbheight l, hbheight r)
                     p        = HBNode l x ((max sl sr) + 1) r
            in
                if sl + sr < 2 then p
                else if sr > δ + sl then        -- right subtree height too big
                    let HBNode rl _ _ rr = r 
                        (srl, srr)       = (hbheight rl, hbheight rr)
                    in if srl < srr then single_rot_l p else double_rot_l p
                else if sl > δ + sr then        -- left subtree height too big
                    let HBNode ll _ _ lr = l
                        (sll, slr)       = (hbheight ll, hbheight lr)
                    in if slr < sll then single_rot_r p else double_rot_r p
                else p
            where δ = 1

-- >>> foldl (flip insert) HBLeaf [0..10]
--    ┌10
--   ┌9 
--   │└8
--  ┌7  
--  ││┌6
--  │└5 
--  │ └4
-- ─3   
--  │   
--  │┌2 
--  ││  
--  └1  
--   │  
--   └0 
-- <BLANKLINE>
--

-- zad9

data Color = Red | Black
data RBTree a = RBNode (RBTree a) a Color (RBTree a) | RBLeaf

instance BT RBTree where
    toTree RBLeaf = Leaf
    toTree (RBNode l x _ r) = Node l x r

