
r([]).
r([H|T]):-
		q(H),
		r(T).


p(a):-!.
q(X):-p(X).
q(b).

from(N,N).
from(N,M):-
		N1 is N+1,
		from(N1,M).

w(X-X, N, N).
w([_|T]-X, N, M):-
		N1 is N+1,
		w(T-X, N1, M).
w(X-Y, N):-
		w(X-Y,0,N).

czworkami([H|T], A):-
	A1 is A+1,
	czworkami(T, A1).
czworkami([],A):-
	print(A),
	0 is A mod 4.
