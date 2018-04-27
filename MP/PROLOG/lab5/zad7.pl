
split([], _, [], []).
split([H|T],M,[H|S],B):-
		H < M,!,
		split(T,M,S,B).
split([H|T],M,S,[H|B]):-
		split(T,M,S,B).

qsort(List, Res):-
		qsort(List, Res, []).
qsort([], Res, Res):-!.
qsort([H|T], Sort, Acc):-
		split(T,H,S,B),
		qsort(B, Acc1, Acc),
		qsort(S, Sort, [H|Acc1]).

