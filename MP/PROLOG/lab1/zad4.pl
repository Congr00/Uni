parent(adam,helen).
parent(eve,helen).
parent(adam,ivonne).
parent(eve,ivonne).
parent(adam,anna).
parent(eve,anna).
parent(helen,joshua).
parent(john,joshua).
parent(ivonne,david).
parent(mark,david).

male(adam).
male(john).
male(joshua).
male(mark).
male(david).

female(eve).
female(helen).
female(ivonne).
female(anna).

sibling(A,B):-
	parent(X,A),
	parent(X,B).
sister(A,B):-
	sibling(A,B),
	female(A).
grandson(A,B):-
	parent(X,A),
	parent(B,X),
	male(A).
cousin(A,B):-
	parent(X,A),
	parent(Y,B),
	sibling(X,Y),
	male(A).
descendant(A,B):-
	parent(A,B).
descendant(A,B):-
	parent(A,X),
	descendant(X,B).
is_mother(A):-
	parent(A,_),
	female(A).
is_father(A):-
	parent(A,_),
	male(A).



