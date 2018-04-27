-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający rozwiązanie.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko} gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module LukaszKlasinski (typecheck, eval) where

-- Importujemy moduły z definicją języka oraz typami potrzebnymi w zadaniu
import AST
import DataTypes
  
-- Funkcja sprawdzająca typy
-- Dla wywołania typecheck vars e zakładamy, że zmienne występujące
-- w vars są już zdefiniowane i mają typ int, i oczekujemy by wyrażenia e
-- miało typ int
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.
typecheck :: [Var] -> Expr p -> TypeCheckResult p
typecheck x prog = let xr = map input_int x
                   in case typecheck_int xr prog of
                      Error p msg -> Error p msg
                      Ok          -> Ok


data Var_type = Int | Boolean deriving(Eq)
--type Var_tbl = [(Var,Var_type)]
-- nadanie wejsciu wartosci Int
input_int :: Var -> (Var,Var_type)
input_int x = (x,Int)

-- typecheck
--typecheck' :: [(Var,Var_type)] -> Expr p -> TypeCheckResult p
--typecheck' x (EBool p bool) = Error p "must return int value"
--typecheck' x (ENum p n)     = Ok
--typecheck' x (EVar p var)   = typecheck_int x (EVar p var)
-- binary int check
--typecheck' x (EBinary p BAdd (p1) (p2)) = typecheck_int x (EBinary p BAdd (p1) (p2))
--typecheck' x (EBinary p BSub (p1) (p2)) = typecheck_int x (EBinary p BSub (p1) (p2))
--typecheck' x (EBinary p BMul (p1) (p2)) = typecheck_int x (EBinary p BMul (p1) (p2))
--typecheck' x (EBinary p BDiv (p1) (p2)) = typecheck_int x (EBinary p BDiv (p1) (p2))
--typecheck' x (EBinary p BMod (p1) (p2)) = typecheck_int x (EBinary p BMod (p1) (p2))
-- unary int check
--typecheck' x (EUnary  p UNeg  (p1))     = typecheck_int x (EUnary  p UNeg (p1))
-- if
--typecheck' x (EIf     p (p1) (p2) (p3)) =   -- case typecheck_bool x p1 of
                                         --(Error p msg,_) -> (Error p msg,x)
                                         --_               -> case typecheck_int x p2 of
                                        --     (Error p msg,_) -> case typecheck_bool x p2 of
                                         --         (Error p msg,_) -> (Error p msg,x)
                                           --       _               -> case typecheck_bool x p3 of
                                             --          (Error p msg,_) -> (Error p msg,x)
                                               --        (Ok,x')         -> (Ok,x')
                                            -- _   --            -> case typecheck_int x p3 of
                                              --    (Error p msg,_) -> (Error p msg,x)
                                                --  (Ok,x')         -> (Ok,x')
--typecheck' x (ELet p var (p1) (p2)) = case typecheck_bool x p1 of
--                                      (Error p msg,_) -> case typecheck_int x p1 of
--                                         (Error p msg,_) -> (Error p msg,x)
--                                         _               ->  case typecheck' ((var,Int):x) p2 of
--                                                (Error p msg,_) -> (Error p msg,x)
 --                                               (Ok,x')         -> (Ok,x')
  --                                    _               -> case typecheck' ((var,Boolean):x) p2 of
  --                                       (Error p msg,_) -> (Error p msg,x)
   --                                      (Ok,x')         -> (Ok,x')
--typecheck' _ prog = (Error pr "Must return Int",undefined) where pr = getData prog       
--pomocnicze        
sel1 :: (Var,Var_type) -> Var
sel1 (v,_) = v
sel2 :: (Var,Var_type) -> Var_type
sel2 (_,v_t) = v_t
-- obsolete
exists :: [(Var,Var_type)] -> Expr p -> TypeCheckResult p
exists []    (EVar p var) = Error p ("variable '" ++ var ++ "' not initialized")
exists (x:xs) (EVar p var) = if var == sel1 x then Ok
                             else exists xs (EVar p var)
-- sprawdzenie czy zmienna ma dobry typ/wgle istnieje
check_type :: [(Var,Var_type)] -> Var_type -> Expr p -> TypeCheckResult p
check_type []     v_t  (EVar p var) = Error p ("variable '" ++ var ++ "' not initialized")
check_type (x:xs) v_t  (EVar p var) = if sel1 x == var then
                                             if sel2 x == v_t then Ok 
                                             else Error p ("variable '" ++ var ++ "' has wrong value")                  
                                      else check_type xs v_t (EVar p var)
-- typecheck ktory musi byc typu bool
typecheck_bool :: [(Var,Var_type)] -> Expr p -> TypeCheckResult p
typecheck_bool x (EBool p bool) = Ok
typecheck_bool x (EVar p var)   = case check_type x Boolean (EVar p var) of
                                  Error p msg -> Error p msg
                                  Ok          -> Ok
typecheck_bool x (EUnary  p UNot (p1))      = case typecheck_bool x p1 of
                                              Error p msg -> Error p msg
                                              Ok          -> Ok
