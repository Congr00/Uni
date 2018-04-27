even([]).
even([_|T]):-
	odd(T).
odd([_|T]):-
	even(T).	

palindrom(X) :-
	reverse(X,Y),
	X = Y.

singleton([_|T]):-
	T = [].
