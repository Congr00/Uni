ptaki(_).
ryby(_).
dzdzownica(_).
kot(my_cat).

przyjaciel(my_cat,me).

lubi(X,Y):-
	przyjaciel(X,Y).
lubi(X,Y):-
	przyjaciel(Y,X).
lubi(X,Y):-
	ptaki(X),
	dzdzownica(Y).
lubi(X,Y):-
	kot(X),
	ryby(Y).
je(my_cat,Y):-
	lubi(my_cat,Y).
	
