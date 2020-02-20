open QueueMut


let menu (opt) =
  let numItems = Array.length opt-1
  in
    begin
      print_string "\n\n=================================================== \n";
      print_string opt.(0);print_newline();
      for i=1 to numItems do  print_int i; print_string (". "^opt.(i)); print_newline() done;
      print_string "\nSelect an option: ";
      flush stdout;
      let choice = ref (read_int())
      in 
	while !choice < 1 || !choice > numItems do 
	  print_string ("Choose number between 1 and " ^ string_of_int numItems ^ ": ");
	  choice := read_int();
	done; 
	!choice
    end
;;

let que = ref (QueueMut.create 10);;
let menuItems = Array.make 7 "";;
let quit = ref false;;
let choice = ref 7;;

menuItems.(0) <- "Queue operations (implementation on mutable lists)";
menuItems.(1) <- "enqueue";
menuItems.(2) <- "dequeue";
menuItems.(3) <- "first";
menuItems.(4) <- "isEmpty";
menuItems.(5) <- "isFull";
menuItems.(6) <- "quit testing";

while not !quit do
  begin
    choice := menu(menuItems);
    match !choice with
	1 ->
	  begin
	    print_string "Stack item = ";
	    QueueMut.enqueue (read_int(), !que);
	  end  
      | 2 ->
	  begin
	    begin
	      try QueueMut.dequeue !que  with 
		  QueueMut.Empty m -> print_string ("Exception: "^m);
	    end;
	    print_newline();
	  end
      | 3 ->
		begin
	    begin
	      try print_string "first element: "; print_int(QueueMut.first !que)  with 
		  QueueMut.Empty m -> print_string ("Exception: "^m);
			end;
	    print_newline();
	  end
      | 4 ->
	    print_string ("Stack is "^(if QueueMut.isEmpty !que then "" else "not ")^"empty.\n");
			| 5 ->
			print_string ("Stack is "^(if QueueMut.isFull !que then "" else "not ")^"full.\n");
			| 6 ->
	    quit := true
      | _ ->
	    print_string "IMPOSSIBLE!!!\n"
  end
done
