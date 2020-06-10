--Łukasz Klasiński
--Haskell Course
--List 11
--31-05-2020

{-# LANGUAGE ScopedTypeVariables, GADTs, DeriveFunctor, FlexibleInstances, RankNTypes, QuantifiedConstraints, PolyKinds #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE KindSignatures #-}

import Control.Monad (ap, MonadPlus, mzero, mplus)
import Control.Applicative (Alternative, empty, (<|>))

data Yoneda f a = Yoneda (forall x. (a -> x) -> f x)

-- ex1
instance Functor (Yoneda f) where
    fmap g (Yoneda f) = Yoneda (\x -> f (x . g))

toYoneda :: (Functor f) => f a -> Yoneda f a
toYoneda x = Yoneda $ flip fmap x

fromYoneda :: Yoneda f a -> f a
fromYoneda (Yoneda f) = f id

-- ex2

newtype DList a = DList { fromDList :: [a] -> [a] }

instance Semigroup (DList a) where
    DList f <> DList g = DList $ f . g

repDList :: DList a -> Yoneda DList a
repDList (DList l) = Yoneda (\a -> DList $ \k -> map a (l []) ++ k)

repList :: [a] -> Yoneda DList a
repList xs = repDList $ DList (xs++)

--instance Semigroup (Yoneda DList a) where
--    (Yoneda h) <> (Yoneda j) = Yoneda (\x -> (h <> j) x)

-- ex3
instance (forall a . Semigroup (f a)) => Semigroup (Yoneda f a) where
    (Yoneda h) <> (Yoneda j) = Yoneda (\x -> (h <> j) x)

-- ex4

newtype Cod f a = Cod { runCod :: forall x. (a -> f x) -> f x }

instance Functor (Cod f) where
  fmap f (Cod m) = Cod $ \k -> m (\x -> k (f x))

instance Applicative (Cod f) where
  pure  = return
  (<*>) = ap

instance Monad (Cod f) where
  return x = Cod $ \k -> k x
  m >>= k  = Cod $ \c -> runCod m (\a -> runCod (k a) c)

fromCod :: (Monad m) => Cod m a -> m a
fromCod (Cod f) = f pure

toCod :: (Monad m) => m a -> Cod m a
toCod m = Cod $ (>>=) m

instance (Alternative v) => Alternative (Cod v) where
  empty = Cod (const empty)
  (<|>) (Cod f) (Cod g) = Cod $ \x -> g x <|> f x

instance MonadPlus m => MonadPlus (Cod m) where
  mzero = Cod (const mzero)
  mplus (Cod f) (Cod g) = Cod $ \x -> g x `mplus` f x

-- ex5

class Category (t :: k -> k -> *) where
    ident :: a `t` a
    comp :: b `t` c -> a `t` b -> a `t` c

instance Category (->) where
  ident = id
  comp  = (.)

-- example of a categroy: Kleisli

newtype Kleisli m a b = Kleisli { runKleisli :: a -> m b }

instance (Monad m) => Category (Kleisli m) where
  ident = Kleisli pure
  comp (Kleisli f) (Kleisli g) = Kleisli (\k -> g k >>= f)


-- ex 6 kek

-- monoidal categories

class (Category t) => MonoidalCategory
  (t :: k -> k -> *) (tens :: k -> k -> k) (unit :: k) | t -> tens, t -> unit where
    bimap :: a `t` a' -> b `t` b' -> tens a b `t` tens a' b'

class (MonoidalCategory t tens unit) =>
    MonoidInCategory (t :: k -> k -> *) tens unit (m :: k) where
  one  :: unit `t` m
  mult :: tens m m `t` m

-- example of monoid in a monoidal category

newtype NatTrans f g = NatTrans { runNatTrans :: forall a. f a -> g a }

instance Category NatTrans where
  ident = NatTrans id
  NatTrans f `comp` NatTrans g = NatTrans $ f . g

newtype Identity a = Identity { runIdentity :: a }
  deriving (Functor)

newtype Comp f g x = Comp { runComp :: f (g x) }
  deriving (Functor)

instance MonoidalCategory NatTrans Comp Identity where
  bimap = undefined

instance MonoidInCategory NatTrans Comp Identity [] where
  one  = undefined
  mult = undefined

-- monads form monoids

newtype MonadFromMonoid m a = MonadFromMonoid (m a)
 deriving (Functor)

instance (Functor f, MonoidInCategory NatTrans Comp Identity f)
 => Applicative (MonadFromMonoid f) where
  pure  = return
  (<*>) = ap
  
instance (Functor f, MonoidInCategory NatTrans Comp Identity f)
 => Monad (MonadFromMonoid f) where
  return = undefined
  (>>=)  = undefined

-- monoids from monads

newtype MonoidFromMonad m a = MonoidFromMonad (m a)
 deriving (Functor)

instance (Monad m) => MonoidInCategory NatTrans Comp Identity m where
  one  = undefined
  mult = undefined
