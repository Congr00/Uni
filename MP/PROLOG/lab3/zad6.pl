reverse_(X,Y):-
	var(X),
	reverse_(Y,X),!.
reverse_(X,Y):-
	reverse_(X,[],Y).


reverse_([],A,A).
reverse_([H|T],A,Y):-
	reverse_(T, [H|A],Y).
