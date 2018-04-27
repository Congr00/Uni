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

typecheck :: [FunctionDef p] -> [Var] -> Expr p -> TypeCheckResult p
typecheck tbl x prog = let xr = (map input_int x) ++ (map input_fun tbl)
                   in case typecheck_int xr prog of
                      Error p msg -> Error p msg
                      Ok          -> fun_typecheck tbl xr

fun_typecheck :: [FunctionDef p] -> [(Var,Type)]  -> TypeCheckResult p
fun_typecheck [] flist     = Ok
fun_typecheck (x:xs) flist = case get_type (((funcArg x),(funcArgType x)):flist) (funcBody x) of
                            (_,Error p msg) -> Error p msg
                            (t,Ok)          -> if(t == (funcResType x)) then fun_typecheck xs flist
                                               else Error pr "Wrong return type" where pr = getData(funcBody x)

-- nadanie wejsciu wartosci Int
input_int :: Var -> (Var,Type)
input_int x = (x,TInt)
-- zamiana funkcji na zmienne
input_fun :: FunctionDef p -> (Var,Type)
input_fun x = (funcName x,TArrow (funcArgType x) (funcResType x))
--pobierz i zwroc wartosc zmiennej jesli istnieje    
get_var_type :: [(Var,Type)] -> Expr p -> (Type,TypeCheckResult p)
get_var_type [] (EVar p var)     = (undefined,Error p ("variable '" ++ var ++ "' not initialized"))
get_var_type (x:xs) (EVar p var) = if fst x == var then (snd x,Ok)
                               else get_var_type xs (EVar p var)

-- typecheck ktory musi byc typu bool
-- mozna to wpisac do get_type ale dzialalo by tak samo, a jest duzo przepisywania
typecheck_bool :: [(Var,Type)] -> Expr p -> TypeCheckResult p
typecheck_bool x (EBool p bool) = Ok
typecheck_bool x (EVar p var)   = case get_type x (EVar p var) of
                                        (_,Error p msg) -> Error p msg
                                        (TBool,Ok)      -> Ok
                                        (_,Ok)          -> Error p "variable must be bool type"
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
                                                                   Ok          -> Ok
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
typecheck_bool x (ELet p var (p1) (p2)) = case get_type x (p1) of
                                                (_,Error p msg) -> Error p msg
                                                (t,Ok)      -> case typecheck_bool ((var,t):x) p2 of
                                                               Error p msg -> Error p msg     
                                                               Ok          -> Ok
typecheck_bool x (EApp p (p1)(p2)) = case get_type x (EApp p (p1)(p2)) of
                                           (_,Error p msg) -> Error p msg
                                           (TBool,Ok)      -> Ok
                                           (_,Ok)          -> Error p "Function must return bool value"
typecheck_bool x (EFst p (p1)) = case get_type x (EFst p (p1)) of
                                      (_,Error p msg) -> Error p msg
                                      (TBool,Ok)      -> Ok
                                      (_,Ok)          -> Error p "Must be bool value"
typecheck_bool x (ESnd p (p1)) = case get_type x (ESnd p (p1)) of
                                      (_,Error p msg) -> Error p msg
                                      (TBool,Ok)      -> Ok
                                      (_,Ok)          -> Error p "Must be bool value"
typecheck_bool x (EMatchL p (p1)(p2)(p3)) = case get_type x (EMatchL p (p1)(p2)(p3)) of
                                                 (_,Error p msg) -> Error p msg
                                                 (TBool,Ok)      -> Ok
                                                 (_,Ok)          -> Error p "Must be bool value"
typecheck_bool x (EFn p var t (p1)) = case get_type x (EFn p var t (p1)) of
                                         (_,Error p msg) -> Error p msg
                                         (TBool,Ok)      -> Ok
                                         (_,Ok)          -> Error p "Must be bool value"

typecheck_bool _ prog = Error pr "Must be bool expression" where pr = getData prog 

