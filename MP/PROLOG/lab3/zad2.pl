filter([],[]).

filter([H|TL],[H|TP]):-
	H >= 0,
	!,
	filter(TL,TP).

filter([HL|TL],P):-
	HL < 0,
	filter(TL,P).

count(_,[],0).
count(H, [H|TP], N):-
	count(H, TP, X), !,
	N is X + 1.

count(H, [_|T], N):-
	count(H, T, N).

expo(B, E, RES):-
	RES is B^E.
