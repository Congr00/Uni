--Łukasz Klasiński
--Haskell Course
--List 10
--31-05-2020

{-# LANGUAGE ScopedTypeVariables, GADTs, DeriveFunctor #-}

import Generic.Random
import Test.QuickCheck
import Data.Array
import Data.Array.ST
import Data.List
import Data.STRef
import Control.Monad
import Control.Monad.ST
import Data.Functor
import Data.Char

-- funkcje z poprzedniej listy

data Union s = Union { ids :: STUArray s Int Int, sizes :: STUArray s Int Int }

makeSet :: Int -> ST s (Union s)
makeSet n = liftM2 Union (newListArray (0, n) [0..n]) (newArray (0, n) 1)

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

data Edges a = Edge a (a, a) deriving (Show, Eq)
data Graph = Graph { edges :: [Edges Int], vertices :: [Int] } deriving (Show, Eq)

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

randomEdge :: (Int, Int) -> Gen (Edges Int)
randomEdge (mn, mx) = do
        weight <- choose (0, 1000)
        x1 <- choose (mn, mx)
        x2 <- choose (mn, mx)
        return $ Edge weight (x1, x2)

randomEdges :: Gen [Edges Int]
randomEdges = sized $ \n -> do
            len <- choose (1, n*n+1)
            edges_list <- replicateM len $ suchThat (randomEdge (0, len)) (\(Edge w (l, r)) -> w > 0 && r /= l)
            return $ unique_edges edges_list

unique_edges :: [Edges Int] -> [Edges Int]
unique_edges [] = []
unique_edges (x@(Edge _ (l, r)):xs)
    | all id (map (\(Edge _ (l', r')) -> l /= l' && r /= r') xs) = x:(unique_edges xs)
    | otherwise = unique_edges xs


instance Arbitrary Graph where
    arbitrary = makeGraph <$> randomEdges

generate_krunskall_test :: Graph -> Bool
generate_krunskall_test graph = (minSpanningTree graph) == (minSpanningTreef graph)

test_krunskall = quickCheck generate_krunskall_test
-- przeszło 100 testów

-- zad 3

data Queue a = Queue { front :: [a], rear :: [a] } deriving Show

empty :: Queue a
empty = Queue [] []
isEmpty :: Queue a -> Bool
isEmpty q = case (front q, rear q) of
    ([], []) -> True
    _        -> False
pushBack :: a -> Queue a -> Queue a
pushBack a q = case (front q) of
    [] -> Queue [a] (rear q)
    xs -> Queue xs $ a:(rear q)
peek :: Queue a -> a
peek q = case fq of
    [] -> case rq of
        [] -> error "Empty queue"
        _  -> peek $ Queue (reverse rq) []
    h:_    -> h
    where
        fq = front q
        rq = rear q
popFront :: Queue a -> Queue a
popFront q = case fq of
    [] -> case rq of
        [] -> error "Empty queue"
        _  -> popFront $ Queue (reverse rq) []
    _:t    -> case t of
            [] -> Queue (reverse rq) []
            _  -> Queue t rq
    where
        fq = front q
        rq = rear q
toList :: Queue a -> [a]
toList q = front q ++ (reverse $ rear q)
fromList :: [a] -> Queue a
fromList = foldr pushBack empty

instance (Arbitrary a) => Arbitrary (Queue a) where
    arbitrary = fromList <$> arbitrary

(==?) :: Queue Int -> [Int] -> Bool
q ==? xs = toList q == xs && cond
    where cond = if (null $ front q) && (not . null $ rear q) then False else True

prop_Empty = empty ==? []
prop_IsEmpty :: Queue Int -> Bool
prop_IsEmpty q = (isEmpty q) == (null $ toList q)
prop_push q a = pushBack a q ==? (toList q ++ [a])
prop_pop q = if null $ toList q then True else popFront q ==? (tail $ toList q)
prop_peek :: Queue Int -> Bool
prop_peek q = if null $ toList q then True else peek q == (head $ toList q)


-- quickCheckAll nie chciał działać, więc workaround
test_empty = quickCheck prop_Empty
test_is_empty = quickCheck prop_IsEmpty
test_push = quickCheck prop_push
test_pop = quickCheck prop_pop
test_peek = quickCheck prop_peek

-- wszystko poprzechodziło

-- ex5
data CoYoneda f a = forall b. CoYoneda (b -> a) (f b)

toCoYoneda :: f a -> CoYoneda f a
toCoYoneda x = CoYoneda id x

fromCoYoneda :: (Functor f) => CoYoneda f a -> f a
fromCoYoneda (CoYoneda f x) = fmap f x

instance Functor (CoYoneda f) where
    fmap g (CoYoneda f x) = CoYoneda (g . f) x

{-

1)
(fromCoYoneda . toCoYoneda) f - aplikujemy f
fromCoYoneda (CoYoneda id f)
fmap id f = f

2)
(toCoYoneda . fromCoYoneda) f a -> aplikujemy f a
toCoYoneda () - i tutaj poddałem się

