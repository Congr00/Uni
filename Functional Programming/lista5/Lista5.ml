(* Łukasz Klasiński *)

type 'a llist = LNil | LCons of 'a * (unit -> 'a llist);;
type 'a lBT = LEmpty | LNode of 'a * ('a lBT Lazy.t) * ('a lBT Lazy.t);;
let rec lfrom k = LCons(k, function() -> lfrom (k+1));;
let rec ltake = function
    (0, _) -> []
  | (_, LNil) -> []
  | (n, LCons(x,xf)) -> x::ltake(n-1, xf())
;;

let rec toLazyList = function
[] -> LNil
| x::xs -> LCons(x, function () -> toLazyList xs);;


(* zad1 *)

let lFib =
  let rec fib current next = LCons(current, function() -> fib next (current+next))
  in fib 0 1;;


ltake (10, lFib);;

(* zad2 *)
let rec lrepeat f list =
  let rec rep_num num k xs i =
    match k with
    | 0 -> (match xs() with
           | LNil -> LNil
           | LCons(x, xs) -> rep_num x (f i) xs (i+1))
    | k -> LCons(num, function() -> rep_num num (k-1) xs i)      
    in match list with
    | LNil -> LNil
    | LCons(x, xs) -> rep_num x (f 0) xs 1;;

ltake (20, lrepeat (fun x -> x+1) lFib);;
ltake (20, lrepeat (fun x -> x+1) (toLazyList [1;2;3;4;5;6;7;8;9;10]));;

(* zad3 *)
let sublist xs ll =
  let rec ssublist xs ll i =
    match ll with
    | LNil -> LNil
    | LCons(x, f) -> if (List.exists (fun x -> x == i) xs) then ssublist xs (f()) (i+1)
                     else LCons(x, function() -> ssublist xs (f()) (i+1))
  in ssublist xs ll 0;;

ltake (10, sublist [1;4;7;2] (toLazyList [10;11;12;13;14;15;16;17;18;19;20;21]));;

(* zad4 *)

let rec toLBST list =
  let sorted = List.sort Stdlib.compare list in
  let middle = (List.length sorted) / 2 in
  match sorted with
  | [] -> LEmpty
  | _  -> let divider = List.nth sorted middle in
          let left,right = List.partition (fun x -> x < divider) sorted
          in LNode(List.hd right, lazy(toLBST left), lazy(toLBST (List.tl right)));;

let rec infBST = function
    LEmpty -> []
  | LNode(x, lazy left, lazy right) -> (infBST left)@x::(infBST right);;

infBST (toLBST [1;2;3;4;5;6;7]);;
infBST (toLBST []);;
infBST (toLBST [1;3;5;7;9;11]);;
infBST (toLBST [9;2;5;1;7;5;2]);;
