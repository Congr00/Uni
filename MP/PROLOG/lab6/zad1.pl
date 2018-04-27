stos_put(El, Stos, [El|Stos]).
stos_get([H|Stos], H, Stos).
stos_empty([]).

stos_addall(Element, Goal, Stos, Result):-
		findall(Element, Goal, GList),
		stos_putlist(GList, Stos, Result).

stos_putlist([], Res, Res):-!.
stos_putlist([H|T], Stos, Res):-
		stos_put(H, Stos, SR),
		stos_putlist(T, SR, Res).


male(lukas).
male(sakul).


kolejka_put(El, A-[El|B], A-B).
kolejka_get([H|T]-X,H,T-X).

empty(X-X).

kolejka_addAll(El, Goal, Kol, Result):-
		findall(El, Goal, List),
		kolejka_putlist(List, Kol, Result).

kolejka_putlist([], Res, Res):-!.
kolejka_putlist([H|T], Kol, Res):-
		kolejka_put(H, Kol, NKol),
		kolejka_putlist(T, NKol, Res).



check(X):-
	empty(XX),
	kolejka_put(4,XX,XXX),
	kolejka_put(6,XXX,XXXX),
	kolejka_put(10,XXXX,XXXXX),
	kolejka_get(XXXXX, Y, Res),
	kolejka_get(Res, V, Res2),
	print(Res2),nl,
	kolejka_addAll(X, male(X), Res2, Res3),
	X = Res3.