-}

-- ex6

data Expr a = Add  (Expr a) (Expr a)
            | Mult (Expr a) (Expr a)
            | Var a
        deriving (Show, Functor)

refactor :: Expr String -> IO ()
refactor expr = coyoneda_loop $ toCoYoneda expr

snake :: String -> String
snake [] = []
snake (x:xs) = if isUpper x then '_':(toLower x):snake xs else x:snake xs

camel :: String -> String
camel str = camelB str False 
    where
        camelB :: String -> Bool -> String
        camelB [] _ = []
        camelB (x:xs) False = if x == '_' then camelB xs True else x:camelB xs False
        camelB (x:xs) True = (toUpper x):camelB xs False

name_change :: String -> Bool
name_change str = if (length $ filter (\x -> x == '/') str) == 2 then True else False

changer :: String -> String -> String -> String
changer from to str = if str == from then to else str

-- nie byłem w stanie doprowadzić do używalności żadnego gotowego split w haskellu (a próbowałem 3), więc napisałem na szybko swoje
split :: String -> Char -> [String]
split str at = splitA str [] "" at
    where
        splitA :: String -> [String] -> String -> Char -> [String]
        splitA [] acc current _ = reverse $ reverse current:acc
        splitA (x:xs) acc curr a = if x == a then splitA xs (reverse curr:acc) "" a else splitA xs acc (x:curr) a

parse_names :: String -> (String, String)
parse_names str = let s = split str '/' in if length s < 3 then ("", "") else (s !! 1, s !! 2)

coyoneda_loop :: CoYoneda Expr String -> IO ()
coyoneda_loop coexpr = do
                    input <- getLine
                    case input of
                        "camel" -> coyoneda_loop $ camel <$> coexpr 
                        "snake" -> coyoneda_loop $ snake <$> coexpr
                        "print" -> do 
                                    print $ fromCoYoneda coexpr
                                    coyoneda_loop coexpr
                        otherwise -> if name_change input then 
                                        let (from, to) = parse_names input in coyoneda_loop $ (changer from to) <$> coexpr
                                     else coyoneda_loop coexpr
run_loop :: Expr String -> IO ()
run_loop expr = refactor expr
test_loop = run_loop $ Add (Var "hello") (Mult (Var "good_morning") (Var "goodnight"))

-- ex 7

data Free f a = Node (f (Free f a))
              | Varf a
    deriving (Functor)

sumFree :: (Functor f, Foldable f) => Free f Int -> Int
sumFree (Varf n) = n
sumFree (Node s) = foldr (+) 0 $ fmap sumFree s

newtype DList a = DList { unDList :: [a] -> [a] }

instance Foldable DList where
    foldr f x xs = foldr f x $ unDList xs []

cydList xs = toCoYoneda $ DList $ (xs ++)

instance (Foldable f) => (Foldable (CoYoneda f)) where
    foldMap g (CoYoneda f x) = foldMap (g . f) x

test = sumFree $ Node $ cydList [
    Varf 4
    , Node $ cydList [Varf 2, Varf 6, Varf 1]
    , Node $ cydList [Varf 10]
    , Varf 1]

-- teraz działa