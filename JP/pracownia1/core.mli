(* module Core

   Core typechecking and evaluation functions
*)

open Syntax
open Support.Error

val eval : term -> term 
val beta_equality: term -> term -> bool
val eval_cbn: term -> term