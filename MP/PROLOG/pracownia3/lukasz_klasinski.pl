:- module(lukasz_klasinski, [parse/3]).

lexer(Tokens) -->
   white_space,
   comment,	
   (  (  "*)",		!, { fail }
	  ;	 "(",       !, { Token = tokLParen }
      ;  ")",       !, { Token = tokRParen }
	  ;  "[",		!, { Token = tokLRec }
	  ;  "]",		!, { Token = tokRRec }
	  ;  "..",		!, { Token = tokDots }
	  ;  ",",		!, { Token = tokCol }
	  ;  "^",		!, { Token = tokXor }
	  ;  "|",		!, { Token = tokOr }
	  ;  "~",		!, { Token = tokNeg }
	  ;  "#",		!, { Token = tokHash }
	  ;  "@",		!, { Token = tokAt }
	  ;  "%",		!, { Token = tokMod }
	  ;  "/",		!, { Token = tokDiv }
	  ;  "&",		!, { Token = tokAnd }
      ;  "+",       !, { Token = tokPlus }
      ;  "-",       !, { Token = tokMinus }
      ;  "*",       !, { Token = tokTimes }
      ;  "=",       !, { Token = tokEq }
      ;  "<>",      !, { Token = tokEqEx }
      ;  "<=",      !, { Token = tokLeq }
      ;  "<",       !, { Token = tokLt }
      ;  ">=",      !, { Token = tokGeq }
      ;  ">",       !, { Token = tokGt }
	  
	  ;  digit(D),  !,
            number(D, N),
            { Token = tokNumber(N) }
      ;  letter(L), !, identifier(L, Id),
            {  member((Id, Token), [ (def, tokDef),
                                     (else, tokElse),
                                     (if, tokIf),
                                     (in, tokIn),
                                     (let, tokLet),
                                     (then, tokThen),
									 ('_', tokUnder)]),
               !
            ;  Token = tokVar(Id)
            }
	  ;  underscore(L), !, identifier(L, Id),
			  { Token = tokVar(Id) }
			 ;  [_],
			  { Token = tokUnknown}
      ),
      !,
         { Tokens = [Token | TokList] },
      lexer(TokList)
   ;  [],
         { Tokens = [] }
   ).


comment -->
	[C,D], { C is "(", D is "*"},!,
	comment_seek.
comment -->
	[].	

comment_seek -->
	[C,D], { C is "(", D is "*" },!,
	comment_seek,
	comment_seek.
comment_seek -->
	[C,D], { C is "*", D is ")" },!,
	white_space,
	comment.
comment_seek -->
	[_], comment_seek.

underscore(L) -->
	[L], { L is "_"}.

white_space -->
   [Char], { code_type(Char, space) }, !, white_space.
white_space -->
   [].
   
digit(D) -->
   [D],
      { code_type(D, digit) }.

digits([D|T]) -->
   digit(D),
   !,
   digits(T).
digits([]) -->
   [].

number(D, N) -->
   digits(Ds),
      { number_chars(N, [D|Ds]) }.

letter(L) -->
   [L], { code_type(L, csym) }.

alphanum([A|T]) -->
   ([A], { code_type(A, csym) }, !, alphanum(T);
	[A], { A is "'"  }, !, alphanum(T)
   ).
alphanum([]) -->
   [].

identifier(L, Id) -->
   alphanum(As),
      { atom_codes(Id, [L|As]) }.
 
program_(Ast) -->
   definitions(Ast).

definitions(Defs) -->
	definition(Def),
	(
		definitions(Rest), !,
			{ Defs = [Def|Rest] }
		; [],
			{ Defs = [Def]  }
	).

definition(Def) -->
	(
			[tokDef], [tokVar(VarName)], [tokLParen], [tokUnder], [tokRParen], [tokEq], expression(Exp),!,
			{ Def = def(VarName, wildcard(no), Exp)  }
		;	[tokDef], [tokVar(VarName)], [tokLParen], pattern(Patt), [tokRParen], [tokEq], expression(Exp),!,
			{ Def = def(VarName, Patt, Exp)  }
	).
pattern(Patt) -->
	(
			[tokLParen], pattern(Patt), [tokRParen],!
		;	[tokVar(X)], [tokCol], pattern(Patt1),!,
			{ Patt = pair(no, var(no, X), Patt1)  }
		;	[tokVar(X)],!,
			{ Patt = var(no, X) }

	).
expression(Exp) -->
	(
			[tokIf], expression(Exp1), [tokThen], expression(Exp2), [tokElse], expression(Exp3),!,
			{ Exp =  if(no, Exp1, Exp2, Exp3) }
		;	[tokLet], pattern(Patt), [tokEq], expression(Exp1), [tokIn], expression(Exp2),!,
			{ Exp = let(no, Patt, Exp1, Exp2)  }
		;	expr_comp(Exp1), [tokCol], expression(Exp2),!,
			{ Exp = pair(no, Exp1, Exp2)  }
		;	expr_comp(Exp)
	).

