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
--import Debug.Trace
-- Funkcja sprawdzająca typy
-- Dla wywołania typecheck vars e zakładamy, że zmienne występujące
-- w vars są już zdefiniowane i mają typ int, i oczekujemy by wyrażenia e
-- miało typ int
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.

typecheck :: [FunctionDef p] -> [Var] -> Expr p -> TypeCheckResult p
typecheck tbl x prog = let xr = map input_int x
                   in case typecheck_int tbl xr prog of
                      Error p msg -> Error p msg
                      Ok          -> fun_typecheck tbl tbl

fun_typecheck :: [FunctionDef p] -> [FunctionDef p]  -> TypeCheckResult p
fun_typecheck flist []     = Ok
fun_typecheck flist (x:xs) = case get_type flist [((funcArg x),(funcArgType x))] (funcBody x) of
                             (_,Error p msg) -> Error p msg
                             (t,Ok)          -> if(t == (funcResType x)) then fun_typecheck flist xs
                                                else Error pr "Wrong return type" where pr = getData(funcBody x)

data Value = VInt Integer | VBool Bool | VPair Value Value | VList[Value] | VUnit

-- nadanie wejsciu wartosci Int
input_int :: Var -> (Var,Type)
input_int x = (x,TInt)
--pomocnicze    
-- sprawdzenie czy zmienna ma dobry typ/wgle istnieje
check_type :: [(Var,Type)] -> Type -> Expr p -> TypeCheckResult p
check_type []     v_t  (EVar p var) = Error p ("variable '" ++ var ++ "' not initialized")
check_type (x:xs) v_t  (EVar p var) = if fst x == var then
                                             if snd x == v_t then Ok 
                                             else Error p ("variable '" ++ var ++ "' has wrong value")                  
                                      else check_type xs v_t (EVar p var)
-- pobranie typu zmiennej
get_var_type :: [(Var,Type)] -> Expr p -> (Type,TypeCheckResult p)
get_var_type [] (EVar p var)     = (undefined,Error p ("variable '" ++ var ++ "' not initialized"))
get_var_type (x:xs) (EVar p var) = if fst x == var then (snd x,Ok)
                               else get_var_type xs (EVar p var)
-- czy istnieje funkcja
f_exists :: [FunctionDef p] -> Expr p -> TypeCheckResult p
f_exists []     (EApp p name x1) = Error p ("function '" ++ name ++ "' doesnt exists")
f_exists (x:xs) (EApp p name x1) = if funcName x == name then Ok else f_exists xs (EApp p name x1)

-- pobranie type zwracanej wartosci i przyjmowanej (zakladamy ze istnieje)
check_fun :: [FunctionDef p] -> FSym -> (Type,Type)
check_fun (x:xs) f_t = if funcName x == f_t then (funcArgType x, funcResType x)
                       else check_fun xs f_t
-- pobranie funkcji z listy
get_fun :: [FunctionDef p] -> FSym -> FunctionDef p
get_fun [] name     = undefined
get_fun (x:xs) name = if funcName x == name then x else get_fun xs name

-- typecheck ktory musi byc typu bool
-- mozna to wpisac do get_type ale dzialalo by tak samo, a jest duzo przepisywania
typecheck_bool :: [FunctionDef p] -> [(Var,Type)] -> Expr p -> TypeCheckResult p
typecheck_bool flist x (EBool p bool) = Ok
typecheck_bool flist x (EVar p var)   = case check_type x TBool (EVar p var) of
                                        Error p msg -> Error p msg
                                        Ok          -> Ok
typecheck_bool flist x (EUnary  p UNot (p1))      = case typecheck_bool flist x p1 of
                                                    Error p msg -> Error p msg
                                                    Ok          -> Ok
typecheck_bool flist x (EBinary p BAnd (p1) (p2)) = case typecheck_bool flist x p1 of
                                                    Error p msg -> Error p msg
                                                    _           -> case typecheck_bool flist x p2 of
                                                                   Error p msg -> Error p msg
                                                                   Ok          -> Ok
