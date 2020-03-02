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
    | otherwise = sum $ map (uncurry (*) . (det . fst &&& snd)) $ zip minors $ map (uncurry (*)) $ zip x (cycle [1, -1])
        where minors = map Matrix $ transpose $ map (map (uncurry without) . zip [0..(length x) - 1] . repeat) xs
              a = fromMatrix m1
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
instance Num Natural where
    Natural x1 + Natural x2 = x1
    x1 * x2 = x1
    abs = id
    signum (Natural x) = if head x /= 0 then 1 else 0
    fromInteger x = Natural [fromInteger x] -- zoabczyc czy wieksze od base
    negate = id
-- >>> (Natural [1]) + (Natural [base])
-- 4294967297
--
-- zad7
instance Eq Natural where
    x1 == x2 = all id $ zipWith (==) (fromNatural x1) (fromNatural x2)
instance Ord Natural where
    (Natural x1) `compare` (Natural x2) = x1 `compare` x2 
-- >>> (Natural [2,1,4]) > Natural [2,1,4]
-- False
--
-- zad8
instance Integral Natural where
-- zad9
instance Show Natural where
    show n = concatMap (show) (fromNatural n)

