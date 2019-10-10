let first  (a, _) = a;;
let second (_, b) = b;;
let rec split = fun (list, divider) ->
  match list with
    | []  -> ([], [])
    | [x] -> if x <= divider then ([x], []) else ([], [x])    
    | hd::tl ->
       if hd <= divider then ([hd] @ first (split (tl, divider)), second (split (tl, divider)))
       else (first (split (tl, divider)), [hd] @ second (split (tl, divider)));;
split(['a';'s';'h';'g'], 'g')
