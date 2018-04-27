head(H,[H|_]).
%head([],[]).

last([H|[]],H):-
	!.
last([_|T],H):-
	last(T,H).

tail(T,[_|T]).

init([_|[]], []):-
	!.
init([H|L],[H|T]):-
	init(L,T).

prefix([], _).
prefix([P|T],[P|L]):-
	prefix(T,L).

suffix(L,S):-
	reverse(L,X),
	reverse(S,Y),
	prefix(Y,X).

suffixv2(L,L).
suffixv2([_|T],L):-
	suffixv2(T,L).


