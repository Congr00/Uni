(* Łukasz Klasiński *)

(* zad 1*)
let rec fib_bad n = 
  if n < 0 then failwith "negative n" else
    if n < 2 then n
    else fib_bad (n - 1) + fib_bad (n - 2);;

let fib n =
  let rec fib_aux (num, actual, next) =
    if num == n then actual else fib_aux (num+1, actual+next, actual)
  in if n < 0 then failwith "negative n" else fib_aux (0, 0, 1)
;;

let time f x =
  let t = Sys.time()
  and fx = f x
  in let _ = Printf.printf "Time %fs\n" (Sys.time() -. t)
     in fx;;

time fib 50;;
time fib_bad 20;;

(* zad 2 *)
let abs n = if n < 0. then n *. (-1.0) else n;;
let rec root3 a =
  let eps = 0.00000001
  in let rec f x_i =
    match x_i with
    | 0. -> if a > 1. then f (a /. 3.) else f a
    | x_i -> if abs (x_i ** 3. -. a) <= eps *. abs(a) then x_i
             else f (x_i +. (a /. (x_i ** 2.) -. x_i) /. 3.)
  in f 0.
;;
    
root3 3.;;

(* zad 3 *)
let (<->) (x1, x2, x3) (y1, y2, y3) =
  let abs n = if n < 0. then n *. (-1.0) else n
  in abs (x1-.y1) +. abs (x2-.y2) +. abs (x3-.y3)
;;
(1.,1.,1.) <-> (1.,1.,0.);;


(* zad 4 *)
let (<--) list n =
  let rec insert list=
    match list with
    | [] -> [n]
    | hd::tl -> if hd >= n then n::list else hd::(insert tl) 
  in insert list
;;
(* złóżoność: liniowa 
   przed 1 -> 2 -> 3 -> 5
                        ^
                        |
      po 1 -> 2 -> 3 -> 4 - współdzielona piątka
*)
[1;2;3;5] <-- 4;;

(* zad 5 *)
let rec take n list =
  match list with
  | [] -> []
  | hd::tl -> if n == 0 then []
             else hd :: (take (n-1) tl)
;;

take 2 [1;2;3;5;6];;
take (-2) [1;2;3;5;6];;
take 8 [1;2;3;5;6];;

(* zad 6 *)
let rec drop n list =
  match list with
  | [] -> []
  | _::tl -> if x == 0 then list
              else drop (n-1) tl
;;
drop 2 [1;2;3;5;6];;
drop (-2) [1;2;3;5;6];;
drop 8 [1;2;3;5;6];;

(* zad 7 *)
let rec replicate list =
  let rec dup_list n const =
    match n with
    | 0 -> []
    | n -> if n < 0 then []
           else const::(dup_list (n-1) const)
  in match list with
     | [] -> []
     | hd::tl -> dup_list hd hd @ replicate tl;;
replicate [1;0;4;-2;3];;
