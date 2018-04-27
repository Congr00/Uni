

%mergesort(List, N, Res)

next_n(L,0,L):-!.
next_n([_|T],N,Res):-
		N1 is N - 1,
		next_n(T,N1,Res).

mergesort([],_,[]):-!.
mergesort([H|_], 1, [H]):-!.

mergesort(List, N, Sorted):-
		N1 is N div 2,
		N2 is N - N1,
		mergesort(List,N1,SL),
		next_n(List,N1, NList),
		mergesort(NList,N2,SR),
		merge(SL,SR,Sorted).
