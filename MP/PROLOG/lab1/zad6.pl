polaczenie(wroclaw,warszawa).
polaczenie(wroclaw,krakow).
polaczenie(wroclaw,szczecin).
polaczenie(szczecin,lublin).
polaczenie(szczecin,gniezno).
polaczenie(warszawa,katowice).
polaczenie(gniezno,gliwice).
polaczenie(lublin,gliwice).

connection(X,Y):-
	polaczenie(X,Y).
connection(X,Y):-
	polaczenie(X,Z),
	connection(Z,Y).
