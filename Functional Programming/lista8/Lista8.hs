import Data.List(sort)
import Data.List(dropWhile)
{- Łukasz Klasiński -}

{- zad1 -}
lrepeat :: (Integer -> Integer) -> [a] -> [a]
lrepeat _ [] = []
lrepeat f (hd:tl) = rep_num hd (f 0) tl 1
    where
    rep_num:: a -> Integer -> [a] -> Integer -> [a]
    rep_num el k tl i =
      case k of
        0 -> case tl of
              []  -> []
              h:t -> rep_num h (f i) t (i+1)
        k -> el:rep_num el (k-1) tl i

{- zad2 -}
sublist :: [Integer] -> [a] -> [a]
sublist ind list = sublist_aux (sort ind) list 0
    where
    sublist_aux :: [Integer] -> [a] -> Integer -> [a]
    sublist_aux _ [] _ = []
    sublist_aux [] list _ = list
    sublist_aux ind (hd:tl) index = if index == head ind then sublist_aux (tail ind) tl (index+1)
                                    else hd:sublist_aux ind tl (index+1)

{- zad3a -}
root3 :: Double -> Double
root3 a = f (if a > 1 then a/3 else a)
  where
    f :: Double -> Double
    f xi = if abs (xi ** 3.0 - a) <= 10e-15 * abs a then xi
           else f (xi + (a / (xi ** 2.0) - xi) / 3) 

{- zad3b -}
root3l :: Double -> Double
root3l a = head (dropWhile (\x -> abs (x** 3.0 - a) > 10e-15 * abs a) (iterate (\x -> x + (a / (x ** 2.0) - x) / 3) (if a > 1 then a/3 else a)))

z1r1 = take 15 (lrepeat  (+1) [1,2,3,4,5])
-- [1,2,2,3,3,3,4,4,4,4,5,5,5,5,5]

z2r1 = take 15 (sublist [1,4,7,2] [10..])
-- [10,13,15,16,18,19,20,21,22,23,24,25,26,27,28]

z3r1 = root3 122
-- 4.959675663842301

z3r2 = root3l 122.0
-- 4.959675663842301

