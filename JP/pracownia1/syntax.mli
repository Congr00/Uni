(* module Syntax: syntax trees and associated support functions *)

open Support.Pervasive
open Support.Error

(* Data type definitions *)
type term = 
  | Lambda of string * term
  | App of term * term
  | Var of int
  | Vars of string

type context = ctx_entry list
and ctx_entry =
  | CEmpty
  | CEntry of term * context

type stack = context 

exception EvaluatorError of string

type result = Result of term * stack

val zero_lambda: term
val true_lambda: term
val false_lambda: term

val if_lambda: term -> term -> term -> term
val and_lambda: term -> term -> term
val add_lambda: term -> term -> term
val sub_lambda: term -> term -> term
val mul_lambda: term -> term -> term
val eq_lambda: term -> term -> term

val fix_lambda: term -> term
val pair_apply: term
val pair_lambda: term -> term -> term
val fst_apply: term
val fst_lambda: term -> term
val snd_apply: term
val snd_lambda: term -> term
val nil_lambda: term
val cons_lambda: term -> term -> term
val head_lambda: term -> term
val tail_lambda: term -> term
val isnil_lambda: term -> term
val number_lambda: int -> term

val take_stack: result -> stack
val take_term: result -> term
val pprint: term -> string
val variable_to_church: term -> term
val take: int -> 'a list -> 'a list
val peek_n: 'a list -> int -> 'a option
val normalize_variables: term -> term
val church_to_variable: term -> term
val lambda_to_int: term -> int
val pop: 'a list -> ('a * 'a list) option
val count: ('a -> bool) -> 'a list -> int
val push: 'a list -> 'a -> 'a list

