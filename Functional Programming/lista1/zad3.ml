let rec isSorted = fun list -> 
  match list with
    | []  -> true
    | [_] -> true
    | hd :: x :: tl -> if hd <= x && isSorted([x] @ tl) then true else false;;
isSorted [1;2;3;3;4;7];;
