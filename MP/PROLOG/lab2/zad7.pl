perm([],[]).
perm([H|T], L):-
	select(H, L, X),
	perm(T, X).
