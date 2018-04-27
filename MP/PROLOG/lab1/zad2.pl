mily(X):-
	czlowiek(X),
	odwiedza_zoo(X).

styka_sie(X,Y):-
	zwierze(X),
	mieszka_zoo(X),
	czlowiek(Y),
	odzwiedza_zoo(Y).

szczesliwy(X):-
	zwierze(X),
	styka_sie(X,Y),
	mily(Y).

nieszcz_smok(X):-
	mieszka_zoo(X),
	szczesliwy(X).

zwierze(X):-