typecheck_bool x (EBinary p BAnd (p1) (p2)) = case typecheck_bool x p1 of
                                              Error p msg -> Error p msg
                                              _           -> case typecheck_bool x p2 of
                                                             Error p msg -> Error p msg
                                                             Ok          -> Ok
typecheck_bool x (EBinary p BOr  (p1) (p2)) = case typecheck_bool x p1 of
                                              Error p msg -> Error p msg
                                              _           -> case typecheck_bool x p2 of
                                                             Error p msg -> Error p msg
                                                             Ok          -> Ok
typecheck_bool x (EBinary p BLt  (p1) (p2)) = case typecheck_int x p1 of
                                              Error p msg -> Error p msg
                                              _           -> case typecheck_int x p2 of
                                                        Error p msg -> Error p msg
                                                        Ok          -> Ok
typecheck_bool x (EBinary p BGt  (p1) (p2)) = case typecheck_int x p1 of
                                              Error p msg -> Error p msg
                                              _           -> case typecheck_int x p2 of
                                                        Error p msg -> Error p msg
                                                        Ok          -> Ok
typecheck_bool x (EBinary p BLe  (p1) (p2)) = case typecheck_int x p1 of
                                              Error p msg -> Error p msg
                                              _           -> case typecheck_int x p2 of
                                                        Error p msg -> Error p msg
                                                        Ok          -> Ok
typecheck_bool x (EBinary p BGe  (p1) (p2)) = case typecheck_int x p1 of
                                              Error p msg -> Error p msg
                                              _           -> case typecheck_int x p2 of
                                                        Error p msg -> Error p msg
                                                        Ok          -> Ok

typecheck_bool x (EBinary p BEq  (p1) (p2)) = case typecheck_int x p1 of
                                              Error p msg -> Error p msg
                                              _           -> case typecheck_int x p2 of
                                                        Error p msg -> Error p msg
                                                        Ok         -> Ok
typecheck_bool x (EBinary p BNeq  (p1) (p2)) = case typecheck_int x p1 of
                                               Error p msg -> Error p msg
                                               _           -> case typecheck_int x p2 of
                                                        Error p msg -> Error p msg
                                                        Ok          -> Ok

typecheck_bool x (EIf p (p1) (p2) (p3)) = case typecheck_bool x p1 of
                                          Error p msg -> Error p msg
                                          _           -> case typecheck_bool x p2 of
                                              Error p msg -> Error p msg
                                              _           -> case typecheck_bool x p3 of
                                                             Error p msg -> Error p msg
                                                             Ok         -> Ok
typecheck_bool x (ELet p var (p1) (p2)) = case typecheck_bool x p1 of
                                          Error p msg -> case typecheck_int x p1 of
                                              Error p msg  -> Error p msg
                                              _            -> case typecheck_bool ((var,Int):x) p2 of
                                                  Error p msg -> Error p msg
                                                  Ok          -> Ok
                                          _           -> case typecheck_bool ((var,Boolean):x) p2 of
                                              Error p msg -> Error p msg
                                              Ok          -> Ok                  
typecheck_bool _ prog = Error pr "Must be bool expression" where pr = getData prog 


typecheck_int :: [(Var,Var_type)] -> Expr p -> TypeCheckResult p
typecheck_int x (ENum p const) = Ok
typecheck_int x (EVar p var) = case check_type x Int (EVar p var) of
                               Error p msg -> Error p msg
                               Ok          -> Ok
typecheck_int x (EUnary  p UNeg (p1))      = case typecheck_int x p1 of
                                             Error p msg -> Error p msg
                                             Ok          -> Ok
typecheck_int x (EBinary p BAdd (p1) (p2)) = case typecheck_int x p1 of
                                             Error p msg -> Error p msg
                                             _           -> case typecheck_int x p2 of
                                                            Error p msg -> Error p msg
                                                            Ok          -> Ok
typecheck_int x (EBinary p BSub (p1) (p2)) = case typecheck_int x p1 of
                                             Error p msg -> Error p msg
                                             _           -> case typecheck_int x p2 of
                                                            Error p msg -> Error p msg
                                                            Ok          -> Ok
typecheck_int x (EBinary p BMul (p1) (p2)) = case typecheck_int x p1 of
                                             Error p msg -> Error p msg
                                             _           -> case typecheck_int x p2 of
                                                            Error p msg -> Error p msg
                                                            Ok          -> Ok
typecheck_int x (EBinary p BDiv (p1) (p2)) = case typecheck_int x p1 of
                                             Error p msg -> Error p msg
                                             _           -> case typecheck_int x p2 of
                                                            Error p msg -> Error p msg
                                                            Ok          -> Ok
typecheck_int x (EBinary p BMod (p1) (p2)) = case typecheck_int x p1 of
                                             Error p msg -> Error p msg
                                             _           -> case typecheck_int x p2 of
                                                            Error p msg -> Error p msg
                                                            Ok -> Ok
typecheck_int x (ELet p var (p1) (p2) )    = case typecheck_bool x p1 of
                                              Error p msg  -> case typecheck_int x p1 of
                                                 Error p msg -> Error p msg
                                                 _           -> case typecheck_int ((var,Int):x) p2 of
                                                     Error p msg -> Error p msg
                                                     Ok          -> Ok
                                              _               -> case typecheck_int ((var,Boolean):x) p2 of
                                                 Error p msg -> Error p msg
                                                 Ok          -> Ok
