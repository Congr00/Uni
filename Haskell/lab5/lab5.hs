{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE FlexibleContexts #-}

import Control.Monad
import Control.Applicative

-- zad1

class NFData a where
  rnf :: a -> ()

instance Num a => NFData a where
  rnf x = x `seq` ()

instance {-# OVERLAPS #-} NFData a => NFData [a] where
  rnf [] = ()
  rnf (x:xs) = rnf x `seq` (rnf xs `seq` ())

instance {-# OVERLAPS #-} (NFData a, NFData b) => NFData (a, b) where
  rnf (a, b) = rnf a `seq` rnf b `seq` ()

instance {-# OVERLAPS #-} (NFData a, NFData b, NFData c) => NFData (a, b, c) where
  rnf (a, b, c) = rnf a `seq` rnf b `seq` rnf c `seq` ()

deepseq :: (NFData a) => a -> b -> b
deepseq a b = rnf a `seq` b

($!!) :: (NFData a) => (a -> b) -> a -> b
f $!! x = x `deepseq` f x


-- zad 2

subseqM :: MonadPlus m => [a] -> m [a]
subseqM [] = return []
subseqM (x:xs) = do   yss <- subseqM xs
                      return yss `mplus` return (x:yss)

-- zad 6

data List t a = Cons a (t a) | Nil deriving Show

newtype SimpleList a = SimpleList { fromSimpleList :: List SimpleList a }

class ListView t where
    viewList :: t a -> List t a
    toList :: t a -> [a]
    toList x = case viewList x of
        Nil        -> []
        (Cons n t) -> n:toList t
    cons :: a -> t a -> t a
    nil :: t a

data CList a = CList a :++: CList a | CSingle a | CNil deriving Show

instance ListView CList where
    nil = CNil
    cons x (CNil)        = CSingle x
    cons x r@(CSingle _) = r :++: CSingle x 
    cons x (r :++: l)    = r :++: cons x l
    viewList (CNil)      = Nil
    viewList (CSingle x) = Cons x (CNil)
    viewList (l :++: r)  = case l of
                            CNil -> viewList r
                            _    -> Cons (head $ toList l) r

instance Functor CList where
    fmap _ CNil        = CNil
    fmap f (CSingle x) = CSingle $ f x
    fmap f (l :++: r)  = (fmap f l) :++: (fmap f r)

instance Applicative CList where
    pure = CSingle
    fl <*> ml = foldl (flip cons) CNil [f x | f <- (toList fl), x <- (toList ml)]

instance Monad CList where
    (>>=) CNil _        = CNil
    (>>=) (CSingle x) f = f x
    (>>=) (l :++: r) f  = (l >>= f) :++: (r >>= f)

instance Alternative CList where
    empty = CNil
    CNil <|> r = r
    l <|> CNil = l
    x1 <|> x2  = x1 :++: x2

instance MonadPlus CList

instance Foldable CList where
    foldr f z = foldr f z . toList

instance Traversable CList where
    traverse _ CNil        = pure CNil
    traverse f (CSingle x) = pure <$> f x
    traverse f (l :++: r)  = pure <$> traverse f l <*> traverse f r

-- zad 7

newtype DList a = DList { fromDList :: [a] -> [a] }

instance ListView DList where
    nil = DList (\x -> x)
    toList x   = fromDList x []
    cons e x = DList (fromDList x . (e:))
    viewList x = case toList x of
                    []    -> Nil
                    (h:t) -> Cons h (foldl (flip cons) nil t)

dappend :: DList a -> DList a -> DList a
dappend l r = DList (fromDList l . fromDList r)

instance Functor DList where
    fmap f = foldr (cons . f) nil

instance Applicative DList where
    pure x = DList (\e -> x:e)
    fl <*> ml = foldl (flip cons) nil [f x | f <- (toList fl), x <- (toList ml)]

instance Monad DList where
    x >>= f = foldl dappend nil $ toList $ fmap f x

instance Alternative DList where
    empty = nil
    (<|>) = dappend

instance MonadPlus DList

instance Foldable DList where
    foldr f z = foldr f z . toList

instance Traversable DList where
    sequenceA x = foldr (\u v -> cons <$> u <*> v) (pure nil) (toList x)