


insert(leaf, Val, node(leaf,Val,leaf).
insert(node(Left, NVal, Right), Val, node(Left, NVal, NRight)):-
		NVal >= Val,
		insert(Right, Val, NRight).
insert(node(Left, NVal, Right), Val, node(NLeft, NVal, Right)):-
		NVal < Val,
		insert(Left, Val, NLeft).


treesort(List, Sorted):-
		treesort(List, Tree, leaf),
		flatten(Tree, Sorted).

treesort([], Tree, Tree).
treesort([H|T], Tree, CTree):-
		insert(CTree, H, NTree),
		treesort(T, Tree, NTree).


