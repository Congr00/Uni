perm2([],[]):-!.
perm2(X,Y):-
	var(X),
	perm2(Y,X).
perm2(L,[PH|PT]):-
  select(PH, L, LT),
  perm2(LT, PT).
