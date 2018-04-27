-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający testy.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko}Tests gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module DawidWojcikTests(tests) where

-- Importujemy moduł zawierający typy danych potrzebne w zadaniu
import DataTypes

-- Lista testów do zadania
-- Należy uzupełnić jej definicję swoimi testami
tests :: [Test]
tests =
  [ Test "Inc" (SrcString "input x in x + 1") (Eval [42] (Value 43))
  , Test "UndefVar" (SrcString "x") TypeError
  , Test "AddBool"(SrcString "1 + false") TypeError 
  , Test "NegBool" (SrcString "if 1>0 then true else -true") TypeError 
  , Test "NotInt" (SrcString "if not 0 then 1 else 0") TypeError
  , Test "CompBool" (SrcString "if false < true then 1 else 0") TypeError
  , Test "OneAndOne" (SrcString "1 and 1") TypeError
  , Test "CompBool2" (SrcString "if true = true then 1 else 0") TypeError
  , Test "OtherIfTypes" (SrcString "if true then 1 else false") TypeError
  , Test "ReturnBool" (SrcString "2 > 1") TypeError
  , Test "ReturnBool2" (SrcString "1 = 1") TypeError
  , Test "ReturnBool3" (SrcString "if true then true else false") TypeError
  , Test "ReturnBool4" (SrcString "true") TypeError
  , Test "InvCond" (SrcString "if 1 then 1 else 0") TypeError
  , Test "AnswerToLife" (SrcString "42") (Eval [] (Value 42))
  , Test "TwoPlusTwo" (SrcString "2 + 2") (Eval [] (Value 4))
  , Test "Arith1" (SrcString "6 div 2 + 2 * 0") (Eval [] (Value 3))
  , Test "Arith2" (SrcString "5 mod 2") (Eval [] (Value 1))
  , Test "OpPrior" (SrcString "2 + 2 * 3") (Eval [] (Value 8))
  , Test "OpPrior2" (SrcString "7 + - 2") (Eval [] (Value 5))
  , Test "OpPrior3" (SrcString "if -1 * 3 = -1 + -2 * 1 then 1 else 0") (Eval [] (Value 1))
  , Test "DivBy0" (SrcString "5 div 0") (Eval [] RuntimeError)
  , Test "Mod0" (SrcString "1 mod 0") (Eval [] RuntimeError)
  , Test "TAndF" (SrcString "if true and false then 1 else 0") (Eval [] (Value 0))
  , Test "TOrF" (SrcString "if true or false then 1 else 0") (Eval [] (Value 1))
  , Test "InvCond2" (SrcString "if 1 = 1 or 3 > 2 mod 0 then 1 else 0") (Eval [] RuntimeError)
  , Test "Addition" (SrcString "input x y in x + y") (Eval [10,2] (Value 12))
  , Test "Subtraction" (SrcString "input x y in x - y") (Eval [10,-2] (Value 12))
  , Test "Multiplication" (SrcString "input x y in x * y") (Eval [-10,-2] (Value 20))
  , Test "Division" (SrcString "input x y in x div y") (Eval [5,2] (Value 2))
  , Test "CompTest" (SrcString "if 2 <> -2 and 5 >= 5 then 1 else 0") (Eval [] (Value 1))
  , Test "OpTest" (SrcString "if 7 div 2 = 6 div 2 then 1 else 0") (Eval [] (Value 1))
  , Test "OneValidIf" (SrcString "if true and true then 4 div 0 else 1") (Eval [] RuntimeError)
  , Test "OneValidIf2" (SrcString "if false or false then 4 div 0 else 1") (Eval [] (Value 1))
  , Test "Constant" (SrcString "input x in 10") (Eval [4] (Value 10))
  , Test "Abs" (SrcString "input x in if x < 0 then -x else x") (Eval [-2] (Value 2))
  , Test "Abs2" (SrcString "input x in if x < 0 then -x else x") (Eval [2] (Value 2))
  , Test "Id" (SrcString "input x in let a = not true in if a then 0 else x") (Eval [4573218] (Value 4573218))
  , Test "NestedLet" (SrcString "let x = 1 in let x = x in x") (Eval [] (Value 1))
  -- Prac5
  , Test "IncompleteNil" (SrcString "let x = [] : int in if true then 1 else 0") TypeError
  , Test "WrongArgument" (SrcFile "wrarg.pp5") TypeError
  , Test "Id2" (SrcFile "id2.pp5") (Eval [3274] (Value 3274))
  , Test "FstTest" (SrcString "fst (1, 2)") (Eval [] (Value 1))
  , Test "SndTest" (SrcString "snd (1, 2)") (Eval [] (Value 2))
  , Test "DivInPair" (SrcString "fst (2, 3 div 0)") (Eval [] RuntimeError)
  , Test "PairTest" (SrcString "let z = (5, 1) in if true then fst z else snd z") (Eval [] (Value 5))
  , Test "TwoTypesList" (SrcString "let x = [1, true, 2] : int list in if true then 1 else 0") TypeError
  , Test "InvCons1" (SrcString "let y = [1, 2] : int list in let x = true::y in if true then 1 else 0") TypeError
  , Test "InvCons2" (SrcString "let x = [] : bool list in let y = 1::x in if true then 1 else 0") TypeError
  , Test "MatchNonList" (SrcString "let a = (1, 2) in match a with [] -> 1 | x::xs -> 0") TypeError
  , Test "Factorial" (SrcFile "factorial.pp5") (Eval [5] (Value 120))
  , Test "UnitTest" (SrcFile "foo_unit.pp5") (Eval [] (Value 2))
  , Test "LastOfList" (SrcFile "list_last.pp5") (Eval [] (Value 3))
  ]
 

     
