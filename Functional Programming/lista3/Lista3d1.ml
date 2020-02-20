(* Łukasz Klasiński *)

(* zad1 *)

(* a *)
let curry3 f x y z = f(x,y,z);;
let uncurry3 f(x,y,z) = f x y z;;

curry3 (fun (x,y,z) -> x+y+z) 1 2 3;;
uncurry3 (fun x y z -> x+y+z) (1,2,3);;

(* b *)
let curry3 = function f -> function x -> function y -> function z -> f(x,y,z);;
let uncurry3 = function f -> function (x,y,z) -> f x y z;;

curry3 (fun (x,y,z) -> x+y+z) 1 2 3;;
uncurry3 (fun x y z -> x+y+z) (1,2,3);;

(* zad2 *)

(* a *)
let rec czyIstnieje pred list = 
  match list with
  | [] -> false
  | hd::tl -> pred hd || czyIstnieje pred tl;;

czyIstnieje (fun x -> x = 2) [1;2;3;4;5];;
czyIstnieje (fun x -> x = 2) [1;3;4;5;6];;
czyIstnieje (fun x -> x = 2) [];;
czyIstnieje (fun x -> x = 2) [2;2;2;2;2];;

(* b *)
let czyIstnieje pred list =
  List.fold_left (fun acc x -> pred x || acc) false list;;

czyIstnieje (fun x -> x = 2) [1;2;3;4;5];;
czyIstnieje (fun x -> x = 2) [1;3;4;5;6];;
czyIstnieje (fun x -> x = 2) [];;
czyIstnieje (fun x -> x = 2) [2;2;2;2;2];;

(* c *)
let czyIstnieje pred list =
  List.fold_right (fun x acc -> pred x || acc) list false;;

czyIstnieje (fun x -> x = 2) [1;2;3;4;5];;
czyIstnieje (fun x -> x = 2) [1;3;4;5;6];;
czyIstnieje (fun x -> x = 2) [];;
czyIstnieje (fun x -> x = 2) [2;2;2;2;2];;

(* zad3 *)

let filter list pred =
  List.fold_right (fun x acc -> if not (pred x) then x::acc else acc) list [];;


filter [1;2;3;4;5;] (fun x -> x < 3);;
filter [] (fun x -> x < 3);;
filter [1;2;3;4;5;] (fun x -> x > 0);;
filter [5;5;5;5;5;] (fun x -> x < 3);;

(* zad 4 *)

(* a *)
let rec usun1 pred list =
  match list with
  | [] -> []
  | hd::tl -> if pred hd then tl else hd :: usun1 pred tl;;

usun1 (fun x -> x = 2) [1;2;3;2;5];;
usun1 (fun x -> x = 2) [1;3;4;5;6];;
usun1 (fun x -> x = 2) [];;
usun1 (fun x -> x = 2) [2;2;2;2;2];;

(* b *)
let usun1 pred list =
  let rec aux list acc =
    match list with
    | [] -> List.rev acc
    | hd::tl -> if pred hd then List.rev_append acc tl else aux tl (hd :: acc)
  in aux list [];;

usun1 (fun x -> x = 2) [1;2;3;2;5];;
usun1 (fun x -> x = 2) [1;3;4;5;6];;
usun1 (fun x -> x = 2) [];;
usun1 (fun x -> x = 2) [2;2;2;2;2];;

(* zad5 *)
let rec split list n =
  match list with
  | [] -> ([], [])
  | hd::tl -> let (r1,r2) = split tl (n-1) in
              if n == 0 then ([], list) else (hd::r1, r2);;

let mergesort pred list =
    let rec merge list1 list2 =
      match (list1,list2) with
      | (list1, []) -> list1
      | ([], list2) -> list2
      | (hd1::tl1, hd2::tl2) -> if pred hd1 hd2 then hd1::(merge tl1 list2) else hd2::(merge list1 tl2)
    in let rec mergesort_r list len = 
          match len with
          | 0 -> []
          | 1 -> list
          | _ -> let (list1,list2) = split list (len/2) in
                 let (len1,len2) = if (len mod 2) = 0 then (len/2, len/2) else (len/2, len/2+1) 
                      in merge (mergesort_r list1 len1) (mergesort_r list2 len2)
    in mergesort_r list (List.length list);;

mergesort (fun x y -> x <= y) [2;1;3;1;6;4;2;-1;5;3;2;1;9;0];;
mergesort (fun x y -> x <= y) [1;2;3;4;5;6;7;8;9;10];;
mergesort (fun x y -> x <= y) [-1;-2;-3;-4;0;1;2;3];;
(* sorting in place check *)
mergesort (fun (x1,x2) (y1,y2) -> x1 <= y1) [(-1,2);(-1,3);(-1,4);(-1,5);(-5,4);(0,0);];;
