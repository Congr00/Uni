open Support.Pervasive
open Support.Error
open Syntax
open Core

let load_and_parse f =
  let pi = open_in_bin  f
  in let lexbuf = Lexer.create f pi
  in let result =
    try Parser.start Lexer.token lexbuf with Parsing.Parse_error -> 
    error (Lexer.info lexbuf) "Parse error"
  in close_in pi;
  match result with
    | Some(r) -> r
    | None -> error (Lexer.info lexbuf) "Parse error"

let () =
  if Array.length Sys.argv < 3 then
    Printf.eprintf "Usage: prog <output.t> <file.t> [<file2.t>] [-int] [-cbn]\n"
  else
    let output_name = Sys.argv.(1) in
    let input_name = Sys.argv.(2) in
    let parsed = load_and_parse input_name in
    let output =
      if Array.length Sys.argv = 4 then
        let arg4 = Sys.argv.(3)
        in if (compare arg4 "-int") = 0 then string_of_int (lambda_to_int (eval parsed))
           else if (compare arg4 "-cbn") = 0 then pprint (eval_cbn parsed) 
                else let input_name2 = Sys.argv.(3) 
                     in let parsed2 = load_and_parse input_name2 in string_of_bool (beta_equality parsed parsed2) 
      else pprint (eval parsed) 
    in
      let output_file = open_out output_name in
      Printf.fprintf output_file "%s" output