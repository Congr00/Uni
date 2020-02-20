import Data.Monoid

{- Łukasz Klasiński -}

data MtreeL a = MTL a [MtreeL a]
                deriving (Eq, Ord, Show, Read)

mt1 = MTL 1 [MTL 2 [], MTL 3 [], MTL 4 []]
mt2 = MTL 5 [MTL 6 [], MTL 7 [MTL 11 [MTL 12 [], MTL 13 [], MTL 14 []]], MTL 8 []]
mt3 = MTL 10 [mt1, mt2]

{- zad1a -}
foldMtl :: Monoid a => MtreeL a -> a
foldMtl (MTL a []) = a
foldMtl (MTL a (h:tl)) = foldMtl h <> foldMtl (MTL a tl)

-- >>> foldMtl $ MTL (Sum 1) [MTL (Sum 2)[], MTL (Sum 3)[], MTL (Sum 4)[]]
-- Sum {getSum = 10}
--

-- >>> foldMtl $ MTL (Sum 1) [MTL (Sum 2)[], MTL (Sum 3)[], MTL (Sum 4)[MTL (Sum 10) [MTL (Sum 5) []]]]
-- Sum {getSum = 25}

{- zad1b -}
foldMtLMap :: Monoid a => (t -> a) -> MtreeL t -> a
foldMtLMap toMonoid (MTL a []) = toMonoid a
foldMtLMap toMonoid (MTL a (h:tl)) = foldMtLMap toMonoid h <> foldMtLMap toMonoid (MTL a tl)

-- >>> getSum $ foldMtLMap Sum mt1
-- 10
--

-- >>> getProduct $ foldMtLMap Product mt2
-- 40360320
--
-- >>> getSum $ foldMtLMap Sum mt3
-- 96

{- zad2 -}
instance Functor MtreeL where
  fmap f (MTL a []) = MTL (f a) []
  fmap f (MTL a (h:t)) = MTL (f a) (map (fmap f) (h:t))

-- >>> ((+1) <$> mt1)
-- MTL 2 [MTL 3 [],MTL 4 [],MTL 5 []]
--
-- >>> ((*2) <$> mt2)
-- MTL 10 [MTL 12 [],MTL 14 [MTL 22 [MTL 24 [],MTL 26 [],MTL 28 []]],MTL 16 []]
--

instance Foldable MtreeL where
  foldMap toMonoid (MTL a []) = toMonoid a
  foldMap toMonoid (MTL a (h:t)) = foldMap toMonoid h <> foldMap toMonoid (MTL a t)

-- >>> sum mt1
-- 10
--

-- >>> product mt2
-- 40360320
--

-- >>> length mt2
-- 8
--

-- >>> maximum mt2
-- 14
