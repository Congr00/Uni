%{
  open Syntax
%}

(* tokens with value *)

%token <int> INT
%token <string> LAMBDA
%token <string> VAR


(* const tokens *)
%token TRUE
%token FALSE
%token FIX
%token IF
%token THEN
%token ELSE
%token ADD
%token SUB
%token MUL
%token FST
%token SND
%token NIL
%token CONS
%token HEAD
%token TAIL
%token ISNIL
%token EQ
%token LPAREN
%token RPAREN
%token PAIR
%token COMMA
%token EOF

(* dummy token *)
%token APP

(* association *)
%left CONS COMMA
%left EQ
%left ADD SUB
%left MUL
%right FIX FST SND HEAD TAIL ISNIL PAIR
%nonassoc VAR LPAREN LAMBDA INT
%nonassoc APP



%start <Syntax.term option> start
%%

start:
  |          EOF { None   }
  | v = expr EOF { Some v }

consts:
  |   i = INT { number_lambda i}
  |     TRUE  { true_lambda     }
  |     FALSE { false_lambda    }

expr:
  | var = LAMBDA LPAREN e = expr RPAREN        { Lambda (var, e)     }
  | var = VAR                                  { Vars(var)           } 
  | e1 = expr  e2 = expr %prec APP             { App (e1, e2)        }
  | PAIR e1 = expr e2 = expr                   { pair_lambda e1 e2   }
  | LPAREN e = expr RPAREN                     { e                   }
  | e1 = expr MUL e2 = expr                    { mul_lambda e1 e2    }
  | e1 = expr ADD e2 = expr                    { add_lambda e1 e2    }
  | e1 = expr SUB e2 = expr                    { sub_lambda e1 e2    }
  | e1 = expr EQ e2 = expr                     { eq_lambda e1 e2     }
  | IF e1 = expr THEN e2 = expr ELSE e3 = expr { if_lambda e1 e2 e3  }
  | e1 = expr CONS e2 = expr                   { cons_lambda e1 e2   }
  | LPAREN FIX e = expr RPAREN                 { Syntax.fix_lambda e }
  | LPAREN e1 = expr COMMA e2 = expr RPAREN    { pair_lambda e1 e2   }
  | FST e = expr                               { fst_lambda e        }
  | SND e = expr                               { snd_lambda e        }
  | NIL                                        { nil_lambda          }
  | e1 = expr CONS e2 = expr                   { cons_lambda e1 e2   }
  | HEAD e = expr                              { head_lambda e       } 
  | TAIL e = expr                              { tail_lambda e       } 
  | ISNIL e = expr                             { isnil_lambda e      } 
  | e = consts                                 { e                   }