
halve(List, L, R):-
		halve(List,List, L, R).
halve([H|T], [_,_|T2], [H|L], R):-
		halve(T, T2, L, R),!.
halve(R, _, [], R).
