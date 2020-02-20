(* Łukasz Klasiński *)

(* zad 1 *)
let mult2 = fun (x, y) -> (x*y, x+y);;
let multf2 = fun (x, y) -> if x +. 1. < y -. 2. then false else true;;
let list2 = fun (x, y) -> x@[y+1];;

(* zad 2 *)

let rec ends = fun x ->
  match x with
  | [] -> failwith "Empty List"
  | [_] -> failwith "Singleton List"
  | [x;y] -> (x,y)
  | hd::_::tl -> ends (hd::tl);;

ends [1;2;3;5];;

(* zad 3 *)

let rec isSorted = fun list -> 
  match list with
    | []  -> true
    | [_] -> true
    | hd :: x :: tl -> if hd <= x && isSorted([x] @ tl) then true else false;;

    isSorted [1;3;3;6;7];;
    isSorted [1;2;3;3;4;1];;
    isSorted [4;5;6;1];;
    isSorted [1];;
    isSorted [];;
    isSorted [-1;1];;
    
(* zad 4 *)

let rec toPower = fun (num, power) ->
  match power with
  | 0 -> 1
  | 1 -> num
  | x -> num * toPower (num, power-1);;
let rec powers = fun (num, power) ->
  match power with
  | 0 -> [1]
  | x -> powers(num, x-1) @ [toPower(num, x)];;

powers(2, 3);;

(* zad 5 *)

let first  (a, _) = a;;
let second (_, b) = b;;
let rec split = fun (list, divider) ->
  match list with
    | []  -> ([], [])
    | [x] -> if x <= divider then ([x], []) else ([], [x])    
    | hd::tl ->
       if hd <= divider then ([hd] @ first (split (tl, divider)), second (split (tl, divider)))
       else (first (split (tl, divider)), [hd] @ second (split (tl, divider)));;

split(['a';'s';'h';'g'], 'g');;

(* zad 6 *)

let first  (a,_) = a;;
let second (_,b) = b;;
let rec cut = fun (list, num) ->
  match list with
  | [] -> ([], [])
  | hd::tl -> if num != 0 then
                let result = cut(tl, num-1) in
                ([hd] @ first result, second result)
              else ([], hd::tl);;
let rec segments = fun (list, max) ->
  match list with
  | [] -> [[]]
  | x -> if max == 0 then [x]
         else let result = cut(x, max) in
              [(first result)] @ segments(second result, max);; 

segments([1;2;3;4;5;6;7;8;9], 2);;

(* zad 7 *)

let first  (a,_) = a;;
let second (_,b) = b;;
let rec split = fun (list, div) ->
  match div with
  | 1 -> if list == [] then [[], []]
         else [[List.hd list], List.tl list]
  | n -> if list == [] then [list, []]
         else let res = split((List.tl list), div-1) in
         [List.hd list :: (first (List.hd res)), second (List.hd res)];;  
let rec swap = fun (list, div) -> let res = split(list, div) in
    second (List.hd res) @ first (List.hd res);;
  
swap(["a";"b";"5";"6"], 2);; 

