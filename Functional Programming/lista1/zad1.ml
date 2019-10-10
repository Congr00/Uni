let mult2 = fun (x, y) -> (x*y, x+y);;
let multf2 = fun (x, y) -> if x +. 1. < y -. 2. then false else true;;
let list2 = fun (x, y) -> x@[y+1];;
list2 ([1;2;3], 3);;
