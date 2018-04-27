perm([], []).
perm([H|T], X):-
	perm(T, P),
	select(H, X, P).
	
