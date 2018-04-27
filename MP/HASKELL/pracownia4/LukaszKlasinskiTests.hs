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
  [ Test "inc"        (SrcString "input x in x + 1")    (Eval [42]        (Value 43))
  , Test "undefVar"   (SrcString "x")                   TypeError
  , Test "doubleVar"  (SrcString "input x y in x + y")  (Eval [42,42]     (Value 84))
  , Test "DivZero"    (SrcString "input x in x div 0")  TypeError
  , Test "Minus"      (SrcString "input x in -x")       (Eval [10]        (Value (-10)))
  , Test "NoInput"    (SrcString "42 + 42")             (Eval []          (Value 84))
  , Test "NoUse"      (SrcString "input x y z in x")    (Eval [10,20,30]  (Value 10))
  , Test "NoUse2"     (SrcString "input x y z in 20")   (Eval [10,20,30]  (Value 20))
  , Test "Modulo"     (SrcString "input x y in x mod y")(Eval [42,7]      (Value 0))
  , Test "undefVar2"  (SrcString "input x in x + y")    TypeError
  , Test "ifexpr"     (SrcString "input x in if x > 10 then 42 else 24") (Eval [42] (Value 42))
  , Test "div0OK"     (SrcString "input x in if x > 10 then 42 else x div 0") (Eval [42] (Value 42))
  , Test "diffName"   (SrcString "input _xoxoxo in _xoxoxo + 50") (Eval [42] (Value 92))
  , Test "WrongVal"   (SrcString "input x in x + true") TypeError
  , Test "WrongIf"    (SrcString "input x in if x then 42 else x") TypeError
  , Test "SimpleProg" (SrcFile "test1.pp4")             (Eval [1,2]       (Value 3))
  , Test "Delta"      (SrcFile "test2.pp4")             (Eval [1,5,3]     (Value 13))
  , Test "TypeError"  (SrcFile "test3.pp4")             TypeError
  , Test "AlmostTrue" (SrcFile "test4.pp4")             (Eval [42]        (Value 84))
  , Test "AlwaysTrue" (SrcFile "test5.pp4")             (Eval []          (Value 42))
  , Test "AlwyasFalse"(SrcFile "test6.pp4")             TypeError
  , Test "Bigger"     (SrcFile "test7.pp4")             (Eval [42,24]     (Value (-24217)))
  , Test "MoreLet"    (SrcFile "test8.pp4")             (Eval [10]        (Value 10000))
  , Test "MoreLet2"   (SrcFile "test9.pp4")             (Eval [10]        (Value 10000000))
  ]




