let rec ends = fun x ->
  match x with
  | [] -> failwith "Empty List"
  | [_] -> failwith "Singleton List"
  | [x;y] -> (x,y)
  | hd::_::tl -> ends (hd::tl);;
ends [1;2;3;5];;
