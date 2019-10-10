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
