

flatten(List, Res):-
		flatten(List, Res, []).

flatten([], Res,Res).
flatten([[H|[]]|T2], Acc, Res):-
	flatten(T2, Acc, [H|Res]).
flatten([[H|T1]|T2], Acc, Res):-
	flatten(T1, Acc, [H|Res]),
	flatten(T2, Acc, Res).
