

nat :: [(Integer,Integer)]
nat = [(y,x-y) | x <- [0..], y <- [0..x]]

showpair :: (Integer, Integer) -> (String)
showpair (a,b) = (show a ++ "," ++ show b)

main = do
       putStrLn $ show (take 20 (map showpair (nat)))
