-- Łukasz Klasiński
-- Lab 1
import Data.List (zipWith)
import Control.Arrow
import Data.Char (isDigit, digitToInt)
-- zad 1
intercalate :: [a] -> [[a]] -> [a]
intercalate _ [] = []
intercalate _ [x] = x
intercalate xs (h:t) = h ++ xs ++ (intercalate xs t)
-- >>> intercalate ", " ["Lorem", "ipsum", "dolor"]
-- "Lorem, ipsum, dolor"
--
transpose :: [[a]] -> [[a]]
transpose [] = []
transpose m = map head m : transpose (filter (not . null) (map tail m))
-- >>> transpose [[1], [4,5,6], [7,8,9]]
-- [[1,4,7],[5,8],[6,9]]
--
concat' :: [[a]] -> [a]
concat' [] = []
concat' ((h:t):t2) = h:concat'(t:t2)
concat' ([]:t) = concat' t
-- >>> concat' [[0,1],[],[2],[3],[4,5,6],[]]
-- [0,1,2,3,4,5,6]
--
and' :: [Bool] -> Bool
and' [] = True
and' (h:t) = h && and' t
-- >>> and' [False, True, True]
-- False
--
all':: (a -> Bool) -> [a] -> Bool
all' _ [] = True
all' p (h:t) = p h && all' p t
-- >>> all' (\x -> x < 2) [2,1,1,1,1,1]
-- False
--
maximum' :: [Integer] -> Integer
maximum' [] = error "Empty list"
maximum' (h:t) = maximum'' t h
    where
        maximum'' :: [Integer] -> Integer -> Integer
        maximum'' [] m = m
        maximum'' (xs:ys) m = if xs > m then maximum'' ys h
                              else maximum'' ys m
-- >>> maximum [11231231,2,3,4,5,6,123123,-1]
-- 11231231
-- >>> maximum []
-- *** Exception: Prelude.maximum: empty list
--
-- zad 2
newtype Vector a = Vector { fromVector :: [a] }
scaleV :: Num a => a -> Vector a -> Vector a
scaleV s (Vector a) = Vector $ map (*s) a
-- >>> fromVector $ scaleV 10 (Vector [1,2,3,4,5])
-- [10,20,30,40,50]
--
norm :: Floating a => Vector a -> a
norm (Vector a) = sqrt $ sum $ map (**2) a
-- >>> norm (Vector [1.0,2.0])
-- 2.23606797749979
--
scalarProd :: Num a => Vector a -> Vector a -> a
scalarProd (Vector a) (Vector b) = if length a /= length b then error "Vectors of diff length"
                                   else sum $ map product (transpose [a, b])
-- >>> scalarProd (Vector [1,2]) (Vector [3,4])
-- 11
--
sumV :: Num a => Vector a -> Vector a -> Vector a
sumV (Vector a) (Vector b) = if length a /= length b then error "Vectors of diff length"
                             else Vector $ map sum (transpose [a, b])
-- >>> fromVector $ sumV (Vector [1,2]) (Vector [3,4])
-- [4,6]
--
newtype Matrix a = Matrix { fromMatrix :: [[a]] }
getDim :: Matrix a -> (Int, Int)
getDim (Matrix a) = let l = map length a in
                        if all ( == head l) (tail l) then (length a, head l)
                        else error "dims in matrix not equal"
dimEq :: (Matrix a) -> (Matrix a) -> Bool
dimEq m1 m2 = let (xa, ya) = getDim m1
                  (xb, yb) = getDim m2
              in xa == xb && ya == yb
dimMul :: (Matrix a) -> (Matrix a) -> Bool
dimMul m1 m2 = let (_, ya) = getDim m1
                   (xb, _) = getDim m2
               in ya == xb
sumM :: Num a => Matrix a -> Matrix a -> Matrix a
sumM m1 m2 = if not $ dimEq m1 m2 then error "Wrong matrix dims"
             else Matrix $ zipWith (zipWith (+)) (fromMatrix m1) (fromMatrix m2)
-- >>> fromMatrix $ sumM (Matrix [[1,2,3], [1,2,3], [1,2,6]]) (Matrix [[1,1,1],[2,1,1],[1,1,1]])
-- [[2,3,4],[3,3,4],[2,3,7]]
--
prodM :: Num a => Matrix a -> Matrix a -> Matrix a
prodM m1 m2 = if not $ dimMul m1 m2 then error "Wrong matrix dims"
              else let a = fromMatrix m1
                       b = fromMatrix m2
                   in Matrix $ map ((map sum) . transpose . map (\x -> map (* (fst x)) (snd x))) $ zipWith zip a (repeat b)
-- >>> fromMatrix $ prodM (Matrix [[1,0,2], [-1,3,1],[1,2,3]]) (Matrix [[3,1], [2,1], [1,0]])
-- [[5,1],[4,2],[10,3]]
--

instance Show a => Show (Matrix a) where
    show = show . fromMatrix

without :: Int -> [a] -> [a]
without n (x:xs)
    | n == 0 = xs
    | otherwise = x : without (n-1) xs
