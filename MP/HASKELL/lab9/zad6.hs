import Data.List
import Data.Char

integerToString :: Integer -> String
integerToString 0 = "0"
integerToString n = (reverse . unfoldr(\n -> if n > 0 then Just((intToDigit . fromEnum)(n `mod` 10), n `div` 10) else Nothing)) n

main = do
	putStrLn $ show $ integerToString 22345600