typecheck_pair :: Expr p -> Expr p -> (TypeCheckResult p, Expr p)
typecheck_pair (EFst p _) (EPair p' (p1) (p2)) = (Ok, p1)
typecheck_pair (ESnd p _) (EPair p' (p1) (p2)) = (Ok, p2)
typecheck_pair _ prog = (Error pr "Require pair type variable", undefined) where pr = getData prog

typecheck_int :: [(Var,Type)] -> Expr p -> TypeCheckResult p
typecheck_int x (ENum p const) = Ok
typecheck_int x (EVar p var) = case get_type x (EVar p var) of
                                     (_,Error p msg) -> Error p msg
                                     (TInt,Ok)       -> Ok
                                     (_,Ok)          -> Error p "variable mus be int"
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

typecheck_int x (ELet p var (p1) (p2)) = case get_type x (p1) of
                                                (_,Error p msg) -> Error p msg
                                                (t,Ok)      -> case typecheck_int ((var,t):x) p2 of
                                                               Error p msg -> Error p msg     
                                                               Ok          -> Ok
typecheck_int x (EIf p (p1) (p2) (p3))     = case typecheck_bool x p1 of
                                                 Error p msg -> Error p msg
                                                 _           -> case typecheck_int x p2 of
                                                                Error p msg -> Error p msg
                                                                _           -> case typecheck_int x p3 of
                                                                               Error p msg -> Error p msg
                                                                               Ok          -> Ok
typecheck_int x (EApp p (p1)(p2)) = case get_type x (EApp p (p1)(p2)) of
                                           (_,Error p msg) -> Error p msg
                                           (TInt,Ok)       -> Ok
                                           (_,Ok)          -> Error p "Function must return int value"
typecheck_int x (EFst p (p1)) = case get_type x (EFst p (p1)) of
                                      (_,Error p msg) -> Error p msg
                                      (TInt,Ok)       -> Ok
                                      (_,Ok)          -> Error p "Must be int value"
typecheck_int x (ESnd p (p1)) = case get_type x (ESnd p (p1)) of
                                      (_,Error p msg) -> Error p msg
                                      (TInt,Ok)       -> Ok
                                      (_,Ok)          -> Error p "Must be int value"
typecheck_int x (EMatchL p (p1)(p2)(p3)) = case get_type  x (EMatchL p (p1)(p2)(p3)) of
                                                 (_,Error p msg) -> Error p msg
                                                 (TInt,Ok)       -> Ok
                                                 (_,Ok)          -> Error p "Must be int value"
typecheck_int x (EFn p var t (p1)) = case get_type x (EFn p var t (p1)) of
                                         (_,Error p msg) -> Error p msg
                                         (TInt,Ok)       -> Ok
                                         (_,Ok)          -> Error p "Must be int value"      
typecheck_int _ prog = Error pr "Must be int value" where pr = getData prog
-- zwraca typ podanego wyrazenia lub blad
get_type :: [(Var,Type)] -> Expr p -> (Type, TypeCheckResult p) 
get_type x (ENum p val) = (TInt,Ok)
get_type x (EBool p val) = (TBool,Ok)
get_type x (EUnary p op (p1)) = case typecheck_int x (EUnary p op (p1)) of
                                Error p msg -> case typecheck_bool x (EUnary p op (p1)) of
                                               Error p msg -> (undefined,Error p msg)
                                               Ok          -> (TBool,Ok)
                                Ok          -> (TInt,Ok)
get_type x (EBinary p op (p1)(p2)) = case typecheck_int x (EBinary p op (p1)(p2)) of
                                     Error p msg -> case typecheck_bool x (EBinary p op (p1)(p2)) of
                                                    Error p msg -> (undefined,Error p msg)
                                                    Ok          -> (TBool,Ok)
                                     Ok          -> (TInt,Ok)
get_type x (EVar p var) = case get_var_type x (EVar p var) of 
                          (_,Error p msg) -> (undefined,Error p msg)
                          (t,Ok)          -> (t,Ok)
get_type x (ELet p var (p1) (p2)) = case get_type x p1 of
                                    (_,Error p msg) -> (undefined,Error p msg)
                                    (t,Ok)          -> case get_type ((var,t):x) p2 of
                                                       (_,Error p msg) -> (undefined,Error p msg)
                                                       (t',Ok)         -> (t',Ok)
get_type x (EIf p (p1) (p2) (p3)) = case typecheck_bool x p1 of 
                                    Error p msg -> (undefined,Error p msg)
                                    Ok          -> case get_type x p2 of
                                                   (_,Error p msg) -> (undefined,Error p msg)
                                                   (t,Ok)          -> case get_type x p3 of
                                                               (_,Error p msg) -> (undefined,Error p msg)
                                                               (t',Ok)         -> if t == t' then (t,Ok)
                                                                                  else (undefined,Error p "if returns diffrent types")
get_type x (EFn p var t (p1)) = case get_type ((var,t):x) p1 of
                                (_,Error p msg) -> (undefined,Error p msg)
                                (t',Ok)          -> (TArrow t t',Ok)
get_type x (EApp p (p1)(p2))  = case get_type x p1 of
                                (_,Error p msg)  -> (undefined,Error p msg)
                                (TArrow t t',Ok) -> case get_type x p2 of
                                                    (t1,Ok)         -> if (t == t1) then (t',Ok)
                                                                       else (undefined,Error p "wrong fun app type")
                                                    (_,Error p msg) -> (undefined,Error p msg)
                                (t,Ok)           -> (undefined,Error p "wrong funcion")
get_type x (EUnit p) = (TUnit, Ok)
get_type x (EPair p (p1) (p2)) = case get_type x p1 of
                                 (_,Error p msg) -> (undefined,Error p msg)
                                 (t,Ok)          -> case get_type x p2 of
                                                    (_,Error p msg) -> (undefined,Error p msg)
                                                    (t',Ok)         -> ((TPair t t'),Ok)
get_type x (EFst p (p1)) = case get_type x p1 of
                           (_,Error p msg) -> (undefined,Error p msg)
                           (TPair t t',Ok) -> (t,Ok)
                           (_,Ok)          -> (undefined,Error p "fst must be applied to pair")
get_type x (ESnd p (p1)) = case get_type x p1 of
                          (_,Error p msg) -> (undefined,Error p msg)
                          (TPair t t',Ok) -> (t',Ok)
                          (_,Ok)          -> (undefined,Error p "snd must be applied to pair")
get_type x (ENil p (TList t)) = (TList t,Ok)
get_type x (ECons p (p1)(p2)) = case get_type x p1 of
                                (_,Error p msg) -> (undefined,Error p msg)
                                (t,Ok)          -> case get_type x p2 of
                                                   (_,Error p msg) -> (undefined,Error p msg)
                                                   ((TList t'),Ok) -> if(t == t') then ((TList t),Ok)
                                                                      else (undefined,Error p "list contains diffrent types")        
                                                   (_,_)   -> (undefined,Error p "type error")
                                                    -- przypadki jak []:int*int list
get_type x (EMatchL p (list)(empty)(var,sublist,(n_empty))) = case get_type x list of
                                  (_,Error p msg)   -> (undefined,Error p msg)
                                  (TList t_list,Ok) -> case get_type x empty of
                                           (_,Error p msg) -> (undefined,Error p msg)
                                           (t,Ok)          -> case get_type ((var,t_list):(sublist,TList t_list):x) n_empty of
                                                              (_,Error p msg) -> (undefined,Error p msg)
                                                              (t',Ok)         -> if (t == t') then (t,Ok)
                                                                                 else (undefined,Error p "match returns diffrent types")                 
                                  (_,Ok)            -> (undefined,Error p "'match' accepts only list types")
-- takie przypadki jak []:int
get_type x prog = (undefined,Error pr "Wrong list") where pr = getData prog

-- wlasny typ
data Value p = VInt Integer 
             | VBool Bool 
             | VPair (Value p) (Value p)
             | VList[Value p]
             | VUnit 
             | VArrow Var (Expr p) [(Var,Value p)]
             | VFun   Var (Expr p)

eval :: [FunctionDef p] -> [(Var,Integer)] -> Expr p -> EvalResult
eval flist items expr = case eval' ((map map_var items)++(map map_fun flist)) expr of
                        Just (VInt val) -> Value val
                        _               -> RuntimeError
-- zamiana zmiennych wejsciwych na wlasny typ
map_var :: (Var,Integer) -> (Var,Value p)
map_var (x,y) = (x,VInt y)
-- zamiana funkcji na zmienne
map_fun :: FunctionDef p -> (Var,Value p)
map_fun fun = (funcName fun, (VFun (funcArg fun) (funcBody fun)))

-- pobranie wartosci zmiennej
get_value :: [(Var,Value p)] -> Var -> Value p
get_value [] var = undefined -- nigdy nie powinno wejsc
get_value ((x,y):xs) var = if var == x then y
                           else get_value xs var
eval' :: [(Var,Value p)] -> Expr p -> Maybe (Value p)
eval' x (EVar p var)         = Just(get_value x var)
eval' x (ENum p val)         = Just(VInt val)
eval' x (EBool p bool)       = Just(VBool bool)
eval' x (EUnary p UNot (p1)) = case eval' x p1 of
                                     Just(VBool bval) -> Just(VBool (not bval))
                                     _                -> Nothing 
eval' x (EUnary p UNeg (p1)) = case eval' x p1 of
                               Just(VInt val) -> Just(VInt (-val))
                               _              -> Nothing           
eval' x (EBinary p BAdd (p1)(p2)) = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt val2) -> Just(VInt (val1 + val2))
                                                       _               -> Nothing
                                    _               -> Nothing
eval' x (EBinary p BSub (p1)(p2)) = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt val2) -> Just(VInt (val1 - val2))
                                                       _               -> Nothing
                                    _               -> Nothing 
eval' x (EBinary p BMul (p1)(p2)) = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt val2) -> Just(VInt (val1 * val2))
                                                       _               -> Nothing
                                    _               -> Nothing 
eval' x (EBinary p BDiv (p1)(p2)) = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt 0)    -> Nothing
                                                       Just(VInt val2) -> Just(VInt (val1 `div` val2))
                                                       _               -> Nothing
                                    _               -> Nothing                  
eval' x (EBinary p BMod (p1)(p2)) = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt 0)    -> Nothing
                                                       Just(VInt val2) -> Just(VInt (val1 `mod` val2))
                                                       _               -> Nothing
                                    _               -> Nothing
eval' x (EBinary p BAnd (p1)(p2)) = case eval' x p1 of
                                    Just(VBool val1) -> case eval' x p2 of
                                                        Just(VBool val2) -> Just(VBool (val1 && val2))
                                                        _                -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BOr (p1)(p2))  = case eval' x p1 of
                                    Just(VBool val1) -> case eval' x p2 of
                                                        Just(VBool val2) -> Just(VBool (val1 || val2))
                                                        _                -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BEq (p1)(p2))  = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt val2) -> Just(VBool (val1 == val2))
                                                       _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BNeq (p1)(p2)) = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt val2) -> Just(VBool (val1 /= val2))
                                                       _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BLt (p1)(p2))  = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt val2) -> Just(VBool (val1 < val2))
                                                       _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BGt (p1)(p2))  = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt val2) -> Just(VBool (val1 > val2))
                                                       _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BLe (p1)(p2))  = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt val2) -> Just(VBool (val1 <= val2))
                                                       _               -> Nothing
                                    _                -> Nothing
