-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający testy.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko}Tests gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module LukaszKlasinskiTests(tests) where

-- Importujemy moduł zawierający typy danych potrzebne w zadaniu
import DataTypes

-- Lista testów do zadania
-- Należy uzupełnić jej definicję swoimi testami
tests :: [Test]
tests =
  [ Test "inc"       (SrcString "input x in x + 1") (Eval [42] (Value 43))
  , Test "undefVar"  (SrcString "x")                TypeError
  , Test "fnRet"     (SrcFile   "test.pp6" )        (Eval [42] (Value 84))
  , Test "fnArgPair" (SrcFile   "test1.pp6")        (Eval [42] (Value 85))
  , Test "fnMapEr"   (SrcFile   "test2.pp6")        TypeError
  , Test "fnMap"     (SrcFile   "test3.pp6")        (Eval [1,1,1] (Value 129))
  , Test "fnLocal"   (SrcFile   "test4.pp6")        (Eval [42] (Value 85))
  , Test "fnLocal2"  (SrcFile   "test5.pp6")        TypeError 
  , Test "fnLocal3"  (SrcFile   "test6.pp6")        (Eval [42] (Value 84))
  , Test "fnTriple"  (SrcFile   "test7.pp6")        (Eval [1,1,1] (Value 3))
  , Test "fnOk"      (SrcFile   "test8.pp6")        (Eval [2]  (Value 21))
  , Test "fnRuntime" (SrcFile   "test8.pp6")        (Eval [0]  RuntimeError)
  , Test "fnOverride"(SrcFile   "test9.pp6")        TypeError
  , Test "fnPower"   (SrcFile   "test10.pp6")       (Eval [42] (Value 84))
  , Test "fnFunIn"   (SrcFile   "test11.pp6")       (Eval [42] (Value 1))
  ]
