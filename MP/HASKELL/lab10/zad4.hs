msortn :: Ord a => [a] -> Int -> [a]
msortn _ 0 = []
msort (x:_) 1 = [x]
msortn xs n = merge ((msortn xs half), msortn (drop half xs)(n-half))
       where half = n `div` 2

msort xs = msortn xs (length xs)

