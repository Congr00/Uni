
type 'a cell = {value: 'a; mutable next: 'a cell}
type 'a t = {mutable length: int; mutable capacity: int; mutable tail: 'a cell option;}


exception Empty of string
exception Full of string

let create n = { length=0; capacity=n; tail=None}
let enqueue (x, que) = match que with
  | { length=0; _ } -> let rec aux = { value=x; next=aux } in que.tail <- Some(aux); que.length <- 1
  | { length=l; capacity=n; tail=Some(t) } -> if l == n then raise (Full "Full queue")
                                              else t.next <- { value=x; next=t.next }; que.length <- (l+1)
  | _ -> ()
let dequeue que = match que with
  | { length=0; _ } -> raise (Empty "Empty queue")
  | { length=l; capacity=n; tail=Some(t) } -> que.length <- (l-1);
                                              t.next <- (t.next.next)
  | _ -> ()
let first que = match que with
  | { length=0; _ } -> raise (Empty "Empty queue")
  | { tail=Some(t); _ } -> t.next.value
  | _ -> raise (Empty "Empty queue")
let isEmpty que = match que with
  | { length=0; _ } -> true
  | _ -> false
let isFull que = match que with
  | { length=l; capacity=c; _ } -> (l = c)
              
