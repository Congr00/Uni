type ty =
  | TyBool
  | TyNat
  | TyArr of ty * ty
  | TyUnit

type term =
  (* Singletons *)
  | TmUnit
  | TmBool    of bool
  | TmNat     of int
  (* Misc *)
  | TmLambda  of string * ty * term
  | TmApp     of term * term
  | TmApplied of (term list) (* for TmApp chains *)
  | TmIf      of term * term * term
  | TmFix     of term
  | TmVar     of string
  (* terms for all arithmetic and boolean operators *)
  | TmEq  of term * term
  | TmMul of term * term
  | TmSub of term * term
  | TmAdd of term * term
  | TmAnd of term * term
  | TmDiv of term * term
  | TmOr  of term * term
  | TmNeq of term * term
  | TmNot of term
  | TmLs  of term * term
  | TmGt  of term * term
  | TmLq  of term * term
  | TmGq  of term * term
  (* Exception terms *) 
  | TmEx     of string * ty * term
  | TmThrow  of string * term * ty
  | TmTCatch of term * ((string * string * term) list)

type typebind =
  | NameBind
  | VarBind of ty

type termbind =
  | TermEmpty
  | TermBind of term

type term_ext = 
  | Result of term
  | Error of string * term

let (>>=) res f = match res with
  | Result r -> f r
  | err -> err

exception TypingError of string
exception EvaluatorError of string
exception Unreachable of string

let unreachable func_name = raise (Unreachable func_name)

let getVbinding context name  = List.find_opt (fun (x, _, _) -> x = name) context
let getEbinding econtext name = List.find_opt (fun x -> (fst x)   = name) econtext

let addVbinding context name t trm = (name, t, trm)::context
let addEbinding econtext name t    = (name, t)::econtext

let getTypeFromContext context name = match getVbinding context xname with
  | Some(_, VarBind(t), _) -> t
  | _ -> raise (TypingError ("Couldn't find variable: " ^ name))

let getExTypeFromContext econtext name = match getEbinding econtext name with
  | Some(_, t) -> t
  | _ -> raise (TypingError ("Error with name: `" ^ name ^ "` does not exist"))



let rec type_interference c ec t =
  match t with
  | TmBool _ -> TyBool
  | TmNat  _ -> TyNat
  | TmUnit   -> TyUnit
  (* Natural expression *)
  | TmSub (t1, t2) -> check_bi_type c ec t1 t2 TyNat TyNat   "Not natural numbers for substraction"
  | TmAdd (t1, t2) -> check_bi_type c ec t1 t2 TyNat TyNat   "Not natural numbers for addition"
  | TmMul (t1, t2) -> check_bi_type c ec t1 t2 TyNat TyNat   "Not natural numbers for multiplication"
  | TmDiv (t1, t2) -> check_bi_type c ec t1 t2 TyNat TyNat   "Not natural numbers for division"
  (* Boolean expressions *)
  | TmEq  (t1, t2) -> check_bi_type c ec t1 t2 (type_interference c ec t1) TyBool "Types for equal differ"
  | TmOr  (t1, t2) -> check_bi_type c ec t1 t2 TyBool TyBool "Need boolean values for `or` operator"
  | TmAnd (t1, t2) -> check_bi_type c ec t1 t2 TyBool TyBool "Need boolean values for `and` operator"
  | TmLs  (t1, t2) -> check_bi_type c ec t1 t2 TyNat TyBool  "Need natural values for `<` operator"
  | TmGt  (t1, t2) -> check_bi_type c ec t1 t2 TyNat TyBool  "Need natural values for `>` operator"
  | TmNeq (t1, t2) -> check_bi_type c ec t1 t2 (type_interference c ec t1) TyBool "Types for `~=` differ"
  | TmLq  (t1, t2) -> check_bi_type c ec t1 t2 TyNat TyBool  "Need natural values for `<=` operator"
  | TmGq  (t1, t2) -> check_bi_type c ec t1 t2 TyNat TyBool  "Need natural values for `>=` operator"
  | TmNot (t) -> if type_interference c ec t = TyBool then TyBool
                 else raise(TypingError "Need boolean value for `not` operator")
  (* Misc *)
  | TmIf(t1,t2,t3) -> if (=) (type_interference c ec t1) TyBool then 
                        let type2 = type_interference c ec t2 in if (=) type2 (type_interference c ec t3) then type2
                                                                 else raise (TypingError "arms of conditional have different types")
                      else raise (TypingError "guard of conditional not a boolean")
  | TmVar name -> getTypeFromContext c name
  | TmLambda(x,type1,t2) -> TyArr (type1, type_interference (addVbinding c x (VarBind type1) TermEmpty) ec t2)
  | TmApp(t1,t2) -> let type1 = type_interference c ec t1 in 
                    let type2 = type_interference c ec t2 in
                      (match type1 with
                        TyArr (type1', type2') -> if (=) type2 type1' then type2'
                                                  else raise (TypingError "Paremeters in arrow does not match")
                        | _ -> raise (TypingError "Arrow have unknown type"))
  | TmFix func -> (match type_interference c ec func with
    | TyArr (type1, type2) -> if type1 = type2 then (match type1 with
                                              | TyArr (_, _) -> type1
                                              | _ -> raise (TypingError "Wrong argument for fix"))
                              else raise (TypingError "Wrong argument for fix"))
  (* Error handling *)
  | TmThrow (name, t, type1) -> if getExTypeFromContext ec name = type_interference c ec t then type1
                                else raise(TypingError "wrong argument type under exception throw")
  | TmEx (name, t, trm) -> type_interference c (addEbinding ec name t) trm
  | TmTCatch (t, lst) -> let type1 = type_interference c ec t in
        if List.for_all (fun x -> x = type1) (List.map (check_catch_type c ec) lst) then type1
        else raise (TypingError "try and catch outputs must have the same type")
