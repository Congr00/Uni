insert(leaf, Value, node(leaf, Value, leaf)).
insert(node(Left, NValue, Right), Value, node(Left, NValue, InsertedRight)):-
		Value >= NValue,!,
		insert(Right, Value, InsertedRight).
insert(node(Left, NValue, Right), Value, node(InsertedLeft, NValue, Right)):-
		insert(Left, Value, InsertedLeft).


find(Element, node(_, Element, _)):-!.
find(Element, node(Left, El, _)):-
		Element < El,!,
		find(Element, Left).
find(Element, node(_,_,Right)):-
		find(Element, Right),!.

findMax(node(_,Val,leaf), Val):-!.
findMax(node(_,_, Right), Res):-
		findMax(Right, Res.

findMin(node(leaf,Val,_),Val):-!.
findMIn(node(Left,_,_),Res):-
		findMax(Left, Res).


empty(leaf).


delete(_,leaf,leaf):-!.
delete(Val, node(leaf,Val,leaf),leaf):-!.
delete(Val, node(leaf, Val, Right), Right):-!.
delete(Val, node(Left, Val, leaf), Left):-!.
delete(Val, node(Left, Val, Right), node(Left, RightMin, NRight)):-
		findMin(Right, RightMin),!,
		delete(RightMin, Right, NRight).

delete(Val, node(Left, NVal, Right), node(CLeft, NVal, CRight)):-
		delete(Val, Left, CLeft),
		delete(Val, Right, CRight).

