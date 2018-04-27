
%dom(kolor, wlasciciel, zwierze, papierosy, napoj, numer).

po_lewej(1,2).
po_lewej(2,3).
po_lewej(3,4).
po_lewej(4,5).
po_prawej(5,4).
po_prawej(4,3).
po_prawej(3,2).
po_prawej(2,1).

%1 
dom(czerwony, anglik, _, _, _, _).
%2 
dom(_, hiszpan, pies, _, _, _).
%3 
dom(zielony, _, _, _, kawa, _).
%4 
dom(_, ukrainiec, _, _, herbata, _).
%5 
dom(zielony, _, _, _, _, X):-
	dom(bialy, _, _, _, _, Y),
	po_lewej(X,Y).
dom(zielony, _, _, _, _, X):-
	dom(bialy, _, _, _, _, Y),
	po_prawej(X,Y).
%6 
dom(_, _, waz, winston, _, _).
%7 
dom(zolty, _, _, kool, _, _).
%8 
dom(_, _, _, _, mleko, 3).
%9 
dom(_, norweg, _, _, _, 1).
%10 
dom(_, _, _, chesterfield, _, X):-
	dom(_, _, lis, _, _, Y),
	po_lewej(X,Y).
dom(_, _, _, chesterfield, _, X):-
	dom(_, _, lis, _, _, Y),
	po_prawej(X,Y).
%11 
dom(_, _, _, kool, _, X):-
	dom(_, _, kon, _, _, Y),
	po_lewej(X,Y).
dom(_, _, _, kool, _, X):-
	dom(_, _, kon, _, _, Y),
	po_prawej(X,Y).
%12 
dom(_, _, _, lucky_strike, sok, _).
%13 
dom(_, japonczyk, _, kent, _, _).
%14 
dom(_, norweg, _, _, _, X):-
	dom(niebieski, _, _, _, _, Y),
	po_lewej(X,Y).
dom(_, norweg, _, _, _, X):-
	dom(niebieski, _, _, _, _, Y),
	po_prawej(X,Y).
dom(_,_,slon,_,_,_).
dom(_,_,_,_,wodka,_).
dom(_,_,_,_,_,2).
dom(_,_,_,_,_,3).
dom(_,_,_,_,_,4).
dom(_,_,_,_,_,5).
ele_owner(X):-
	dom(_,X,slon,_,_,_).