typecheck_bool flist x (EBinary p BOr  (p1) (p2)) = case typecheck_bool flist x p1 of
                                                    Error p msg -> Error p msg
                                                    _           -> case typecheck_bool flist x p2 of
                                                                   Error p msg -> Error p msg
                                                                   Ok          -> Ok
typecheck_bool flist x (EBinary p BLt  (p1) (p2)) = case typecheck_int flist x p1 of
                                                    Error p msg -> Error p msg
                                                    _           -> case typecheck_int flist x p2 of
                                                                   Error p msg -> Error p msg
                                                                   Ok          -> Ok
typecheck_bool flist x (EBinary p BGt  (p1) (p2)) = case typecheck_int flist x p1 of
                                                    Error p msg -> Error p msg
                                                    _           -> case typecheck_int flist x p2 of
                                                                   Error p msg -> Error p msg
                                                                   Ok          -> Ok
typecheck_bool flist x (EBinary p BLe  (p1) (p2)) = case typecheck_int flist x p1 of
                                                    Error p msg -> Error p msg
                                                    _           -> case typecheck_int flist x p2 of
                                                                   Error p msg -> Error p msg
                                                                   Ok          -> Ok
typecheck_bool flist x (EBinary p BGe  (p1) (p2)) = case typecheck_int flist x p1 of
                                                    Error p msg -> Error p msg
                                                    _           -> case typecheck_int flist x p2 of
                                                                   Error p msg -> Error p msg
                                                                   Ok          -> Ok

typecheck_bool flist x (EBinary p BEq  (p1) (p2)) = case typecheck_int flist x p1 of
                                                    Error p msg -> Error p msg
                                                    _           -> case typecheck_int flist x p2 of
                                                                   Error p msg -> Error p msg
                                                                   Ok          -> Ok
typecheck_bool flist x (EBinary p BNeq  (p1) (p2)) = case typecheck_int flist x p1 of
                                                     Error p msg -> Error p msg
                                                     _           -> case typecheck_int flist x p2 of
                                                                    Error p msg -> Error p msg
                                                                    Ok          -> Ok

typecheck_bool flist x (EIf p (p1) (p2) (p3)) = case typecheck_bool flist x p1 of
                                                Error p msg -> Error p msg
                                                _           -> case typecheck_bool flist x p2 of
                                                       Error p msg -> Error p msg
                                                       _           -> case typecheck_bool flist x p3 of
                                                                      Error p msg -> Error p msg
                                                                      Ok         -> Ok
typecheck_bool flist x (ELet p var (p1) (p2)) = case get_type flist x (p1) of
                                                (_,Error p msg) -> Error p msg
                                                (t,Ok)      -> case typecheck_bool flist ((var,t):x) p2 of
                                                               Error p msg -> Error p msg     
                                                               Ok          -> Ok
typecheck_bool flist x (EApp p name (p1)) = case get_type flist x (EApp p name (p1)) of
                                           (_,Error p msg) -> Error p msg
                                           (TBool,Ok)      -> Ok
                                           (_,Ok)          -> Error p "Function must return bool value"
typecheck_bool flist x (EFst p (p1)) = case get_type flist x (EFst p (p1)) of
                                      (_,Error p msg) -> Error p msg
                                      (TBool,Ok)      -> Ok
                                      (_,Ok)          -> Error p "Must be bool value"
typecheck_bool flist x (ESnd p (p1)) = case get_type flist x (ESnd p (p1)) of
                                      (_,Error p msg) -> Error p msg
                                      (TBool,Ok)      -> Ok
                                      (_,Ok)          -> Error p "Must be bool value"
typecheck_bool flist x (EMatchL p (p1)(p2)(p3)) = case get_type flist x (EMatchL p (p1)(p2)(p3)) of
                                                 (_,Error p msg) -> Error p msg
                                                 (TBool,Ok)      -> Ok
                                                 (_,Ok)          -> Error p "Must be bool value"
typecheck_bool _ _ prog = Error pr "Must be bool expression" where pr = getData prog 

