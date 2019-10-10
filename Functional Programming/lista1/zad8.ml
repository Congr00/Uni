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


swap(['1';'2';'a';'b'], 2);; 
