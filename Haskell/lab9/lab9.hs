--Łukasz Klasiński
--Haskell Course
--List 09
--09-05-2020

import Data.Array
import Data.Array.ST
import Data.List
import Data.STRef
import Control.Monad
import Control.Monad.ST
import Data.Function

--ex2

bucketConst :: Int
bucketConst = 100

bucketSort :: [(Int, a)] -> [(Int, a)]
bucketSort list =
    concatMap (sortBy (compare `on` fst)) . elems $ runSTArray $ do
        buckets <- newArray (0, bucketConst-1) []
        forM_ list $ \(key, x) -> do
            let i = floor $ (fromIntegral ((bucketConst - 1) * key)) / m
            arr <- readArray buckets i
            writeArray buckets i ((key, x):arr)
        return buckets
    where m = fromIntegral $ maximum $ map fst list

-- wyniki
-- [10000000..0]
-- * bucket 3.33ms
-- * sortBy 2.01ms
-- random 1000000
-- * bucket 1.2s
-- * sortBy 4.15s
-- widać że działa szybciej (dla odpowiednich danych) dzięki modyfikacji wskaźników

--ex3

data Union s = Union { ids :: STUArray s Int Int, sizes :: STUArray s Int Int }

makeSet :: Int -> ST s (Union s)
makeSet n = liftM2 Union (newListArray (0, n-1) [0..n-1]) (newArray (0, n-1) 1)

ufind :: Union s -> Int -> ST s Int
ufind un x = do
    (mn, mx) <- getBounds (ids un)
    if x < mn || x > mx then error "Index out of bounds" else do
    parent <- readArray arr x
    root <- if parent == x then return x else (ufind un parent)
    writeArray arr x root
    num <- readArray arr root
    writeArray (sizes un) root (num+1)
    return root
    where arr = ids un

uunion :: Union s -> Int -> Int -> ST s ()
uunion un x y = do
    xR <- ufind un x
    yR <- ufind un y
    if xR == yR then return () else do
        xS <- readArray arr xR
        yS <- readArray arr yR
        if xS < yS then do
            writeArray arr xR yR
            writeArray si yR (xS+yS)
        else do
            writeArray arr yR xR
            writeArray si xR (xS+yS)
    where arr = ids un
          si  = sizes un

disjoint :: Union s -> Int -> Int -> ST s Bool
disjoint un x y = liftM2 (/=) (ufind un x) (ufind un y)

data Edges a = Edge a (a, a) deriving Show
data Graph = Graph { edges :: [Edges Int], vertices :: [Int] } deriving Show

makeGraph :: [Edges Int] -> Graph
makeGraph [] = Graph [] []
makeGraph e =  Graph e (nub $ foldl (\a (Edge _ (x1',x2')) -> x1':x2':a) [] e)

minSpanningTree :: Graph -> Graph
minSpanningTree graph = makeGraph $ runST $ do
    un <- makeSet vlen
    result <- newSTRef []
    forM_ sorted $ \e@(Edge _ (x,y)) -> do
        dj <- disjoint un x y
        when dj $ do
            uunion un x y
            modifySTRef result (e:)
    readSTRef result
    where vlen = maximum $ vertices graph
          sorted = sortBy (\(Edge l _) (Edge r _) -> compare l r) $ edges graph

wikiGraph :: Graph
wikiGraph = makeGraph [Edge 5 (0, 3), Edge 7 (0, 1), Edge 9 (1, 3), Edge 8 (1, 2), Edge 7 (1, 4), Edge 5 (2, 4), Edge 15 (3, 4), Edge 6 (3, 5), Edge 8 (4, 5), Edge 9 (4, 6), Edge 11 (5, 6)]

-- >>> minSpanningTree wikiGraph
-- Graph {edges = [Edge 9 (4,6),Edge 7 (1,4),Edge 7 (0,1),Edge 6 (3,5),Edge 5 (2,4),Edge 5 (0,3)], verticles = [0,3,2,4,5,1,6]}
--

--ex4
data Unionf s = Unionf { idsf :: [Int], sizesf :: [Int] }

makeSetf :: Int -> Unionf s
makeSetf n = Unionf [0..n] (replicate n 0)

writeList :: [a] -> Int -> a -> [a]
writeList list n x = a ++ (x:b) where (a, (_:b)) = splitAt n list

ufindf :: Unionf s -> Int -> (Int, Unionf s)
ufindf un x = 
    let parent = (idsf un) !! x in
    let (root, un') = if parent == x then (x, un) else (ufindf un parent) in
    let nun = Unionf (writeList (idsf un') x root) (sizesf un') in
    let num = (idsf nun) !! root in
    (root, Unionf (idsf nun) $ writeList (sizesf nun) root (num+1))
  
uunionf :: Unionf s -> Int -> Int -> Unionf s
uunionf un x y = let (xR, xun) = ufindf un x in
                 let (yR, un') =  ufindf xun y in
    if xR == yR then un' else
        let xS = (idsf un') !! x in
        let yS = (idsf un') !! y in
        if xS < yS then
            Unionf (writeList (idsf un') xR yR) (writeList (sizesf un') yR (xS + yS))
        else
            Unionf (writeList (idsf un') yR xR) (writeList (sizesf un') yR (xS + yS))

disjointf :: Unionf s -> Int -> Int -> Bool
disjointf un x y = let (xR, yR) = (fst (ufindf un x), fst (ufindf un y)) in xR /= yR

minSpanningTreef :: Graph -> Graph
minSpanningTreef graph = let un = makeSetf vlen in makeGraph $ graphy un sorted []
    where vlen = maximum $ vertices graph
          sorted = sortBy (\(Edge l _) (Edge r _) -> compare l r) $ edges graph
          graphy _ [] acc = acc
          graphy un (e@(Edge _ (x,y)):t) acc = case disjointf un x y of
                False -> graphy un t acc
                True  -> graphy (uunionf un x y) t (e:acc)

-- >>> minSpanningTreef wikiGraph
-- Graph {edges = [Edge 9 (4,6),Edge 7 (1,4),Edge 7 (0,1),Edge 6 (3,5),Edge 5 (2,4),Edge 5 (0,3)], verticles = [0,3,2,4,5,1,6]}
--

-- z testowania wyszło, że Monada ST działa dużo szybciej niż funkcyjna wersja union-finda