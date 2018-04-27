
loop :: a
loop = loop

ones :: [Integer]
ones = 1 : ones

main = 
     print $ last [1..]
