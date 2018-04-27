po_lewej(1,2).
po_lewej(2,3).
po_lewej(3,4).
po_lewej(4,5).
po_prawej(5,4).
po_prawej(4,3).
po_prawej(3,2).
po_prawej(2,1).

sasiad(X,Y):-
	numer(X,X1),
	numer(Y,Y1),
	po_lewej(X1,Y1).
sasiad(X,Y):-
	numer(X,X1),
	numer(Y,Y1),
	po_prawej(X1,Y1).

mieszka(anglik,czerwony).
zwierze(hiszpan,pies).
pije(X, kawa):-
	mieszka(X,zielony).
pije(ukrainiec,herbata).
mieszka(X,zielony):-
	sasiad(X,Y),
	mieszka(Y,bialy).
zwierze(X,waz):-
	pali(X,winstony).
mieszka(X,zolty):-
	pali(X, koole).
pije(X,mleko):-
	numer(X,3).
numer(norweg,1).
pali(X,chestfieldy):-
	sasiad(X,Y),
	zwierze(Y,lis).
pali(X,koole):-
	sasiad(X,Y),
	zwierze(Y,kon).
pali(X,lucky_strike):-
	pije(X,sok).
pali(japonczyk,kenty).
mieszka(X,niebieski):-
	sasiad(X,norweg).

pali(X,Y):-
	czlowiek(X),
	fajka(Y).
zwierze(X,Y):-
	czlowiek(X),
	zwierz(Y).
mieszka(X,Y):-
	czlowiek(X),
	kolor(Y).
pije(X,Y):-
	czlowiek(X),
	napoj(Y).
number(X,Y):-
	czlowiek(X),
	pozycja(Y).

dom(K,W,Z,F,P,N):-
	czlowiek(W),
	mieszka(W,K),
	zwierze(W,Z),
	pali(W,F),
	pije(W,P),
	numer(W,N).
	

czlowiek(anglik).
czlowiek(hiszpan).
czlowiek(norweg).
czlowiek(japonczyk).
czlowiek(ukrainiec).

kolor(czerwony).
kolor(zielony).
kolor(bialy).
kolor(zolty).
kolor(niebieski).

napoj(kawa).
napoj(herbata).
napoj(mleko).
napoj(sok).
napoj(wodka).

zwierz(pies).
zwierz(lis).
zwierz(kon).
zwierz(waz).
zwierz(slon).

fajka(winstony).
fajka(koole).
fajka(chesterfieldy).
fajka(lucky_strike).
fajka(kenty).

pozycja(1).
pozycja(2).
pozycja(3).
pozycja(4).
pozycja(5).

