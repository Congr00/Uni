sublist(_,[]).
sublist([H|T], [H|S]):-
	sublist(T,S).
sublist([_|T], S):-
	sublist(T,S).


sublistv2(X,Y):-prefix(Y,X).
sublistv2([_,T],Y):-sublistv2(T,Y).