eval' x (EBinary p BGe (p1)(p2))  = case eval' x p1 of
                                    Just(VInt val1) -> case eval' x p2 of
                                                       Just(VInt val2) -> Just(VBool (val1 >= val2))
                                                       _               -> Nothing
                                    _                -> Nothing
eval' x (ELet p var (p1)(p2)) = case eval' x p1 of
                                Just(value) -> eval' ((var,value):x) p2
                                _           -> Nothing
eval' x (EIf p (p1)(p2)(p3))  = case eval' x p1 of
                                Just(VBool True)  -> eval' x p2
                                Just(VBool False) -> eval' x p3
                                _                 -> Nothing
eval' x (EFn p var t (p1))    = Just(VArrow var p1 x)
eval' x (EApp p (p1)(p2)) =  case eval' x p2 of
                             Just(value) -> case eval' x p1 of
                                            Just(VArrow var p' x') -> eval' ((var,value):x') p'
                                            Just(VFun var p')      -> eval' ((var,value):x) p'
                                            _                      -> Nothing
                             _           -> Nothing
eval' x (EUnit p) = Just(VUnit)
eval' x (EPair p (p1)(p2)) = case eval'  x p1 of
                             Just(value) -> case eval' x p2 of
                                            Just(value') -> Just(VPair value value')
                                            _            -> Nothing 
                             _           -> Nothing         
eval' x (EFst p (p1)) = case eval' x p1 of
                        Just(VPair v1 v2) -> Just(v1)
                        _                 -> Nothing 
eval' x (ESnd p (p1)) = case eval' x p1 of
                        Just(VPair v1 v2) -> Just(v2)
                        _                 -> Nothing
eval' x (ENil p t) = Just(VList [])
eval' x (ECons p (p1)(p2)) = case eval' x p1 of
                             Just(value) -> case eval' x p2 of
                                            Just(VList l) -> Just(VList(value:l))
                                            _             -> Nothing
                             _           -> Nothing
eval' x (EMatchL p (p1)(empty)(var,var',n_empty)) = case eval' x p1 of
                                   Just(VList [])     -> eval' x empty
                                   Just(VList (y:ys)) -> eval' ((var,y):(var',VList ys):x) n_empty
                                   -- to be safe
                                   _                  -> Nothing




