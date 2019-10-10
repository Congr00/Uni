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

cut([1;2;3;4], 1);;
segments([1;2;3;4;5;6;7;8;9], 2);;
