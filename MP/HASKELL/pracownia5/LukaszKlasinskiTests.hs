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
  [ Test "inc"      (SrcString "input x in x + 1")    (Eval [42]     (Value 43))
  , Test "undefVar" (SrcString "x")                   TypeError
  , Test "NoInputs" (SrcString "42")                  (Eval []       (Value 42))
  , Test "Sub two"  (SrcString "input x y in x - y + 41")  (Eval [42,41]  (Value 42))
  , Test "Div by zero" (SrcString "42 div 0")           (Eval []       RuntimeError)
  , Test "typecheck"(SrcString "23 or 21")            TypeError
  , Test "SimpleFun"(SrcFile "simplefun.pp5")         (Eval[]        (Value 42))
  , Test "SimplePairFun" (SrcFile "simplepairfun.pp5")(Eval []       (Value 42))
  , Test "SimpleListFun" (SrcFile "simplelistfun.pp5")(Eval []       (Value 42)) 
  , Test "NaiveFibb" (SrcFile "naivefibb.pp5")        (Eval []       (Value 42))
  , Test "SumList"   (SrcFile "sumlist.pp5")          (Eval []       (Value 42))
  , Test "SumPairs"  (SrcFile "sumpairs.pp5")         (Eval []       (Value 42)) 
  , Test "PseudoMap" (SrcFile "pseudomap.pp5")        (Eval []       (Value 42))
  , Test "ListLength"(SrcFile "listlength.pp5")       (Eval []       (Value 42))
  , Test "YouCantDiv"(SrcFile "youcantdiv.pp5")       (Eval [24]     RuntimeError)
  , Test "YouCanDiv" (SrcFile "youcantdiv.pp5")       (Eval [42]     (Value 42))
  , Test "PowerOfFortytwo" (SrcFile "poweroffortytwo.pp5") (Eval [42,24] RuntimeError)
  , Test "PowerOfFortytwo!"(SrcFile "poweroffortytwo.pp5") (Eval [42,42] (Value 42))
  , Test "NeverLucky" (SrcFile "neverlucky.pp5")      (Eval[2,10,21,7] RuntimeError)
  , Test "SometimesLucky" (SrcFile "neverlucky.pp5")  (Eval [2,10,21,9]  (Value 42))
  , Test "YouDontMatch" (SrcFile "youdontmatch.pp5")  TypeError 
  , Test "Listplease"   (SrcFile "listplease.pp5")    TypeError
  , Test "Praise42"     (SrcFile "praise42.pp5")      TypeError
  , Test "WhyYouDoThis" (SrcFile "whyyoudothis.pp5")  TypeError
 ] 






