
mirror(leaf, leaf).
mirror(node(Left,Val, Right), node(RLeft, RVal, RRight)):-
		mirror(Left, RRight),
		mirror(Right, RLeft).

flatten(leaf, []).
flatten(node(Right, Val, Left), List):-
		flatten(Right, ListR),
		flatten(Left, ListL),
		append(ListL, [Val|ListR], List).

