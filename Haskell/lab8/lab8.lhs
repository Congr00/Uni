Łukasz Klasiński
Haskell Course
List 08
09-05-2020

> {-# LANGUAGE PolyKinds, TypeOperators, StandaloneDeriving, TypeFamilies, TypeOperators, DataKinds, GADTs, InstanceSigs, FlexibleInstances, UndecidableInstances, IncoherentInstances, AllowAmbiguousTypes #-}

> import GHC.TypeLits (TypeError, ErrorMessage(Text))
> import Control.Applicative

ex1

> data Nat = Zero | Succ Nat deriving Show
> type One = 'Succ 'Zero

> data BTree :: Nat -> * -> * where
>     BLeaf  :: BTree 'Zero a
>     BNode  :: BTree h a -> a -> BTree h a -> BTree ('Succ h) a

ex2

> data SNat :: Nat -> * where
>   SZero :: SNat 'Zero
>   SSucc :: SNat n -> SNat ('Succ n)

> data Vector :: Nat -> * -> * where
>   VNil  :: Vector 'Zero a
>   VCons :: a -> Vector s a -> Vector ('Succ s) a
> data Matrix :: Nat -> Nat -> * -> * where
>   MNil  :: Matrix h 'Zero a
>   MCons :: Vector h a -> Matrix h w a -> Matrix h ('Succ w) a

> deriving instance Show a => Show (Vector h a)
> deriving instance Show a => Show (Matrix h w a)

> class NatSize n where
>   natSize :: SNat n
> instance NatSize 'Zero where
>   natSize = SZero
> instance NatSize n => NatSize ('Succ n) where
>   natSize = SSucc natSize
> instance NatSize n where
>   natSize = natSize
> instance Functor (Vector h) where
>   fmap _ VNil = VNil
>   fmap f (VCons a b) = VCons (f a) (fmap f b)
> instance Functor (Matrix h w) where
>   fmap _ MNil = MNil
>   fmap f (MCons a b) = MCons (fmap f a) (fmap f b)
> instance Foldable (Vector h) where
>   foldr _ acc VNil = acc
>   foldr f acc (VCons a b) = foldr f (a `f` acc) b
> instance Foldable (Matrix h w) where
>   foldr _ acc MNil = acc
>   foldr f acc (MCons a b) = foldr f (foldr f acc a) b

> instance (NatSize h) => Applicative (Vector h) where
>   pure e = pureV e natSize
>     where
>       pureV :: a -> SNat h -> Vector h a
>       pureV _ SZero = VNil
>       pureV a (SSucc n) = VCons a (pureV a n)

>   (<*>) VNil VNil = VNil
>   (<*>) (VCons f fs) (VCons x xs) = VCons (f x) (fs <*> xs)

> instance (NatSize h, NatSize w) => Applicative (Matrix h w) where
>   pure e = pureM (pure e) width
>     where
>       width :: NatSize w => SNat w
>       width = natSize
>       pureM :: Vector h a -> SNat w -> Matrix h w a
>       pureM _ SZero = MNil
>       pureM v (SSucc n) = MCons v (pureM v n)

>   (<*>) MNil MNil = MNil
>   (<*>) (MCons f fs) (MCons x xs) = MCons (f <*> x) (fs <*> xs)

dodawanie vektora
> vecAdd :: Num a => Vector n a -> Vector n a -> Vector n a
> vecAdd VNil VNil = VNil
> vecAdd (VCons x1 n1) (VCons x2 n2) = VCons (x1+x2) $ vecAdd n1 n2

dodawanie macierzy
> matAdd :: Num a => Matrix h v a -> Matrix h v a -> Matrix h v a
> matAdd (MCons v1 n1) (MCons v2 n2) = MCons (vecAdd v1 v2) $ matAdd n1 n2
> matAdd MNil MNil = MNil

> vecMul :: (Foldable t, Num a, Applicative t) => t a -> t a -> a
> vecMul v1 v2 = sum $ liftA2 (*) v1 v2

> unstack :: Matrix ('Succ h) w a -> (Vector w a, Matrix h w a)
> unstack MNil = (VNil, MNil)
> unstack (MCons (VCons hd tl) b) = (VCons hd fs, MCons tl sn)
>   where (fs, sn) = unstack b

> restack :: Vector w a -> Matrix h w a -> Matrix ('Succ h) w a
> restack VNil MNil = MNil
> restack (VCons v vs) (MCons m ms) = MCons (VCons v m) (restack vs ms)

> vmap :: (Vector h a -> a) -> Matrix h w a -> Vector w a
> vmap _ MNil = VNil
> vmap f (MCons a b) = VCons (f a) (vmap f b)

> transpose :: Vector h a -> Matrix One h a
> transpose VNil = MNil
> transpose (VCons e vs) = MCons (VCons e VNil) (transpose vs)

mnożenie macierzy
> matMul :: Num a => Matrix h n a -> Matrix n w a -> Matrix h w a
> matMul a@(MCons (VCons _ VNil) _) b = transpose row
>   where
>     (v, _) = unstack a
>     row = vmap (vecMul v) b
> matMul a@(MCons (VCons _ _) _) b = restack row rest
>   where
>     (v, vs) = unstack a
>     row = vmap (vecMul v) b
>     rest = matMul vs b
> matMul _ _ = undefined


ex3
> data XFields = XA | XB | XC | XD | XE | XF | XG | XH
> data YFields = Y1 | Y2 | Y3 | Y4 | Y5 | Y6 | Y7 | Y8
> data GNat a = GZero | GSucc a (GNat a)

> type family Not x where
>     Not 'True = 'False
>     Not 'False = 'True
> type family (:||:) x y where
>     'True :||: _ = 'True
>     _ :||: 'True = 'True
>     _ :||: _     = 'False
> type family (:&&:) x y where
>     'True :&&: 'True = 'True
>     _ :&&: _         = 'False
> type family IsLessX (x1 :: XFields) (x2 :: XFields) where
>     IsLessX 'XA 'XB = 'True
>     IsLessX 'XB 'XC = 'True
>     IsLessX 'XC 'XD = 'True
>     IsLessX 'XD 'XE = 'True
>     IsLessX 'XE 'XF = 'True
>     IsLessX 'XF 'XG = 'True
>     IsLessX 'XG 'XH = 'True
>     IsLessX 'XH 'XG = 'False
>     IsLessX 'XG 'XF = 'False
>     IsLessX 'XF 'XE = 'False
>     IsLessX 'XE 'XD = 'False
>     IsLessX 'XD 'XC = 'False
>     IsLessX 'XC 'XB = 'False
>     IsLessX 'XB 'XA = 'False
>     IsLessX a 'XA = 'False
>     IsLessX a 'XB = IsLessX a 'XA
>     IsLessX a 'XC = IsLessX a 'XB
>     IsLessX a 'XD = IsLessX a 'XC
>     IsLessX a 'XE = IsLessX a 'XD
>     IsLessX a 'XF = IsLessX a 'XE
>     IsLessX a 'XG = IsLessX a 'XF
>     IsLessX a 'XH = IsLessX a 'XG
> type family IsLessY (y1 :: YFields) (y2 :: YFields) where
>     IsLessY 'Y1 'Y2 = 'True
>     IsLessY 'Y2 'Y3 = 'True
>     IsLessY 'Y3 'Y4 = 'True
>     IsLessY 'Y4 'Y5 = 'True
>     IsLessY 'Y5 'Y6 = 'True
>     IsLessY 'Y6 'Y7 = 'True
>     IsLessY 'Y7 'Y8 = 'True
>     IsLessY 'Y8 'Y7 = 'False
>     IsLessY 'Y7 'Y6 = 'False
>     IsLessY 'Y6 'Y5 = 'False
>     IsLessY 'Y5 'Y4 = 'False
>     IsLessY 'Y4 'Y3 = 'False
>     IsLessY 'Y3 'Y2 = 'False
>     IsLessY 'Y1 'Y1 = 'False
>     IsLessY a 'Y1 = 'False
>     IsLessY a 'Y2 = IsLessY a 'Y1
>     IsLessY a 'Y3 = IsLessY a 'Y2
>     IsLessY a 'Y4 = IsLessY a 'Y3
>     IsLessY a 'Y5 = IsLessY a 'Y4
>     IsLessY a 'Y6 = IsLessY a 'Y5
>     IsLessY a 'Y7 = IsLessY a 'Y6
>     IsLessY a 'Y8 = IsLessY a 'Y7
> type family AxisMove (move :: (XFields, YFields)) (hist :: (GNat (XFields, YFields))) where
>     AxisMove _ 'GZero = 'GZero                        -- first white move
>     AxisMove _ ('GSucc p 'GZero) = 'GSucc p 'GZero    -- first black move
>     AxisMove '(x, y) ('GSucc _ ('GSucc '(x, y) _)) = TypeError ('Text "Cannot move in place")
>     AxisMove '(x, y1) ('GSucc p ('GSucc '(x, y2) t)) = 'GSucc p ('GSucc '(x, y2) t)
>     AxisMove '(x1, y) ('GSucc p ('GSucc '(x2, y) t)) = 'GSucc p ('GSucc '(x2, y) t)
>     AxisMove _ _ = TypeError ('Text "Can move only in one axis!")
> type family FinisherMove (hist :: (GNat (XFields, YFields))) where
>     FinisherMove 'GZero = 'False
>     FinisherMove ('GSucc '(x, y) ('GSucc '(x, y) 'GZero)) = 'True
>     FinisherMove ('GSucc '(x, y) ('GSucc '(x, y) _)) = TypeError ('Text "Game already finished!")
>     FinisherMove ('GSucc _ t) = FinisherMove t
> type family Overlapping f (move :: (XFields, YFields)) (hist :: (GNat (XFields, YFields))) where
>     Overlapping 'True _ _ = 'True -- finish move so its ok
>     Overlapping _ '(x, y1) ('GSucc '(x, y2) ('GSucc '(x, y3) _)) = (IsLessY y1 y2) :&&: (IsLessY y3 y2) :||: (Not (IsLessY y1 y2)) :&&: (Not (IsLessY y3 y2))
>     Overlapping _ '(x1, y) ('GSucc '(x2, y) ('GSucc '(x3, y) _)) = (IsLessX x1 x2) :&&: (IsLessX x3 x2) :||: (Not (IsLessX x1 x2)) :&&: (Not (IsLessX x3 x2))
>     Overlapping _ _ _ = 'True

nie mam pojecia jak inaczej to zapisac, walczyłem z tym (za)długo i w końcu się poddałem

> data SMove (move :: (XFields, YFields)) where
>     XAY1 :: SMove '(XA, Y1)
>     XAY2 :: SMove '(XA, Y2)
>     XAY3 :: SMove '(XA, Y3)
>     XAY4 :: SMove '(XA, Y4)
>     XAY5 :: SMove '(XA, Y5)
>     XAY6 :: SMove '(XA, Y6)
>     XAY7 :: SMove '(XA, Y7)
>     XAY8 :: SMove '(XA, Y8)
>     XBY1 :: SMove '(XB, Y1)
>     XBY2 :: SMove '(XB, Y2)
>     XBY3 :: SMove '(XB, Y3)
>     XBY4 :: SMove '(XB, Y4)
>     XBY5 :: SMove '(XB, Y5)
>     XBY6 :: SMove '(XB, Y6)
>     XBY7 :: SMove '(XB, Y7)
>     XBY8 :: SMove '(XB, Y8)
>     XCY1 :: SMove '(XC, Y1)
>     XCY2 :: SMove '(XC, Y2)
>     XCY3 :: SMove '(XC, Y3)
>     XCY4 :: SMove '(XC, Y4)
>     XCY5 :: SMove '(XC, Y5)
>     XCY6 :: SMove '(XC, Y6)
>     XCY7 :: SMove '(XC, Y7)
>     XCY8 :: SMove '(XC, Y8)
>     XDY1 :: SMove '(XD, Y1)
>     XDY2 :: SMove '(XD, Y2)
>     XDY3 :: SMove '(XD, Y3)
>     XDY4 :: SMove '(XD, Y4)
>     XDY5 :: SMove '(XD, Y5)
>     XDY6 :: SMove '(XD, Y6)
>     XDY7 :: SMove '(XD, Y7)
>     XDY8 :: SMove '(XD, Y8)
>     XEY1 :: SMove '(XE, Y1)
>     XEY2 :: SMove '(XE, Y2)
>     XEY3 :: SMove '(XE, Y3)
>     XEY4 :: SMove '(XE, Y4)
>     XEY5 :: SMove '(XE, Y5)
>     XEY6 :: SMove '(XE, Y6)
>     XEY7 :: SMove '(XE, Y7)
>     XEY8 :: SMove '(XE, Y8)
>     XFY1 :: SMove '(XF, Y1)
>     XFY2 :: SMove '(XF, Y2)
>     XFY3 :: SMove '(XF, Y3)
>     XFY4 :: SMove '(XF, Y4)
>     XFY5 :: SMove '(XF, Y5)
>     XFY6 :: SMove '(XF, Y6)
>     XFY7 :: SMove '(XF, Y7)
>     XFY8 :: SMove '(XF, Y8)
>     XGY1 :: SMove '(XG, Y1)
>     XGY2 :: SMove '(XG, Y2)
>     XGY3 :: SMove '(XG, Y3)
>     XGY4 :: SMove '(XG, Y4)
>     XGY5 :: SMove '(XG, Y5)
>     XGY6 :: SMove '(XG, Y6)
>     XGY7 :: SMove '(XG, Y7)
>     XGY8 :: SMove '(XG, Y8)
>     XHY1 :: SMove '(XH, Y1)
>     XHY2 :: SMove '(XH, Y2)
>     XHY3 :: SMove '(XH, Y3)
>     XHY4 :: SMove '(XH, Y4)
>     XHY5 :: SMove '(XH, Y5)
>     XHY6 :: SMove '(XH, Y6)
>     XHY7 :: SMove '(XH, Y7)
>     XHY8 :: SMove '(XH, Y8)

> data Game :: GNat (XFields, YFields)  -> * where
>     End   :: Game 'GZero
>     Move  :: (AxisMove p hist ~ merge, FinisherMove hist ~ f, Overlapping f p hist ~ 'True)
>           => SMove p -> Game hist -> Game ('GSucc p merge)

zapisanie parti z zadania :
Move (XAY1) $ Move (XHY8) $ Move (XAY8) $ Move (XCY8) $ Move (XCY8) End

ex4
> type family BHeapHeight l r where
>     BHeapHeight n n = 'True
>     BHeapHeight ('Succ n) n = 'False
>     BHeapHeight _ _ = TypeError ('Text "BHeap tree invariant not satisfied!")

> type family BHeapDirty b l r where
>     BHeapDirty 'False 'True 'True = TypeError ('Text "Both subtrees have a skip")
>     BHeapDirty 'True 'True _ = TypeError ('Text "Left subtree has an illegal skip")
>     BHeapDirty _ 'True 'False = 'True
>     BHeapDirty _ 'False 'True = 'True
>     BHeapDirty _ _ _ = 'False

> data BHeap :: Nat -> Bool -> * -> * where
>     HLeaf  :: a -> BHeap 'Zero 'True a
>     HUNode :: BHeap h 'True a -> a -> BHeap ('Succ h) 'False a
>     HBNode ::  (BHeapHeight h1 h2 ~ b, BHeapDirty b b1 b2 ~ 'True) 
>            => BHeap h1 b1 a -> a -> BHeap h2 b2 a -> BHeap ('Succ h1) b2 a

> data BinaryHeap a = forall n m. BinaryHeap (BHeap n m a)

> deriving instance Show a => Show (BHeap h b a)
> deriving instance Show a => Show (BinaryHeap a)


> bhfindMin :: BinaryHeap a -> a
> bhfindMin (BinaryHeap h) = case h of
>           (HLeaf x)      -> x
>           (HUNode _ x)   -> x
>           (HBNode _ x _) -> x

inst, del nie mam pojęcia jak zapisać
