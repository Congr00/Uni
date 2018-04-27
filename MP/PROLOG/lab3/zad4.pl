
select_min([H|T], Min, Rest):-
	select_min(T, Min, Restrev, [], H),
	reverse(Restrev, Rest).

select_min([], Min, Rest, Rest, Min).
select_min([H|T], Min, TRest, Rest, CMin):-
	H >= CMin,
	!,
	select_min(T, Min, TRest, [H|Rest], CMin).
select_min([H|T], Min, TRest, Rest, CMin):-
	H < CMin,
	select_min(T, Min, TRest, [CMin|Rest], H).

sel_sort([],X,X):-!.
sel_sort(X, Y):-
	sel_sort(X,[], Res),
	Y = Res.
sel_sort(USort, Sort, Res):-
	select_min(USort, Min, Rest),
	sel_sort(Rest, [Min|Sort], Res).
