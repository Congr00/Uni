

cr_table([],[]).
cr_table([H|T],[[H]|Res]):-
		cr_table(T,Res).

mergesort_rev(List, Res):-
		cr_table(List, TbList),
		mergesort_rev(TbList, Res, []).

mergesort_rev([H], Acc, Res):-!,
		mergesort_rev([H|Res],Acc,[]).
mergesort_rev([],Res,[Res|[]]):-!.
mergesort_rev([],Acc,Res):-!,
		mergesort_rev(Res,Acc,[]).
mergesort_rev([H1,H2|T], Acc, Res):-
		merge(H1,H2,M),
		mergesort_rev(T,Acc,[M|Res]).

