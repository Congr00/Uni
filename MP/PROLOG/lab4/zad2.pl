conn(szczecin, gdansk).
conn(gdansk,warszawa).
conn(warszawa, katowice).
conn(katowice, wroclaw).
conn(wroclaw,opole).
conn(warszawa,opole).
conn(opole,szczecin).
conn(szczecin,opole).
conn(opole,lodz).
conn(lodz,warszawa).
conn(lodz,katowice).
conn(katowice,warszawa).


trip(From, Dest, [From|List]):-
		trip(From, Dest, List, [Dest]).

trip(From, Dest, List, List):-
		conn(From, Dest).

trip(From, Dest, List, Visited):-
		conn(X, Dest),
		\+ member(X, Visited),
		trip(From, X, List, [X|Visited]).