and check_catch_type c ec catch = let (ex_name, var_name, t) = catch in
      type_interference (addVbinding c var_name (VarBind (getExTypeFromContext ec ex_name)) TermEmpty) ec t
and check_bi_type c ec trm1 trm2 t res msg = if (type_interference c ec trm1 = t) && (type_interference c ec trm2 = t) then res
                                             else raise (TypingError msg)



let rec whnf t c = match t with
  (* Singletons *)
  | TmUnit   -> Result t
  | TmBool _ -> Result t
  | TmNat n  -> if n < 0 then Result (TmNat 0) else Result (TmNat n)
  (* Natural expression *)
  | TmMul (t1, t2) -> whnf t1 c >>= fun (TmNat r1 ) -> whnf t2 c >>= fun (TmNat r2) -> Result(TmNat (r1 * r2))
  | TmSub (t1, t2) -> whnf t1 c >>= fun (TmNat r1 ) -> whnf t2 c >>= fun (TmNat r2) -> Result(TmNat (max 0 (r1 - r2)))
  | TmAdd (t1, t2) -> whnf t1 c >>= fun (TmNat r1 ) -> whnf t2 c >>= fun (TmNat r2) -> Result(TmNat (r1 + r2))
  | TmDiv (t1, t2) -> whnf t1 c >>= fun (TmNat r1 ) -> whnf t2 c >>= fun (TmNat r2) -> Result(TmNat (r1 / r2))
  (* Boolean expressions *)
  | TmAnd (t1, t2) -> whnf t1 c >>= fun (TmBool r1 ) -> whnf t2 c >>= fun (TmBool r2) -> Result(TmBool (r1 && r2))
  | TmOr  (t1, t2) -> whnf t1 c >>= fun (TmBool r1 ) -> whnf t2 c >>= fun (TmBool r2) -> Result(TmBool (r1 || r2))
  | TmLs  (t1, t2) -> whnf t1 c >>= fun (TmBool r1 ) -> whnf t2 c >>= fun (TmBool r2) -> Result(TmBool (r1 < r2))
  | TmGt  (t1, t2) -> whnf t1 c >>= fun (TmBool r1 ) -> whnf t2 c >>= fun (TmBool r2) -> Result(TmBool (r1 > r2))
  | TmEq  (t1, t2) -> whnf t1 c >>= fun r1           -> whnf t2 c >>= fun r2          -> Result(TmBool (r1 = r2))
  | TmNot (t1)     -> whnf t1 c >>= fun (TmBool r1 ) -> Result(TmBool (not r1))
  | TmNeq (t1, t2) -> whnf (TmNot(TmEq (t1, t2))) c 
  | TmLq  (t1, t2) -> whnf (TmOr(TmLs (t1, t2), TmEq(t1, t2))) c
  | TmGq  (t1, t2) -> whnf (TmOr(TmGt (t1, t2), TmEq(t1, t2))) c
  (* Misc *)
  | TmApp (TmApp (t1, t2), TmApplied lst) -> whnf (TmApp (t1, TmApplied (t2 :: lst))) c
  | TmApp (TmApp (t1, t2), t3) -> whnf (TmApp (t1, TmApplied [t2; t3])) c
  | TmApp (TmFix (TmLambda (name, _, t1)), t2) -> whnf (TmApp (t1, t2)) (addVbinding c name NameBind (TermBind t1))
  | TmApp (TmLambda (name, type1, t1), TmApplied (h::[])) -> whnf (TmApp ((TmLambda (name, type1, t1)), h)) c
  | TmApp (TmLambda (name, type1, t1), TmApplied (h::t))  -> whnf h c >>= fun r -> whnf (TmApp (t1, TmApplied t)) (addVbinding c name NameBind (TermBind r))
  | TmApp (TmLambda(name, _, t1), t2) -> whnf t2 c >>= fun r -> whnf t1 (addVbinding c name NameBind (TermBind r))
  | TmApp (t1, t2) -> whnf t2 c >>= fun r2 -> whnf t1 c >>= fun r1 -> whnf (TmApp (r1, r2)) c
  | TmApplied _ -> Result t
  | TmIf  (t1, t2, t3) -> whnf t1 c >>= fun r  -> if r = (TmBool true) then whnf t2 c else whnf t3 c
  | TmLambda _ -> Result (fill_variables t c)
  | TmFix _    -> Result (fill_variables t c)
  | TmVar name -> (match getVbinding c name with
    | Some (_, _, TermBind t') -> whnf t' c
    | _ -> raise (EvaluatorError "out of bounds variable"))
  (* Error handling *)
  | TmThrow (name, t, _) -> whnf t c >>= fun r -> Error (name, r)
  | TmEx  (name, _, t) -> whnf t c
  | TmTCatch (t, lcatch) -> (match whnf t c with
    | Error (name, t) -> (match List.find_opt (fun (ex_name, _, _) -> ex_name = name) lcatch with
      | Some (_, var_name, t') -> whnf t' (addVbinding c var_name NameBind (TermBind t))
      | None -> Error (name, t))
    | res -> res)
(* add values to unassigned variables inside lambda/fix terms *)
and fill_variables t c = match t with
  (* Singletons *)
  | TmUnit   -> t
  | TmBool _ -> t
  | TmNat  _ -> t
  (* Natural expression *)
  | TmMul   (t1, t2) -> TmMul (fill_variables t1 c, fill_variables t2 c)
  | TmDiv   (t1, t2) -> TmDiv (fill_variables t1 c, fill_variables t2 c)
  | TmSub   (t1, t2) -> TmSub (fill_variables t1 c, fill_variables t2 c)
  | TmAdd   (t1, t2) -> TmAdd (fill_variables t1 c, fill_variables t2 c)
  (* Boolean expressions *)
  | TmEq    (t1, t2) -> TmEq  (fill_variables t1 c, fill_variables t2 c)
  | TmOr    (t1, t2) -> TmOr  (fill_variables t1 c, fill_variables t2 c)
  | TmAnd   (t1, t2) -> TmAnd (fill_variables t1 c, fill_variables t2 c)
  | TmNot   (t)      -> TmNot (fill_variables t c)
  | TmLs    (t1, t2) -> TmLs  (fill_variables t1 c, fill_variables t2 c)
  | TmGt    (t1, t2) -> TmGt  (fill_variables t1 c, fill_variables t2 c)
  | TmNeq   (t1, t2) -> TmNeq (fill_variables t1 c, fill_variables t2 c)
  | TmLq    (t1, t2) -> TmLq  (fill_variables t1 c, fill_variables t2 c)
  | TmGq    (t1, t2) -> TmGq  (fill_variables t1 c, fill_variables t2 c)
  (* Misc *)
  | TmLambda (name, tp1, t1) -> TmLambda (name, tp1, fill_variables t1 (addVbinding c name NameBind TermEmpty))
  | TmFix t1       -> TmFix (fill_variables t1 c)
  | TmApp (t1, t2) -> TmApp (fill_variables t1 c, fill_variables t2 c)
  | TmVar name -> (match getVbinding c name with
      | Some (_, _, TermEmpty)   -> t
      | Some (_, _, TermBind t') -> t'
      | _ -> raise (EvaluatorError "out of bounds variable"))
  | TmIf (t1, t2, t3) -> TmIf (fill_variables t1 c, fill_variables t2 c, fill_variables t3 c)
  (* Exceptions *)
  | TmThrow (name, t, ty) -> TmThrow (name, fill_variables t c, ty)
  | TmEx    (name, ty, t) -> TmEx    (name, ty, fill_variables t c)
  | TmTCatch  (t, lcatch) -> TmTCatch  (fill_variables t c, List.map (fun (ex_name, var_name, t) -> (ex_name, var_name, fill_variables t c)) lcatch)

(* Sugar *)


let _let var type1 value terms = TmApp (TmLambda (var, type1, terms), value)
let _if t t1 t2   = TmIf (t, t1, t2)
let (!.) v t body = TmLambda (v, t, body)
let (=:) x y  = TmEq  (x,y)
let ( *:) x y = TmMul (x,y)
let ( +:) x y = TmAdd (x,y)
let ( -:) x y = TmSub (x,y)
let ( /:) x y = TmDiv (x,y)
let ( <:) x y = TmLs  (x,y)
let ( >:) x y = TmGt  (x,y)


let eval t = let _ = type_interference [] [] t in match whnf t [] with
  | Result r -> (r, type_interference [] [] t)
  | Error (name, t) -> raise (EvaluatorError "Unhandled exception during evaluation")

(* TESTS *)
(* power *)
let ( **) x y = _if (x =: TmNat 0) (TmNat 1)
                                     (_let "m" TyNat x
                                     (TmApp ((TmFix (!. "f" (TyArr (TyNat, TyNat)) (
                                       !. "x" TyNat (
                                         _if (TmVar "x" =: TmNat 0) (TmNat 1)
                                                            (TmVar "m" *: TmApp (TmVar "f", TmSub (TmVar "x", TmNat 1)))
                                       )
                                     ))), y)))
(* factorial *)
let fac k = TmApp(TmFix (!. "f" (TyArr (TyNat, TyNat)) (
                      !. "x" TyNat(
                        _if (TmVar "x" =: TmNat 0) (TmNat 1)
                                                   (TmVar "x" *: TmApp (TmVar "f", TmVar "x" -: TmNat 1))
                      )
                    )), k)

(* Program from exercise *)
let ex_test = TmEx("arithexc", TyUnit, _let "div" (TyArr (TyNat, TyArr (TyNat, TyNat))) 
                                      (!. "x" TyNat (
                                        !. "y" TyNat (
                                          _if (TmVar "y" =: TmNat 0) (TmThrow("arithexc", TmUnit, TyNat))
                                                                     (TmVar "x" /: TmVar "y")
                                        )
                                      ))
                                      (TmTCatch (TmApp(TmApp (TmVar "div", TmNat 64), TmNat 0), [("arithexc", "x", TmNat 42)])))
(* Unhandled exception *)
let ex_test_throw = TmEx ("fake", TyUnit, TmEx("arithexc", TyUnit, _let "div" (TyArr (TyNat, TyArr (TyNat, TyNat))) 
                                      (!. "x" TyNat (
                                        !. "y" TyNat (
                                          _if (TmVar "y" =: TmNat 0) (TmThrow("arithexc", TmUnit, TyNat))
                                                                     (TmVar "x" /: TmVar "y")
                                        )
                                      ))
                                      (TmTCatch (TmApp(TmApp (TmVar "div", TmNat 64), TmNat 0), [("fake", "x", TmNat 42)]))))


(* fibbonaci *)
let fibb n = TmApp(TmFix (!. "f" (TyArr (TyNat, TyNat)) (
                        !. "x" TyNat(
                          _if (TmVar "x" =: TmNat 1) (TmNat 1)
                            (_if (TmVar "x" =: TmNat 0) (TmNat 0) 
                                                        (TmApp (TmVar "f", TmVar "x" -: TmNat 2) +: TmApp (TmVar "f", TmVar "x" -: TmNat 1)))
                        )
                      )), n)