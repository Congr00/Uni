% Definiujemy modul zawierajacy testy.
% Nalezy zmienic nazwe modulu na {imie}_{nazwisko}_tests gdzie za
% {imie} i {nazwisko} nalezy podstawic odpowiednio swoje imie
% i nazwisko bez znakow diakrytycznych

:- module(lukasz_klasinski_tests, [tests/5]).

% definiujemy operatory ~/1 oraz v/2
:- op(200, fx, ~).
:- op(500, xfy, v).

% Zbior faktow definiujacych testy
% Nalezy zdefiniowac swoje testy

% validity tests

tests(excluded_middle, validity, [p v ~p], 500, solution([(p,t)])).
tests(excluded_middle_v2, validity, [p v ~p], 500, solution([(p,f)])).
tests(singleton, validity, [p], 500, solution([(p,t)])).
tests(triplet, validity, [p v ~p v q], 500, solution([(p,t),(q,t)])).
tests(triplet_v2, validity, [p v ~p v q], 500, solution([(p,t),(q,f)])).
tests(triplet_v3, validity, [p v ~p v q], 500, count(4)).
tests(false, validity, [p v q, ~q, ~p], 500, count(0)).
tests(only_one, validity, [p v q, ~p v t, ~t, q], 500, count(1)).
tests(empty, validity, [], 500, count(0)).
tests(few, validity, [p,q,t,x,y], 500, solution([(p,t),(q,t),(t,t),(x,t),(y,t)])).
tests(few_v2, validity, [p v q, q v t, t v x, x v y, y v p], 500, solution([(p,t),(q,t),(t,t),(x,t),(y,t)])).
tests(kitty, validity, [k v i, i, t, t v y], 500, count(4)).
tests(false_matter, validity, [~f v ~a, ~a, ~f, ~t, ~f v ~t], 500, solution([(f,f),(a,f),(t,f)])).
tests(false_v2, validity, [p v r, ~r v ~s, q v s, q v r, ~p v ~q, s v p], 500, count(0)).
tests(false_v3, validity, [p v q, ~p v q, p v ~q, ~p v ~q], 500, count(0)).
tests(false_v4, validity, [~p v q, ~p v ~r v s, ~q v r, p, ~s], 500, count(0)).
tests(simple, validity, [p v q v r, ~r v ~q v ~p, ~q v r, ~r v p], 500, solution([(p,t),(q,f),(r,f)])).
tests(only_one_v2, validity, [p v q v t v y v x, p, q, t, y, x], 500, count(1)).
tests(why_me, validity, [~p v ~q v ~t, p, q, ~t v ~p v ~q], 500, solution([(p,t),(q,t),(t,f)])).

% perf tests

tests(too_easy, performance, [p v q, ~q, ~p, w v t, t v y, u v n, m v n, l v i, i v e, e, ~t, l v p, l v c, c v t, q v x, ~x, q v u, q v p], 10000, count(0)).
tests(many_of_us, performance, [p v q, p v w, p v e, p v r, p v t, p v y, p v u, p v i, p v o, p v a, p v s, p v d, p v f, p v g, p v h, p v j, p v k, p v l, p v z, p v x, p v c, p v b, p v n, p v m,
q v p, q v w, q v e, q v r, q v t, q v y, q v u, q v i, q v o, q v a, q v s, q v d, q v f, q v g, q v h, q v j, q v k, q v l, q v z, q v x, q v c, q v b, q v n, q v m], 10000, solution([(p,t),(q,t),(w,f),(e,f),(r,f),(t,f),(y,f),(u,f),(i,f),(o,f),(a,f),(s,f),(d,f),(f,f),(g,f),(h,f),(j,f),(k,f),(l,f),(z,f),(x,f),(c,f),(v,f),(b,f),(n,f),(m,f)])).
tests(last_of_us, performance, [p v q, p v w, p v e, p v r, p v t, p v y, p v u, p v i, p v o, p v a, p v s, p v d, p v f, p v g, p v h, p v j, p v k, p v l, p v z, p v x, p v c, p v b, p v n, p v m,
q v p, q v w, q v e, q v r, q v t, q v y, q v u, q v i, q v o, q v a, q v s, q v d, q v f, q v g, q v h, q v j, q v k, q v l, q v z, q v x, q v c, q v b, q v n, q v m, ~q v ~p], 10000, count(0)).
tests(singletons, performance, [q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,b,n,m,~q,~w,~e,~r,~t,~y,~u,~i,~o,~p,~a,~s,~d,~f,~g,~h,~j,~k,~l,~z,~x,~c,~b,~n,~m], 1000, count(0)).
tests(big_one, performance, [p v q, p v w, p v e, p v r, p v t, p v y, p v u, p v i, p v o, p v a, p v s, p v d, p v f, p v g, p v h, p v j, p v k, p v l, p v z, p v x, p v c, p v b, p v n, p v m,
q v p, q v w, q v e, q v r, q v t, q v y, q v u, q v i, q v o, q v a, q v s, q v d, q v f, q v g, q v h, q v j, q v k, q v l, q v z, q v x, q v c, q v b, q v n, q v m,
w v p, w v q, w v e, w v r, w v t, w v y, w v u, w v i, w v o, w v a, w v s, w v d, w v f, w v g, w v h, w v j, w v k, w v l, w v z, w v x, w v c, w v b, w v n, w v m,
e v p, e v w, e v q, e v r, e v t, e v y, e v u, e v i, e v o, e v a, e v s, e v d, e v f, e v g, e v h, e v j, e v k, e v l, e v z, e v x, e v c, e v b, e v n, e v m,
r v p, r v w, r v q, r v e, r v t, r v y, r v u, r v i, r v o, r v a, r v s, r v d, r v f, r v g, r v h, r v j, r v k, r v l, r v z, r v x, r v c, r v b, r v n, r v m]
,10000, solution([(p,t),(q,t),(w,t),(e,t),(r,t),(t,f),(y,f),(u,f),(i,f),(o,f),(a,f),(s,f),(d,f),(f,f),(g,f),(h,f),(j,f),(k,f),(l,f),(z,f),(x,f),(c,f),(v,f),(b,f),(n,f),(m,f)])).
