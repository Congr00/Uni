(* Łukasz Klasiński *)

(* zad4 z pracowni *)

type ordering = LT | EQ | GT;;
(** Linearly ordered types **)

module type ORDER =
sig
  type t
  val compare: t -> t -> ordering
end;;

module StringOrder: ORDER with type t = string =
  struct
    type t = string
    let compare s1 s2 = if s1<s2 then LT
                        else if s1>s2 then GT else EQ
end;;

module IntOrder : ORDER with type t = int =
struct
  type t = int
  let compare s1 s2 = if s1<s2 then LT 
                      else if s1>s2 then GT else EQ
end;;

module type DICTIONARY =
sig
  type key (* type of keys *)
  exception DuplicatedKey of key (* error in insert *)
  val empty: unit -> 'a list (* empty dictionary *)
  val lookup: (key * 'a) list -> key -> 'a option
  val insert: (key * 'a) list -> key * 'a -> (key * 'a) list
  val delete: (key * 'a) list -> key -> (key * 'a) list
  val update: (key * 'a) list -> key * 'a -> (key * 'a) list (* not necessary *)
end;;

module Dictionary (Key : ORDER) : DICTIONARY with type key = Key.t =
struct
  type key = Key.t
  exception DuplicatedKey of key
  let empty() = []
  let rec lookup list key =
    match list with
    | [] -> None
    | (k,el)::tl -> if Key.compare key k == EQ then Some(el)
                    else lookup tl key
  let rec insert list (key, value) =
    match list with
    | [] -> [key, value]
    | (k, v)::tl -> (match Key.compare key k with
                         | LT -> (key, value)::[(k, v)] @ tl
                         | EQ -> raise (DuplicatedKey key)
                         | GT -> (k, v)::(insert tl (key, value))
                    )
  let rec delete list key =
    match list with
    | [] -> []
    | (k, v)::tl -> (match Key.compare key k with
                         | EQ -> delete tl key
                         | _  -> (k, v)::(delete tl key)
                    )
  let rec update list (key, value) =
    match list with
    | [] -> [(key, value)]
    | (k, v)::tl -> (match Key.compare key k with
                         | EQ -> (k, value)::(delete tl key)
                         | _  -> (k, v)::(update tl (key, value))
                    )
end;;

(* nie dokończone testy *)
module Tester = functor (Dict : DICTIONARY) ->
struct            
  let test1 key1 key2 key3 key4 key5 =
    let dict = Dict.empty() in
    let dict = Dict.insert dict (key1, "cat") in
    let dict = Dict.insert dict (key2, "elephant") in
    let dict = Dict.insert dict (key3, "dog") in
    let dict = Dict.insert dict (key4, "bird") in
    [Dict.lookup dict key3; Dict.lookup dict key5; Dict.lookup (Dict.insert dict (key5, "parrot")) key5]
    
  let test2 key1 key2 key3 key4 key5 =
    let dict = Dict.empty() in
    let dict = Dict.insert dict (key1, "cat") in
    let dict = Dict.insert dict (key2, "elephant") in
    let dict = Dict.insert dict (key3, "dog") in
    let dict = Dict.insert dict (key4, "bird") in
    [Dict.lookup (Dict.delete dict key1) key1]
end;;

module StringDict = Dictionary(StringOrder);;
module IntDict = Dictionary(IntOrder);;
    
module StringTest = Tester(StringDict);;

StringTest.test1 "kot" "slon" "pies" "ptak" "papuga";;
StringTest.test2 "kot" "slon" "pies" "ptak" "papuga";;

module IntTest = Tester(IntDict);;

IntTest.test1 1 2 3 4 5;;
IntTest.test2 1 2 3 4 5;;