typecheck_int x (EIf p (p1) (p2) (p3))     = case typecheck_bool x p1 of
                                             Error p msg -> Error p msg
                                             _           -> case typecheck_int x p2 of
                                                 Error p msg -> Error p msg
                                                 _           -> case typecheck_int x p3 of
                                                                Error p msg -> Error p msg
                                                                Ok          -> Ok
typecheck_int _ prog = Error pr "Must be int value" where pr = getData prog

-- Funkcja obliczająca wyrażenia
-- Dla wywołania eval input e przyjmujemy, że dla każdej pary (x, v)
-- znajdującej się w input, wartość zmiennej x wynosi v.
-- Możemy założyć, że wyrażenie e jest dobrze typowane, tzn.
-- typecheck (map fst input) e = Ok
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.
-- typ zwracanych danych przez eval'
data Value = MInt Integer | MBool Bool

eval :: [(Var,Integer)] -> Expr p -> EvalResult
eval items expr = case eval' (map map_var items) expr of
                  Just (MInt val) -> Value val
                  _               -> RuntimeError
-- zamiana zmiennych wejsciwych na wlasny typ
map_var :: (Var,Integer) -> (Var,Value)
map_var (x,y) = (x,MInt y)

-- pobranie wartosci zmiennej
get_value :: [(Var,Value)] -> Var -> Value
get_value ((x,y):xs) var = if var == x then y
                           else get_value xs var

eval' :: [(Var,Value)] -> Expr p -> Maybe Value
eval' x (EVar p var)         = Just(get_value x var)
eval' x (ENum p val)         = Just(MInt val)
eval' x (EBool p bool)       = Just(MBool bool)
eval' x (EUnary p UNot (p1)) = case eval' x p1 of
                               Just(MBool bval) -> Just(MBool (not bval))
                               _                -> Nothing 
eval' x (EUnary p UNeg (p1)) = case eval' x p1 of
                               Just(MInt val) -> Just(MInt (-val))
                               _              -> Nothing           
eval' x (EBinary p BAdd (p1)(p2)) = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                       Just(MInt val2) -> Just(MInt (val1 + val2))
                                                       _               -> Nothing
                                    _               -> Nothing
eval' x (EBinary p BSub (p1)(p2)) = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                       Just(MInt val2) -> Just(MInt (val1 - val2))
                                                       _               -> Nothing
                                    _               -> Nothing 
eval' x (EBinary p BMul (p1)(p2)) = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                       Just(MInt val2) -> Just(MInt (val1 * val2))
                                                       _               -> Nothing
                                    _               -> Nothing 

eval' x (EBinary p BDiv (p1)(p2)) = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                       Just(MInt 0)    -> Nothing
                                                       Just(MInt val2) -> Just(MInt (val1 `div` val2))
                                                       _               -> Nothing
                                    _               -> Nothing                  
eval' x (EBinary p BMod (p1)(p2)) = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                       Just(MInt 0)    -> Nothing
                                                       Just(MInt val2) -> Just(MInt (val1 `mod` val2))
                                                       _               -> Nothing
                                    _               -> Nothing
eval' x (EBinary p BAnd (p1)(p2)) = case eval' x p1 of
                                    Just(MBool val1) -> case eval' x p2 of
                                                        Just(MBool val2) -> Just(MBool (val1 && val2))
                                                        _                -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BOr (p1)(p2))  = case eval' x p1 of
                                    Just(MBool val1) -> case eval' x p2 of
                                                        Just(MBool val2) -> Just(MBool (val1 || val2))
                                                        _                -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BEq (p1)(p2))  = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                        Just(MInt val2) -> Just(MBool (val1 == val2))
                                                        _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BNeq (p1)(p2)) = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                        Just(MInt val2) -> Just(MBool (val1 /= val2))
                                                        _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BLt (p1)(p2))  = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                        Just(MInt val2) -> Just(MBool (val1 < val2))
                                                        _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BGt (p1)(p2))  = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                        Just(MInt val2) -> Just(MBool (val1 > val2))
                                                        _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BLe (p1)(p2))  = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                        Just(MInt val2) -> Just(MBool (val1 <= val2))
                                                        _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BGe (p1)(p2))  = case eval' x p1 of
                                    Just(MInt val1) -> case eval' x p2 of
                                                        Just(MInt val2) -> Just(MBool (val1 >= val2))
                                                        _               -> Nothing
                                    _                -> Nothing
eval' x (ELet p var (p1)(p2)) = case eval' x p1 of
                                Just(MInt val)   -> eval' ((var,MInt val):x) p2
                                Just(MBool bval) -> eval' ((var,MBool bval):x) p2
                                _                -> Nothing
eval' x (EIf p (p1)(p2)(p3))  = case eval' x p1 of
                                Just(MBool True)  -> eval' x p2
                                Just(MBool False) -> eval' x p3
                                _                 -> Nothing





