
lista([_]).
lista([_|X]):-
		lista(X).


next([]).
next([0|X]):-
		next(X).
next([1|X]):-
		next(X).

bin([0]).
bin([1]).

bin([1|X]):-
	lista(X),
	next(X).


rnext([1]).
rnext([1|X]):-
		rnext(X).
rnext([0|X]):-
		rnext(X).

rbin([0]).
rbin(X):-
		lista(X),
		rnext(X).
