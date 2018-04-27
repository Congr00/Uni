
%merge(L1,L2, Res)

merge([],Rest,Rest):-!.
merge(Rest,[],Rest):-!.

merge([H|T],[H2|T2],[H|Res]):-
		H < H2,!,
	   	merge(T,[H2|T2],Res).
merge([H|T],[H2|T2],[H2|Res]):-
		merge([H|T],T2,Res).


mergesort([],[]):-!.
mergesort([X],[X]):-!.
mergesort(List,Sort):-
		halve(List,L,R),
		mergesort(L,Resl),
		mergesort(R,Resr),
		merge(Resl,Resr,Sort).
