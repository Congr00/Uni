import System.Random
{- Łukasz Klasiński -}

{- zad1 -}

randomIntIO :: (Int, Int) -> IO Int
randomIntIO (lo, hi) = randomRIO (lo, hi)

randomInts :: Int -> (Int, Int) -> Int -> [Int]
randomInts n (lo, hi) zarodek = take n (randomRs (lo, hi) (mkStdGen zarodek))

printBoard :: [Int] -> IO() 
printBoard board = do   putStr "printing board\n------------------\n" 
                        printBoardNum board 1
                        putStr "------------------\n"
    where
        printBoardNum :: [Int] -> Int -> IO()
        printBoardNum [] _ = putStr ""
        printBoardNum (hd:tl) num = do   putStr . show $ num
                                         putStr " "
                                         printRow hd
                                         printBoardNum tl (num+1)

printRow :: Int -> IO()
printRow 0 = putStr "\n"
printRow n = do   putStr "*"
                  printRow (n-1)

game :: IO()
game = do   putStr "Insert number of rows:\n"
            rows <- readLn :: IO Int
            first_move <- randomIntIO (0, 1)
            if first_move == 0 
            then do 
                putStr "You go first!\n"
                loop True True (randomInts rows (1, rows) 10)
            else do
                putStr "AI first!\n"
                loop True False (randomInts rows (1, rows) 10)

removeNth :: Int -> [Int] -> Int -> [Int]
removeNth _ [] _ = []
removeNth 0 (0:tl)  _ = 0:removeNth (-1) tl 0
removeNth 0 (hd:tl) x = if x > hd then  0:removeNth (-1) tl 0
                        else (hd-x):removeNth (-1) tl 0
removeNth n (hd:tl) x = hd:removeNth (n-1) tl x

nthField :: Int -> [Int] -> Int
nthField 0 [] = 0
nthField 0 (hd:_) = hd
nthField n (hd:tl) = nthField (n-1) tl

whileHit :: ((Int, Int) -> IO Int) -> [Int] -> IO Int
whileHit gen board = do    n <- gen (0, (length board)-1)
                           if (nthField n board) == 0
                           then do 
                               whileHit gen board
                           else do 
                               return n

checkWin :: [Int] -> Bool
checkWin board = (foldr (+) 0 board) /= 0

loop :: Bool -> Bool -> [Int] -> IO()
loop False True _ =  do   putStr "AI won...\n"
                          return ()
loop False False _ = do   putStr "You won!\n"
                          return ()
-- ai move
loop True False board = do   printBoard board
                             putStr "AI doing move...\n"
                             num <- whileHit randomIntIO board
                             n <- randomIntIO (0, (nthField num board))
                             putStr "AI picked row: "
                             putStr . show $ (num+1)
                             putStr ", "
                             putStr . show $ (n)
                             putStr " fields\n"
                             let nboard = removeNth num board n;
                             loop (checkWin nboard) True nboard
-- player move
loop True True board = do   printBoard board
                            putStr "Choose row number:\n"
                            num <- readLn :: IO Int
                            putStr "Choose how many:\n"
                            n <- readLn :: IO Int
                            let nboard = removeNth (num-1) board n;
                            loop (checkWin nboard) False nboard
main :: IO()
main = game