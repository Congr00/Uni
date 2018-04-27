revall([],[]):- !.
revall( [H|T], X ) :-
		!,
		revall(H, RH),
		revall(T, RT),
		append(RT,[RH],X).
revall(X,X).

