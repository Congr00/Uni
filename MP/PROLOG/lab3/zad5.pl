
insert([], EL, [EL]).

insert([H|T], EL, [EL,H|T]):-
	H =< EL,
		!.
insert([H|T], EL,[H|Res]):-
	H > EL,
	insert(T, EL, Res).


ins_sort([],[]).
ins_sort([H|T],Res):-
	ins_sort(T,SRes),
	insert(SRes, H, Res),
	!.

ins_sort2([],[]).
ins_sort2([H|T], Res):-
	insert([],H, Res),
	ins_sort2(T, Res).
