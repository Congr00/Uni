  (* This module implements queues (FIFOs) with in-place modifications. *)
  
type 'a cell
type 'a t
exception Empty of string
      (* Raised when [first q] is applied to an empty queue [q]. *)
exception Full of string
      (* Raised when [enqueue(x,q)] is applied to a full queue [q]. *)
val create: int -> 'a t
      (* [create n] returns a new queue of length [n], initially empty. *)
val enqueue: 'a * 'a t -> unit
      (* [enqueue (x,q)] adds the element [x] at the end of a queue [q]. *)
val dequeue: 'a t -> unit
      (* [dequeue q] removes the first element in queue [q] *)        
val first: 'a t -> 'a
      (* [first q] returns the first element in queue [q] without removing  
      it from the queue, or raises [Empty] if the queue is empty.*) 
val isEmpty: 'a t -> bool
      (* [isEmpty q] returns [true] if queue [q] is empty, 
      otherwise returns [false]. *)
val isFull: 'a t -> bool
      (* [isFull q] returns [true] if queue [q] is full, 
      otherwise returns [false]. *)
