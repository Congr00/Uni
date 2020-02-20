(* Łukasz Klasiński *)

(* zad 1 *)

type 'a bt = Empty | Node of 'a * 'a bt * 'a bt;;
let t = Node(1,Node(2,Empty,Node(3,Empty,Empty)),Empty);;

let rec sumBT tree =
  match tree with
  | Empty -> 0
  | Node(n, t1, t2) -> n + (sumBT t1) + (sumBT t2);;

sumBT t;;

(* zad 2 *)
let rec foldBT f acc tree =
  match tree with
  | Empty -> acc
  | Node(n, t1, t2) -> f n ((foldBT f acc t1), (foldBT f acc t2));;

(* zad 3 *)

foldBT (fun n (a1, a2) -> n + a1 + a2) 0 t;;
foldBT (fun n (a1, a2) -> a1 @ (n :: a2)) [] t;;
foldBT (fun n (a1, a2) -> n :: (a1 @ a2)) [] t;;
foldBT (fun n (a1, a2) -> a1 @ a2 @ [n]) [] t;;

(* zad 4 *)

let rec mapBT f tree = foldBT (fun n (a1, a2) -> Node(f n, a1, a2)) Empty tree;;

mapBT (fun v -> 2*v) t;;

(* zad 5 *)

type 'a tree = L of 'a | N of 'a tree * 'a tree;;
let t = N(N(L 1, L 0), N(N(L 10,L 8), L (-1)));;

let rec store tree =
  match tree with
  | L a -> [Some a]
  | N(t1, t2) -> (store t1 @ store t2) @ [None];;

store t;;

exception Load;;
(*
let rec load list =
  match list with
  | e1::e2::None::tl -> N 
  | _ -> raise Load;;
*)                  