typecheck_pair :: Expr p -> Expr p -> (TypeCheckResult p, Expr p)
typecheck_pair (EFst p _) (EPair p' (p1) (p2)) = (Ok, p1)
typecheck_pair (ESnd p _) (EPair p' (p1) (p2)) = (Ok, p2)
typecheck_pair _ prog = (Error pr "Require pair type variable", undefined) where pr = getData prog

typecheck_int :: [FunctionDef p] -> [(Var,Type)] -> Expr p -> TypeCheckResult p
typecheck_int flist x (ENum p const) = Ok
typecheck_int flist x (EVar p var) = case check_type x TInt (EVar p var) of
                                     Error p msg -> Error p msg
                                     Ok          -> Ok
typecheck_int flist x (EUnary  p UNeg (p1))      = case typecheck_int flist x p1 of
                                                   Error p msg -> Error p msg
                                                   Ok          -> Ok
typecheck_int flist x (EBinary p BAdd (p1) (p2)) = case typecheck_int flist x p1 of
                                                   Error p msg -> Error p msg
                                                   _           -> case typecheck_int flist x p2 of
                                                                  Error p msg -> Error p msg
                                                                  Ok          -> Ok
typecheck_int flist x (EBinary p BSub (p1) (p2)) = case typecheck_int flist x p1 of
                                                   Error p msg -> Error p msg
                                                   _           -> case typecheck_int flist x p2 of
                                                                  Error p msg -> Error p msg
                                                                  Ok          -> Ok
typecheck_int flist x (EBinary p BMul (p1) (p2)) = case typecheck_int flist x p1 of
                                                   Error p msg -> Error p msg
                                                   _           -> case typecheck_int flist x p2 of
                                                                  Error p msg -> Error p msg
                                                                  Ok          -> Ok
typecheck_int flist x (EBinary p BDiv (p1) (p2)) = case typecheck_int flist x p1 of
                                                   Error p msg -> Error p msg
                                                   _           -> case typecheck_int flist x p2 of
                                                                  Error p msg -> Error p msg
                                                                  Ok          -> Ok
typecheck_int flist x (EBinary p BMod (p1) (p2)) = case typecheck_int flist x p1 of
                                             Error p msg -> Error p msg
                                             _           -> case typecheck_int flist x p2 of
                                                            Error p msg -> Error p msg
                                                            Ok -> Ok

typecheck_int flist x (ELet p var (p1) (p2)) = case get_type flist x (p1) of
                                                (_,Error p msg) -> Error p msg
                                                (t,Ok)      -> case typecheck_int flist ((var,t):x) p2 of
                                                               Error p msg -> Error p msg     
                                                               Ok          -> Ok
typecheck_int flist x (EIf p (p1) (p2) (p3))     = case typecheck_bool flist x p1 of
                                                 Error p msg -> Error p msg
                                                 _           -> case typecheck_int flist x p2 of
                                                                Error p msg -> Error p msg
                                                                _           -> case typecheck_int flist x p3 of
                                                                               Error p msg -> Error p msg
                                                                               Ok          -> Ok
typecheck_int flist x (EApp p name (p1)) = case get_type flist x (EApp p name (p1)) of
                                           (_,Error p msg) -> Error p msg
                                           (TInt,Ok)       -> Ok
                                           (_,Ok)          -> Error p "Function must return int value"
typecheck_int flist x (EFst p (p1)) = case get_type flist x (EFst p (p1)) of
                                      (_,Error p msg) -> Error p msg
                                      (TInt,Ok)       -> Ok
                                      (_,Ok)          -> Error p "Must be int value"
typecheck_int flist x (ESnd p (p1)) = case get_type flist x (ESnd p (p1)) of
                                      (_,Error p msg) -> Error p msg
                                      (TInt,Ok)       -> Ok
                                      (_,Ok)          -> Error p "Must be int value"
typecheck_int flist x (EMatchL p (p1)(p2)(p3)) = case get_type flist x (EMatchL p (p1)(p2)(p3)) of
                                                 (_,Error p msg) -> Error p msg
                                                 (TInt,Ok)       -> Ok
                                                 (_,Ok)          -> Error p "Must be int value"
typecheck_int _ _ prog = Error pr "Must be int value" where pr = getData prog
-- zwraca typ podanego wyrazenia lub blad
get_type :: [FunctionDef p] -> [(Var,Type)] -> Expr p -> (Type, TypeCheckResult p) 
get_type flist x (ENum p val) = (TInt,Ok)
get_type flist x (EBool p val) = (TBool,Ok)
get_type flist x (EUnary p op (p1)) = case typecheck_int flist x (EUnary p op (p1)) of
                                      Error p msg -> case typecheck_bool flist x (EUnary p op (p1)) of
                                                     Error p msg -> (undefined,Error p msg)
                                                     Ok          -> (TBool,Ok)
                                      Ok          -> (TInt,Ok)
get_type flist x (EBinary p op (p1)(p2)) = case typecheck_int flist x (EBinary p op (p1)(p2)) of
                                           Error p msg -> case typecheck_bool flist x (EBinary p op (p1)(p2)) of
                                                          Error p msg -> (undefined,Error p msg)
                                                          Ok          -> (TBool,Ok)
                                           Ok          -> (TInt,Ok)
get_type flist x (EVar p var) = case v_t of 
                                (_,Error p msg) -> (undefined, Error p msg)
                                (t,Ok)          -> (t,Ok)
                                where v_t = get_var_type x (EVar p var)
get_type flist x (ELet p var (p1) (p2)) = case get_type flist x p1 of
                                          (_,Error p msg) -> (undefined,Error p msg)
                                          (t,Ok)           -> case get_type flist ((var,t):x) p2 of
                                                             (_,Error p msg) -> (undefined,Error p msg)
                                                             (t',Ok)         -> (t',Ok)
get_type flist x (EIf p (p1) (p2) (p3)) = case typecheck_bool flist x p1 of 
                                          Error p msg -> (undefined,Error p msg)
                                          Ok          -> case get_type flist x p2 of
                                                         (_,Error p msg) -> (undefined,Error p msg)
                                                         (t,Ok)          -> case get_type flist x p3 of
                                                                    (_,Error p msg) -> (undefined,Error p msg)
                                                                    (t',Ok)         -> if t == t' then (t,Ok)
                                                                                        else (undefined,Error p "if returns diffrent types")
get_type flist x (EApp p name (p1))  = case f_exists flist (EApp p name (p1)) of
                                       Error p msg -> (undefined,Error p msg)
                                       Ok          -> case fst(check_fun flist name) of
                                                      t -> case get_type flist x p1 of 
                                                           (_,Error p msg) -> (undefined,Error p msg)
                                                           (t',Ok)         -> if (t == t') then (snd(check_fun flist name),Ok)
                                                                              else (undefined,Error p "Wrong argument type for function")
get_type flist x (EUnit p) = (TUnit, Ok)
get_type flist x (EPair p (p1) (p2)) = case get_type flist x p1 of
                                       (_,Error p msg) -> (undefined,Error p msg)
                                       (t,Ok)          -> case get_type flist x p2 of
                                                          (_,Error p msg) -> (undefined,Error p msg)
                                                          (t',Ok)         -> ((TPair t t'),Ok)
get_type flist x (EFst p (p1)) = case get_type flist x p1 of
                                 (_,Error p msg) -> (undefined,Error p msg)
                                 (TPair t t',Ok) -> (t,Ok)
                                 (_,Ok)          -> (undefined,Error p "fst must be applied to pair")
get_type flist x (ESnd p (p1)) = case get_type flist x p1 of
                                 (_,Error p msg) -> (undefined,Error p msg)
                                 (TPair t t',Ok) -> (t',Ok)
                                 (_,Ok)          -> (undefined,Error p "snd must be applied to pair")
get_type flist x (ENil p (TList t)) = (TList t,Ok)
get_type flist x (ECons p (p1)(p2)) = case get_type flist x p1 of
                                      (_,Error p msg) -> (undefined,Error p msg)
                                      (t,Ok)          -> case get_type flist x p2 of
                                                         (_,Error p msg) -> (undefined,Error p msg)
                                                         ((TList t'),Ok) -> if(t == t') then ((TList t),Ok)
                                                         else (undefined,Error p "list contains diffrent types")        
                                                         (_,_)   -> (undefined,Error p "type error")
                                                         -- przypadki jak []:int*int list
get_type flist x (EMatchL p (list)(empty)(var,sublist,(n_empty))) = case get_type flist x list of
                                  (_,Error p msg)   -> (undefined,Error p msg)
                                  (TList t_list,Ok) -> case get_type flist x empty of
                                           (_,Error p msg) -> (undefined,Error p msg)
                                           (t,Ok)          -> case get_type flist ((var,t_list):(sublist,TList t_list):x) n_empty of
                                                              (_,Error p msg) -> (undefined,Error p msg)
                                                              (t',Ok)         -> if (t == t') then (t,Ok)
                                                                                 else (undefined,Error p "match returns diffrent types")                 
                                  (_,Ok)            -> (undefined,Error p "'match' accepts only list types")
-- takie przypadki jak []:int
get_type flist x prog = (undefined,Error pr "Wrong list") where pr = getData prog

eval :: [FunctionDef p] -> [(Var,Integer)] -> Expr p -> EvalResult
eval flist items expr = case eval' flist (map map_var items) expr of
                        Just (VInt val) -> Value val
                        _               -> RuntimeError
-- zamiana zmiennych wejsciwych na wlasny typ
map_var :: (Var,Integer) -> (Var,Value)
map_var (x,y) = (x,VInt y)

-- pobranie wartosci zmiennej
get_value :: [(Var,Value)] -> Var -> Value
get_value ((x,y):xs) var = if var == x then y
                           else get_value xs var

eval' :: [FunctionDef p] -> [(Var,Value)] -> Expr p -> Maybe Value
eval' flist x (EVar p var)         = Just(get_value x var)
eval' flist x (ENum p val)         = Just(VInt val)
eval' flist x (EBool p bool)       = Just(VBool bool)
eval' flist x (EUnary p UNot (p1)) = case eval' flist x p1 of
                                     Just(VBool bval) -> Just(VBool (not bval))
                                     _                -> Nothing 
eval' flist x (EUnary p UNeg (p1)) = case eval' flist x p1 of
                                     Just(VInt val) -> Just(VInt (-val))
                                     _              -> Nothing           
eval' flist x (EBinary p BAdd (p1)(p2)) = case eval' flist x p1 of
                                          Just(VInt val1) -> case eval' flist x p2 of
                                                             Just(VInt val2) -> Just(VInt (val1 + val2))
                                                             _               -> Nothing
                                          _               -> Nothing
eval' flist x (EBinary p BSub (p1)(p2)) = case eval' flist x p1 of
                                        Just(VInt val1) -> case eval' flist x p2 of
                                                           Just(VInt val2) -> Just(VInt (val1 - val2))
                                                           _               -> Nothing
                                        _               -> Nothing 
eval' flist x (EBinary p BMul (p1)(p2)) = case eval' flist x p1 of
                                        Just(VInt val1) -> case eval' flist x p2 of
                                                           Just(VInt val2) -> Just(VInt (val1 * val2))
                                                           _               -> Nothing
                                        _               -> Nothing 

eval' flist x (EBinary p BDiv (p1)(p2)) = case eval' flist x p1 of
                                          Just(VInt val1) -> case eval' flist x p2 of
                                                             Just(VInt 0)    -> Nothing
                                                             Just(VInt val2) -> Just(VInt (val1 `div` val2))
                                                             _               -> Nothing
                                          _               -> Nothing                  
eval' flist x (EBinary p BMod (p1)(p2)) = case eval' flist x p1 of
                                          Just(VInt val1) -> case eval' flist x p2 of
                                                             Just(VInt 0)    -> Nothing
                                                             Just(VInt val2) -> Just(VInt (val1 `mod` val2))
                                                             _               -> Nothing
                                          _               -> Nothing
eval' flist x (EBinary p BAnd (p1)(p2)) = case eval' flist x p1 of
                                          Just(VBool val1) -> case eval' flist x p2 of
                                                              Just(VBool val2) -> Just(VBool (val1 && val2))
                                                              _                -> Nothing
                                          _                -> Nothing
eval' flist x (EBinary p BOr (p1)(p2))  = case eval' flist x p1 of
                                          Just(VBool val1) -> case eval' flist x p2 of
                                                              Just(VBool val2) -> Just(VBool (val1 || val2))
                                                              _                -> Nothing
                                          _                -> Nothing
eval' flist x (EBinary p BEq (p1)(p2))  = case eval' flist x p1 of
                                          Just(VInt val1) -> case eval' flist x p2 of
                                                             Just(VInt val2) -> Just(VBool (val1 == val2))
                                                             _               -> Nothing
                                          _                -> Nothing
eval' flist x (EBinary p BNeq (p1)(p2)) = case eval' flist x p1 of
                                          Just(VInt val1) -> case eval' flist x p2 of
                                                             Just(VInt val2) -> Just(VBool (val1 /= val2))
                                                             _               -> Nothing
                                          _                -> Nothing
eval' flist x (EBinary p BLt (p1)(p2))  = case eval' flist x p1 of
                                          Just(VInt val1) -> case eval' flist x p2 of
                                                             Just(VInt val2) -> Just(VBool (val1 < val2))
                                                             _               -> Nothing
                                          _                -> Nothing
eval' flist x (EBinary p BGt (p1)(p2))  = case eval' flist x p1 of
                                          Just(VInt val1) -> case eval' flist x p2 of
                                                             Just(VInt val2) -> Just(VBool (val1 > val2))
                                                             _               -> Nothing
                                          _                -> Nothing
eval' flist x (EBinary p BLe (p1)(p2))  = case eval' flist x p1 of
                                          Just(VInt val1) -> case eval' flist x p2 of
                                                             Just(VInt val2) -> Just(VBool (val1 <= val2))
                                                             _               -> Nothing
                                          _                -> Nothing
eval' flist x (EBinary p BGe (p1)(p2))  = case eval' flist x p1 of
                                          Just(VInt val1) -> case eval' flist x p2 of
                                                             Just(VInt val2) -> Just(VBool (val1 >= val2))
                                                             _               -> Nothing
                                          _                -> Nothing
eval' flist x (ELet p var (p1)(p2)) = case eval' flist x p1 of
                                      Just(value) -> eval' flist ((var,value):x) p2
                                      _           -> Nothing
eval' flist x (EIf p (p1)(p2)(p3))  = case eval' flist x p1 of
                                      Just(VBool True)  -> eval' flist x p2
                                      Just(VBool False) -> eval' flist x p3
                                      _                 -> Nothing
eval' flist x (EApp p name (p1)) = case eval' flist x p1 of
                                   Just(value) -> eval' flist [((funcArg fun),value)] (funcBody fun)
                                   _           -> Nothing
                                   where fun = get_fun flist name
eval' flist x (EUnit p) = Just(VUnit)
eval' flist x (EPair p (p1)(p2)) = case eval' flist x p1 of
                                   Just(value) -> case eval' flist x p2 of
                                                  Just(value') -> Just(VPair value value')
                                                  _            -> Nothing 
                                   _           -> Nothing         
eval' flist x (EFst p (p1)) = case eval' flist x p1 of
                              Just(VPair v1 v2) -> Just(v1)
                              _                 -> Nothing 
eval' flist x (ESnd p (p1)) = case eval' flist x p1 of
                              Just(VPair v1 v2) -> Just(v2)
                              _                 -> Nothing
eval' flist x (ENil p t) = Just(VList [])
eval' flist x (ECons p (p1)(p2)) = case eval' flist x p1 of
                                   Just(value) -> case eval' flist x p2 of
                                                  Just(VList l) -> Just(VList(value:l))
                                                  _             -> Nothing
                                   _           -> Nothing
eval' flist x (EMatchL p (p1)(empty)(var,var',n_empty)) = case eval' flist x p1 of
                                   Just(VList [])     -> eval' flist x empty
                                   Just(VList (y:ys)) -> eval' flist ((var,y):(var',VList ys):x) n_empty
                                   -- to be safe
                                   _                  -> Nothing




