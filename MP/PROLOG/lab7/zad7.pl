


!(0,1):-!.
!(X,Y):-
		X1 is X - 1,
		!(X1,Y1),
		Y is X * Y1.
:-arithmetic_function(!/1).
:-op(100, yf, !).

'!!'(-1,1):-!.
'!!'(0,1):-!.
%'!!'(1,1):-!.
'!!'(2,2):-!.
'!!'(N,R):-
		0 is N mod 2,
		N1 = N - 1,!,
		'!!'(N1,R).
'!!'(N,R):-
		Ntmp is N - 2,
		'!!'(Ntmp, Rtmp),
		R is N * Rtmp.
:-arithmetic_function('!!'/1).
:-op(100,yf,'!!').