-- >>> without 0 [1,2,3]
-- [2,3]
--
det :: Show a => Num a => Matrix a -> a
det m1
    | (length . fromMatrix $ m1) == 1 = head . head . fromMatrix $ m1
    | not $ uncurry (==) $ getDim m1 = error ("Matrix is not a Square!")
    | otherwise = sum $ map (uncurry (*) . (det . fst &&& snd)) $ zip minors $ map (uncurry (*)) $ zip x (cycle [1, -1])
        where minors = map Matrix $ transpose $ map (map (uncurry without) . zip [0..(length x) - 1] . repeat) xs
              x = head . fromMatrix $ m1
              xs = tail . fromMatrix $ m1
-- >>> det (Matrix [[1, 3, 0, 0, 8], [9, 6, 4, 3, 2], [9, 1, 0, 7, 7],[9, 1, 3, 0, 5],[8, 4, 4, 1, 1]])
-- -342
--
-- zad 5
isbn13_check :: String -> Bool
isbn13_check word = let num = words word in if length num /= 2 then error "Wrong isbn13 number" (1)
                    else let num' = filter (/= '-') $ head . tail $ num
                    in if length num' /= 13 then error "Wrong isbn13 number (2)"
                       else if all (not . id) $ map isDigit num' then error "Wrong isbn13 number (3)"
                            else sum (zipWith (*) (map digitToInt num') (cycle [1,3])) `mod` 10 == 0
-- >>> isbn13_check "ISBN 978-0-306-40615-7"
-- True
--
-- >>> isbn13_check "ISBN 978-83-246-8500-4"
-- True
--
-- zad5
newtype Natural = Natural { fromNatural :: [Word] }
base :: Word
base = 1 + (floor . sqrt . fromInteger . toInteger $ (maxBound :: Word))
-- >>> base
-- 4294967296
--
-- zad6
remainder_shift :: Natural -> Natural
remainder_shift (Natural n) = Natural $ normalize $ reverse $ shift (reverse n) 0
    where
        shift :: [Word] -> Word -> [Word]
        shift [] 0 = []
        shift [] rem = [rem]
        shift (h:t) rem = if nv >= base then (nv-rest*base):shift t rest
                          else nv:shift t 0
            where
                nv = h + rem
                rest = nv `div` base

normalize :: [Word] -> [Word]
normalize [n] = [n]
normalize (0:t) = normalize t
normalize n = n

denormalize :: [Word] -> Int -> [Word]
denormalize x n = if xlength > n then x else denormalize' x (n-xlength)
    where
        xlength = length x
        denormalize' [] 0 = []
        denormalize' (h:t) 0 = h:denormalize' t 0
        denormalize' y n = 0:denormalize' y (n-1)
-- >>> remainder_shift (Natural [0,0,9*base+1])
-- 9#1
--
-- >>> denormalize (fromNatural (Natural [1])) 2
-- [0,1]
--
substract :: [Word] -> [Word] -> [Word]
substract n1 n2 = reverse $ substract' (reverse n1) (reverse n2) 0
    where
        substract' [] [] _ = []
        substract' (h:t) [] rem = (h-rem):substract' t [] 0
        substract' (h1:t1) (h2:t2) rem = (nv-rem):substract' t1 t2 nrem
            where
                nv = if h1 >= h2 then h1 - h2 else h1+base-h2
                nrem = if h1 < h2 then 1 else 0
instance Num Natural where
    Natural x1 + Natural x2 = remainder_shift $ Natural $ zipWith (+) (denormalize x1 mx) (denormalize x2 mx)
        where
            mx = max (length x1) (length x2)
    x1 - x2 = if x1 < x2 then error "cannot go under 0 in Natural numbers"
              else remainder_shift $ Natural $ substract (fromNatural x1) (fromNatural x2)
    Natural x1 * Natural x2 = foldl (\acc (x,y) -> (remainder_shift . Natural $ map (*y) (x2 ++ replicate x 0)) + acc) (Natural [0]) (zip [0..] $ reverse x1)
    abs = id
    signum (Natural x) = if head (normalize x) /= 0 then 1 else 0
    fromInteger x = Natural $ map fromInteger $ find x
                        where
                            find :: Integer -> [Integer]
                            find i = if i < ibase then [i]
                                     else (i `div` ibase):find (i `mod` ibase) 
                            ibase = toInteger base
-- >>>(Natural [base-1]) * (Natural [base-1])
-- 4294967294#1
--
-- >>> Natural [1,1,1] - Natural [2]
-- 1#0#4294967295
--
-- >>> Natural [1,1,1] < Natural [2]
-- False
--
-- >>> Natural [base-1,base-1,base-1] * Natural [base-1, base-1,base-1] + Natural [base-1, base-1,base-1]
-- 4294967295|4294967295|4294967295|0|0|0
--
-- >>> fromInteger (toInt (Natural [100,1]))
-- 429496729601
--
--zad 7
instance Eq Natural where
    x1 == x2 = all id $ zipWith (==) (fromNatural x1) (fromNatural x2)
instance Ord Natural where
    (Natural x1) `compare` (Natural x2) = (denormalize x1 mx) `compare` (denormalize x2 mx)
            where
            mx = max (length x1) (length x2)
-- zad9
instance Show Natural where
    show (Natural n) = tail $ concatMap ( ('|':) . show) n

toInt (Natural n) = foldl (\acc (pow, x) -> acc + x * ((toInteger base) ^ pow)) 0 $ zip [0..] $ reverse (map toInteger n)