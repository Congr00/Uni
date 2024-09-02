{
open Support.Error
exception SyntaxError of string

let lineno   = ref 1
and depth    = ref 0
and start    = ref 0

and filename = ref ""
and startLex = ref dummyinfo

let create inFile stream =
  if not (Filename.is_implicit inFile) then filename := inFile
  else filename := Filename.concat (Sys.getcwd()) inFile;
  lineno := 1; start := 0; Lexing.from_channel stream

let newline lexbuf = incr lineno; start := (Lexing.lexeme_start lexbuf)

let info lexbuf =
  createInfo (!filename) (!lineno) (Lexing.lexeme_start lexbuf - !start)
}

let whitespace = [' ' '\009' '\012']

rule token = parse
  |  whitespace+
    { token lexbuf }
  | "lambda" whitespace* (['a'-'z' '0'-'9']+ as variable) whitespace* '.'
    { Parser.LAMBDA (variable) }
  | '+' { ADD }
  | '-' { SUB }
  | '*' { MUL }
  | '=' { EQ }
  | ':' { CONS }
  | ',' { COMMA }
  | (['0'-'9']+ as i) { INT (int_of_string i) }
  | "|" { NIL }
  | "true" { TRUE }
  | "false" { FALSE }
  | "fix" { FIX }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | "fst" { FST }
  | "snd" { SND }
  | "hd" { HEAD }
  | "tl" { TAIL }
  | "isnil" { ISNIL }
  | "pair" { PAIR }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | ['a'-'z' '0'-'9']+ as var { VAR var }
  | eof { EOF }
  | _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) } 
