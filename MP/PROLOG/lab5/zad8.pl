
check_p(X, [H|T]):-
		number(H),!,
		print("im in"),
	 	X1 is X mod H,
		X1 =\= 0,
		check_p(X,T).
check_p(_,_).
prime(X,_,N):-
		number(X),
		X < N,
	   	!,
		fail.	

prime(X,H-_,N):-
		check_p(N,H),
		number(X),
		X = N,!.
prime(X,H-_,N):-
		check_p(N,H),
		X = N.	
prime(X, H-E, N):-
	check_p(N,H),
	E = [N|END],!,
	N1 is N + 1,
	prime(X, H-END,N1).
prime(X, H-E, N):-
	N1 is N + 1,
	prime(X, H-E, N1).


prime(X):-
		prime(X, H - H, 2).

