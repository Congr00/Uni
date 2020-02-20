(* Łukasz Klasiński *)

(* zad 1a *)
module Queue_Custom : sig
  type 'a t
  exception Empty of string
  val create: unit -> 'a t
  val enqueue: 'a * 'a t -> 'a t
  val dequeue: 'a t -> 'a t
  val first: 'a t -> 'a
  val isEmpty: 'a t -> bool
end =
struct
  type 'a t = EmptyQueue | Enqueue of 'a * 'a t

  exception Empty of string
                   
  let create() = EmptyQueue

  let rec enqueue (x, queue) = match queue with
    | Enqueue(o, next) -> Enqueue(o, enqueue (x, next))
    | EmptyQueue -> Enqueue(x, EmptyQueue)

  let dequeue queue = match queue with
    | EmptyQueue -> create()
    | Enqueue(_, next) -> next

  let first queue = match queue with
    | Enqueue(o, _) -> o
    | EmptyQueue -> raise (Empty "queue is empty, cant get first element")

  let isEmpty queue = queue = EmptyQueue
end;;

let s = Queue_Custom.create();;
Queue_Custom.enqueue(1,s);;
Queue_Custom.(first(enqueue(2,enqueue(1,s))));;
Queue_Custom.isEmpty s;;
Queue_Custom.(isEmpty(enqueue(1, s)));; 
Queue_Custom.(first(dequeue(enqueue(2,enqueue(1,s)))));;
Queue_Custom.dequeue(s);;

(* zad1b *)
module Queue_List : sig
  exception Empty of string
  type 'a t
  val create : 'a list
  val enqueue : 'a * 'a list -> 'a list
  val dequeue : 'a list -> 'a list
  val first : 'a list -> 'a
  val isEmpty : 'a list -> bool
end =
struct
  exception Empty of string

  let create = []
             
  let rec enqueue (x, queue) = match queue with
    | [] -> [x]
    | hd::tl -> hd::(enqueue (x, tl))
              
  let dequeue queue = match queue with
    | [] -> create
    | _::tl -> tl
 
  let first queue = match queue with
    | [] -> raise (Empty "queue is empty, cant get first element")
    | hd::_ -> hd
  let isEmpty queue = queue = []
end;;

let s = Queue_List.create;;
Queue_List.enqueue(1,s);;
Queue_List.(first(enqueue(2,enqueue(1,s))));;
Queue_List.isEmpty s;;
Queue_List.(isEmpty(enqueue(1, s)));; 
Queue_List.(first(dequeue(enqueue(2,enqueue(1,s)))));;
Queue_List.dequeue(s);;

(* zad1c *)
module Queue_Pair : sig
  exception Empty of string
  val create : 'a list * 'b list
  val enqueue : 'a * ('a list * 'a list) -> 'a list * 'a list
  val dequeue : 'a list * 'a list -> 'a list * 'a list
  val first : 'a list * 'a list -> 'a
  val isEmpty : 'a list * 'a list -> bool
end =
struct
  exception Empty of string

  let create = ([], [])
             
  let rec enqueue (e, (x, y)) = if x == [] then (e::x, y)
                                else (x, e::y)
              
  let rec dequeue (x, y) = match x with
    | [] -> if y = [] then create
            else dequeue (List.rev y, [])
    | _::tl -> (tl, y)
 
  let rec first (x, y) = match x with
    | [] -> raise (Empty "queue is empty, cant get first element")
    | hd::_ -> hd

  let isEmpty (x, y) = x = [] && y = []
end;;

let s = Queue_Pair.create;;
Queue_Pair.enqueue(1,s);;
Queue_Pair.(first(enqueue(2,enqueue(1,s))));;
Queue_Pair.isEmpty s;;
Queue_Pair.(isEmpty(enqueue(1, s)));; 
Queue_Pair.(first(dequeue(enqueue(2,enqueue(1,s)))));;
Queue_Pair.dequeue(s);;
Queue_Pair.(dequeue(enqueue(3,enqueue(2,enqueue(1,s)))));;
