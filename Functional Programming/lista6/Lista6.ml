(* Łukasz Klasiński *)


(* zad 1 *)
let zgadnij = let guessed = ref false in
  let random = ref (Random.int 100) in
  begin
    while not !guessed do
      print_string "Podaj liczbę:\n";
      let input = read_int () in
      if input < !random
      then begin print_string "moja jest większa\n"; end
      else if input > !random
      then begin print_string "moja jest mniejsza\n"; end
      else begin print_string "Zgadłeś. Brawo!\n"; guessed := true; end
    done
  end
;;

zgadnij;;

type 'a bt = Empty | Node of 'a * 'a bt * 'a bt;;

(* zad 2 *)

let printBT tree =
  let rec print_line depth =
    match depth with
    | 0 -> print_string ""
    | n -> print_string "..."; print_line (depth-1) in
  let rec printBT_d tree depth = 
    match tree with
    | Node(value, left, right) -> printBT_d right (depth+1); 
                                  print_line depth; print_int value; print_string "\n";
                                  printBT_d left (depth+1);
    | Empty -> print_line depth; print_string "||\n"
  in printBT_d tree 0
;;

let t = Node(1, Node(2, Empty, Node(3, Empty, Empty)), Empty);;
printBT t;;

(* zad 3 *)


let sortuj_plik =
  print_string "podaj nazwę pliku:\n";  let filename = read_line () in
  let ic = open_in filename in
  try
    let count = int_of_string(input_line ic) in
    let vec = Array.make (count+1) 0 in
    for i=0 to count do
      let v = input_line ic in
      vec.(i) <- int_of_string(v);
    done;
    Array.sort Stdlib.compare vec;
    close_in ic;
    print_string "Podaj nazwę pliku wyjściowego:\n";
    let input = read_line () in
    let oc = open_out input in
    for i=0 to count do
      Printf.fprintf oc "%d " vec.(i);
    done;
    Printf.fprintf oc "\n";
    close_out oc
    
  with e ->
    close_in_noerr ic;
    raise e
;;

sortuj_plik;;
