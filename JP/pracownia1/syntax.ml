open Format
open Support.Error
open Support.Pervasive

type term = 
  | Lambda of string * term
  | App of term * term
  | Var of int
  | Vars of string

type context = ctx_entry list
and ctx_entry =
  | CEmpty
  | CEntry of term * context

type stack = context 

type result = Result of term * stack

exception EvaluatorError of string

let rec take n s = match s with
  | (hd :: tl) when n != 0 -> hd :: take (n-1) tl
  | _ -> []

let rec peek_n s n = match s with
    | [] -> None
    | (h :: _) when n == 1 -> Some h
    | (_ :: t) -> peek_n t (n-1)
  
let take_stack (Result (_, s)) = s
let take_term (Result (t, _)) = t
    
let rec find_lambda l s acc = match l with
  | (h :: t) -> if h = s then acc else find_lambda t s (acc+1)
  | [] -> raise (EvaluatorError (Printf.sprintf "variable %s not found" s))

let generate_fresh_variable n = Printf.sprintf "_x%d" n


(*
let rec variable_to_church_ t l aux = match t with
  | Lambda (s, t) -> let (s', aux') = if s = "_EMPTY" then (generate_fresh_variable aux, aux+1) else (s, aux) in let (t', a') = variable_to_church_ t (s' :: l) (aux') in (Lambda (s', t'), a')
  | Vars s -> (Var (find_lambda l s 1), aux)
  | App (t1, t2) -> let (t3, a') = variable_to_church_ t1 l aux in let (t4, a'') = variable_to_church_ t2 l a' in (App(t3, t4), a'')
  | t' -> (t', aux)

let variable_to_church t = fst (variable_to_church_ t [] 0)

*)

let rec variable_to_church_ t l aux = match t with
  | Lambda (s, t) -> let (s', aux') = if s = "_EMPTY" then (generate_fresh_variable aux, aux+1) else (s, aux) in Lambda (s', variable_to_church_ t (s' :: l) (aux'))
  | Vars s -> Var (find_lambda l s 1)
  | App (t1, t2) -> App(variable_to_church_ t1 l aux, variable_to_church_ t2 l aux)
  | t' -> t'

let variable_to_church t = variable_to_church_ t [] 0


let rec church_to_variable_ t l = match t with
| Lambda (s, t) -> Lambda (s, (church_to_variable_ t (s::l)))
| Var v -> (match peek_n l v with 
        | Some(n) -> Vars (Printf.sprintf "%s" n)
        | None ->  raise (EvaluatorError "variable not found during church transformation"))
| App (e1, e2) -> App(church_to_variable_ e1 l, church_to_variable_ e2 l)
| t' -> t'

let church_to_variable t = church_to_variable_ t []

let parse_variable_number s = int_of_string (String.sub s 2 ((String.length s) - 2))

let rec smallest_numeral (t:term) (aux:int):int = match t with
  | Lambda (s, t) -> let e = String.get s 0 
                     in if e = '_' then let nr = parse_variable_number s 
                                        in if (nr < aux) || (aux = -1) then smallest_numeral t nr
                                           else smallest_numeral t aux
                        else smallest_numeral t aux
  | App(t1, t2) -> let (s1, s2) = (smallest_numeral t1 aux, smallest_numeral t2 aux)
                   in if s1 < s2 then s1 else s2
  | Vars s -> let e = String.get s 0 
              in if e = '_' then let nr = parse_variable_number s 
                                 in if (nr < aux) || (aux = -1) then nr
                                    else aux
                 else aux
  | _ -> aux

let rec normalize_variables_ t aux = match t with
  | Lambda (s, t) -> Lambda ((if (String.get s 0) = '_' then Printf.sprintf "_x%d" ((parse_variable_number s) - aux) else s), normalize_variables_ t aux)
  | Vars s -> Vars (if (String.get s 0) = '_' then Printf.sprintf "_x%d" ((parse_variable_number s) - aux) else s)
  | App (t1, t2) -> App(normalize_variables_ t1 aux, normalize_variables_ t2 aux)
  | t' -> normalize_variables_ t' aux

let normalize_variables t = let n = (smallest_numeral t (-1)) in if (n = -1) then t else normalize_variables_ t n

let rec lambda_to_int_ t acc v = match t with
  |  Lambda (s, t) -> if v = "_DUMMY" then lambda_to_int_ t acc s else lambda_to_int_ t acc v
  |  Vars s -> if v = s then acc + 1 else 0
  |  App(t1, t2) -> (lambda_to_int_ t1 acc v) + (lambda_to_int_ t2 acc v)
  | t' -> acc

let lambda_to_int t = Printf.printf "kek"; lambda_to_int_ t 0 "_DUMMY"

let pop s = match s with
  | [] -> None
  | (h :: t) -> Some (h, t)

let count p l =
  List.fold_left (fun a _ -> a + 1) 0 (List.filter p l)

let push s t = t :: s

let rec pprint t = match t with
  | Lambda (s, t) -> Printf.sprintf "lambda %s. (%s)" s (pprint t)
  | Vars v -> Printf.sprintf "%s" v
  | Var n -> Printf.sprintf "v%d" n
  | App (e1, e2) -> (match (e1, e2) with
    | (Var _, Var _) ->
        Printf.sprintf "(%s %s)" (pprint e1) (pprint e2)
    | (Var _, _) -> 
        Printf.sprintf "(%s %s)" (pprint e1) (pprint e2)
    | (_, Var _) -> 
        Printf.sprintf "(%s %s)" (pprint e1) (pprint e2)
    | (_, _) -> 
        Printf.sprintf "(%s %s)" (pprint e1) (pprint e2))

let (@.) f g = App (f, g)
let (!.) f = Lambda ("_EMPTY", f)
let (~|) t = Var t
let app f e1 e2 = (f @. e1) @. e2

(* consts *)
let zero_lambda = !. !. (~| 1)
let true_lambda = !. !. (~| 2)
let false_lambda = !. !. (~| 1)

(* helper functions *)
let succ_lambda e    = (!. !. !. ((~| 2) @. (((~| 3) @. (~| 2)) @. (~| 1)))) @. e
let pred_free        = !. !. !. ((((~| 3) @. (!. !. ((~| 1) @. ((~| 2) @. (~| 4))))) @. (!. (~| 2))) @. (!. (~| 1)))
let pred_lambda e    = (!. !. !. ((((~| 3) @. (!. !. ((~| 1) @. ((~| 2) @. (~| 4))))) @. (!. (~| 2))) @. (!. (~| 1)))) @. e
let is_zero_lambda e = (!. (((~| 1) @. (!. false_lambda)) @. true_lambda)) @. e
let minus            = !. !. (((~| 1) @. pred_free) @. (~| 2))
let add              = app (!. !. !. !. ( ((~| 4) @. (~| 2)) @. (((~| 3) @. (~| 2)) @. (~| 1))))
let adiff_lambda     = app (!. !. (add ((minus @. (~| 1)) @. (~| 2)) ((minus @. (~| 2)) @. (~| 1))))

(* lambda mapping functions *)
let if_lambda e1 e2 e3 = (((!. !. !. (((~| 3) @. (~| 2)) @. (~| 1))) @. e1) @. e2) @. e3
let and_lambda = app (!. !. ((~| 2) @. (~| 1) @. (~| 2)))
let add_lambda = app (!. !. !. !. ( ((~| 4) @. (~| 2)) @. (((~| 3) @. (~| 2)) @. (~| 1))))
let sub_lambda = app (!. !. (((~| 1) @. pred_free) @. (~| 2)))
let mul_lambda = app (!. !. !. !. (((~| 4) @. ((~| 3) @. (~| 2))) @. (~| 1)))
let eq_lambda  = app (!. !. (is_zero_lambda (adiff_lambda (~| 1) (~| 2))))

(* lambda functions *)
let fix_lambda e  = (!. ((!. ((~| 2) @. ((~| 1) @. (~| 1)))) @. (!. ((~| 2) @. ((~| 1) @. (~| 1)))))) @. e
let pair_apply    =  !. !. !. (((~| 1) @. (~| 3)) @. (~| 2))
let pair_lambda   = app (!. !. !. (((~| 1) @. (~| 3)) @. (~| 2)))
let fst_apply     = (!. ((~| 1) @. (!. !. (~| 2))))
let fst_lambda e  = (!. ((~| 1) @. (!. !. (~| 2)))) @. e
let snd_apply     = (!. ((~| 1) @. (!. !. (~| 1))))
let snd_lambda e  = (!. ((~| 1) @. (!. !. (~| 1)))) @. e
let nil_lambda    = (pair_apply @. true_lambda) @. true_lambda
let cons_lambda   = app (!. !. ((pair_apply @. false_lambda) @. ((pair_apply @. (~| 2)) @. (~| 1))))
let head_lambda e = (!. (fst_apply @. (snd_apply @. (~| 1)))) @. e
let tail_lambda e = (!. (snd_apply @. (snd_apply @. (~| 1)))) @. e
let isnil_lambda  = fst_lambda
let rec number_lambda n = if n == 0 then zero_lambda else (succ_lambda (number_lambda (n-1)))