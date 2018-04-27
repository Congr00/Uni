factorial(0,1):-
	!.
factorial(N,M):-
	X is N - 1,
	factorial(X,Y),
	M is Y * N.


concat_num(Num, Digits):-
	concat_num(Num, 0, Digits).


concat_num(Acc, Acc, []).
concat_num(Num, Acc, [H|T]):-
		AccNew is (Acc * 10) + H,
		concat_num(Num, AccNew, T).

decimal(Num, Digits):-
	decimal(Num, [], Digits).

decimal(0, Res, Res):-
	!.

decimal(Num, Acc, Res):-
	Digit is Num mod 10,
	NewNum is Num // 10,
	decimal(NewNum, [Digit|Acc],Res).