expr_comp(op(no,'=',N,S)) --> exp_at_op(N), [tokEq], exp_at_op(S).
expr_comp(op(no,'<',N,S)) --> exp_at_op(N), [tokLt], exp_at_op(S).
expr_comp(op(no,'>',N,S)) --> exp_at_op(N), [tokGt], exp_at_op(S).
expr_comp(op(no,'<=',N,S)) --> exp_at_op(N), [tokGeq], exp_at_op(S).
expr_comp(op(no,'>=',N,S)) --> exp_at_op(N), [tokLeq], exp_at_op(S).
expr_comp(op(no,'<>',N,S)) --> exp_at_op(N), [tokEqEx], exp_at_op(S).
expr_comp(N) --> exp_at_op(N).

exp_at_op(N) --> exp_adders_op(S), expr_at(N,S).
expr_at(op(no,'@',A,N),A) --> [tokAt], exp_adders_op(S),!, expr_at(N,S).
expr_at(S,S) --> [].

exp_adders_op(N) --> exp_mults_op(S), !, expr_adders(N,S).
expr_adders(N,A) --> [tokPlus], exp_mults_op(S), !, expr_adders(N,op(no,'+',A,S)).
expr_adders(N,A) --> [tokMinus], exp_mults_op(S), !, expr_adders(N,op(no,'-',A,S)).
expr_adders(N,A) --> [tokXor], exp_mults_op(S), !, expr_adders(N,op(no,'^',A,S)).
expr_adders(N,A) --> [tokOr], exp_mults_op(S), !, expr_adders(N,op(no,'|',A,S)).
expr_adders(N,N) --> [].


exp_mults_op(N) --> exp_unary_op(S), expr_mults(N,S).
expr_mults(N,A) --> [tokAnd], exp_unary_op(S), !, expr_mults(N,op(no,'&',A,S)).
expr_mults(N,A) --> [tokDiv], exp_unary_op(S), !, expr_mults(N,op(no,'/',A,S)).
expr_mults(N,A) --> [tokTimes], exp_unary_op(S),!, expr_mults(N, op(no, '*', A,S)).
expr_mults(N,A) --> [tokMod], exp_unary_op(S),!, expr_mults(N, op(no, '%', A,S)).
expr_mults(N,N) --> [].

exp_unary_op(N) --> unary_op(N,S),  simple_expr(S).

unary_op(op(no,'~',A),S) --> [tokNeg],!, unary_op(A,S).
unary_op(op(no,'-',A),S) --> [tokMinus],!, unary_op(A,S).
unary_op(op(no,'#',A),S) --> [tokHash],!, unary_op(A,S).
unary_op(S,S) --> [].

simple_expr(Simpl) -->
	(
		 	[tokLParen], expr_comp(Exp_o), [tokRParen], bit_pick(Simpl,Exp_o),!
		;	atom_expr(Exp_a), bit_pick(Simpl,Exp_a),!
		; 	[tokLParen], expr_comp(Exp_o), [tokRParen], bits_pick(Simpl,Exp_o),!
		;	atom_expr(Exp_a), bits_pick(Simpl,Exp_a),!
		;	[tokLParen], expr_comp(Simpl), [tokRParen],!
		;	atom_expr(Simpl)
	).
bit_pick(BP,BP2) -->
	(
			[tokLRec],expression(Exp),[tokRRec],!,
			{ BP = bitsel(no, BP2, Exp) }
	).
bits_pick(BPS,BPS2) -->
	(
			[tokLRec],expression(Exp1),[tokDots],expression(Exp2),[tokRRec],!,
			{ BPS = bitsel(no, BPS2, Exp1, Exp2)  }	
	).
atom_expr(Exp_a) -->
	(
			[tokVar(X)],[tokLParen],expression(Exp),[tokRParen],!,
			{ Exp_a = call(no, X, Exp) }
		;	[tokVar(X)],!,
			{  Exp_a = var(no, X) }
		;	[tokNumber(X)],!,
			{ Exp_a = num(no, X) }	
		;	[tokLRec],[tokRRec],!,
			{ Exp_a = empty(no) }
		;	[tokLRec], expression(Exp),[tokRRec],!,
			{ Exp_a = bit(no, Exp) }
	).

test(String, Res):-
		string_codes(String,List),
		phrase(lexer(TokList),List),
		print(TokList),nl,
		phrase(program_(Res),TokList).

parse(_,[],[]):-!.
parse(_,Codes, Program) :-
   phrase(lexer(TokList), Codes),
   phrase(program_(Program_), TokList),
   Program = Program_.
   
