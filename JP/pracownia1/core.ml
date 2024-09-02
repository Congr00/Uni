open Syntax

let rec cbn t s c = match t with
  | App (t1, t2) -> cbn t1 ((CEntry (t2, c) :: s)) c
  | Lambda (_, t') -> 
      (match s with
        | (hd :: tl) -> cbn t' tl (hd :: c)
        | _          -> t)
  | Var id -> 
      (match peek_n c id with
        | Some (CEntry (vt, vc)) -> cbn vt s vc
        | _ -> raise (EvaluatorError "cbn Normalizer error: couldn't find variable %s")
      )
  | t' -> t'

let rec krivine_evaluator t s c c2 = match t with
  | App (t1, t2) -> (match krivine_evaluator t1 ((CEntry (t2, c) :: s)) c c2 with
                      | Result(t1', (CEntry (t2, c) :: s)) ->
                        Result(App(t1', take_term (krivine_evaluator t2 [] c c2)), s)
                      | kr -> kr)
  | Lambda (v, t') ->
      (match s with
        | (hd :: tl) -> krivine_evaluator t' tl (hd :: c) (hd :: c2)
        | _          -> Result (Lambda (v, (take_term (krivine_evaluator t' s (CEmpty :: c) (CEmpty :: c2)))), s)
      )
  | Var id ->
      (match peek_n c id with
        | Some (CEntry (vt, vc)) -> krivine_evaluator vt s vc c2 
        | Some CEmpty -> (
            let e = count (fun v -> v = CEmpty) c2 - count (fun v -> v = CEmpty) c + count (fun v -> v = CEmpty) (take id c)
            in Result (Var (e), s))
        | None -> raise (EvaluatorError " Couldn't find variable in given context"))
  | t' -> Result (t', s)

let eval_cbn t = let no_variables = variable_to_church t 
               in let evaluated = cbn no_variables [] []
               in let normalized = normalize_variables (church_to_variable evaluated)
               in normalized

let eval t = let no_variables = variable_to_church t 
             in let evaluated = take_term (krivine_evaluator no_variables [] [] [])
             in let normalized = normalize_variables (church_to_variable evaluated)
             in normalized

let beta_equality t1 t2 =
  (eval t1) = (eval t2)
