sm :: Ord a => [a] -> [a]
ssm xs = folds f [] xs where
         f a [] = [a]
         f a x = a : filter((<) a) x
