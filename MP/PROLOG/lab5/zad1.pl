

appn([Res],Res):-!.
appn([H1,H2|T], Res):-
	append(H1,H2,H3),
	appn([H3|T],Res).

appn2([],[]):-!.
appn2([[]|T], Res):-!,
		appn2(T, Res).
appn2([[H|T]|T2], [H|Res]):-!,
		appn2([T|T2],Res).
