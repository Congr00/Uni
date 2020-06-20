--Łukasz Klasiński
--Haskell Course
--List 11
--19-06-2020

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

module Lib where

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

-- Wydaje się wolne (bo ++), ale dzięki temu, że ++ jest prawostronnie łączny to map powinien działać w czasie liniowym

repList :: [a] -> Yoneda DList a
repList xs = repDList $ DList (xs++)

-- zakomentowane, bo w 3 jest lepsza
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

-- konkatenacja działa liniowo - uruchomiłem poniższy kod dla 10000000 liczyło się 5s, po zwiększeniu ilości o 5 wyszło 30s
-- więc mamy O(n).

--main :: IO ()
--main = do
--       putStrLn $ fromCod $ (foldl (<|>) (toCod "") (take 10000000 (cycle [toCod "aaaaaaaaaaaaaaaaa"])))
--       return ()

-- ex5

class Category (t :: k -> k -> *) where
    ident :: a `t` a
    comp :: b `t` c -> a `t` b -> a `t` c

instance Category (->) where
  ident = id
  comp  = (.)

newtype Kleisli m a b = Kleisli { runKleisli :: a -> m b }

instance (Monad m) => Category (Kleisli m) where
  ident = Kleisli pure
  comp (Kleisli f) (Kleisli g) = Kleisli (\k -> g k >>= f)