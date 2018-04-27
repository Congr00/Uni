
length2(X,Y):-
		length2(X,Y,0).

length2([],Y,Y).
length2([_|T], Y, Acc):-
		Acc \== Y,
		Nacc is Acc + 1,
		length2(T, Y,Nacc).
			

