% Definiujemy moduł zawierający testy.
% Należy zmienić nazwę modułu na {imie}_{nazwisko}_tests gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez wielkich liter oraz znaków diakrytycznych
:- module(lukasz_klasinski_tests, [resolve_tests/5, prove_tests/4]).

% definiujemy operatory ~/1 oraz v/2
:- op(200, fx, ~).
:- op(500, xfy, v).

% Zbiór faktów definiujących testy dla predykatu resolve
% Należy zdefiniować swoje testy
resolve_tests(simple_test, q, p v q, ~q v r, p v r).
resolve_tests(simple_double_test, q, p v q v p, ~q v r, p v r).
resolve_tests(simple_double_rev_test, q, p v q, ~q v ~q v r, p v r).
resolve_tests(other_names, que, pi v que, ~que v ro, pi v ro).
resolve_tests(always_false, p, p v ~p, p v ~p, []).
resolve_tests(always_false_doubles, p, p v p, ~p v ~p, []).
%resolve_tests(empty, x, [], [], []).
resolve_tests(tricky, q, p v q, p v ~p v ~q, p).

% Zbiór faktów definiujących testy dla predykatu prove
% Należy zdefiniować swoje testy
prove_tests(example, validity, [p v q v ~r, ~p v q, r v q, ~q, p], unsat).
prove_tests(excluded_middle, validity, [p v ~p], sat).
prove_tests(simple_val, validity, [p v q v t, ~p v ~t], sat).
prove_tests(ex_simple, validity, [p v t v y v u, ~p, ~t, ~y, ~u], unsat).
prove_tests(ps_and_qs, validity, [p v q, ~p v q, p v ~q, ~p v ~q], unsat).
prove_tests(four_of_us, validity, [p v r, ~r v ~s, q v s, q v r, ~p v ~q, s v p], unsat).
prove_tests(is_solv, validity, [p v q v r, ~r v ~q v ~p, ~q v r, ~r v p], sat).
prove_tests(four_of_us2, validity, [~p v q, ~p v ~r v s, ~q v r, p, ~s], unsat).
prove_tests(wrong_order, validity, [~p, ~q v ~a, ~r v q, p v a v ~q v r], unsat).
prove_tests(empty_clauses, validity, [], sat).
prove_tests(double_empty, validity, [[]], unsat).
prove_tests(singleton, validity, [p], sat).

% perf

prove_tests(no_negs, performance, [p v q, q v t, t v g, g v b, b v n, n v m, m v x, x v z, z v f, f v r, r v t, t v y, y v u, u v i, i v l, l v p, p v q, q v t], sat).
prove_tests(only_negs, performance, [~p v ~q, ~q v ~t, ~t v ~g, ~g v ~b, ~b v ~n, ~q v ~m, ~q v ~t, ~t v ~y, ~u v ~i, ~i v ~p, ~z v ~r, ~r v ~w, ~w v ~q, ~q v ~b], sat).
prove_tests(many_repeaters, performance, [p v p v p v p v p v p v t v t v t v t v t v t v t, p, p,p,p,p,p,t,t,t,t,t,t,t v p, t v p, t v p, t v p, t v t v t v t v t v t v t v p v p v p v p v p v p], sat).
prove_tests(doable, performance, [p, p v b v n v t v y, y v u v i v q v e, r v b v m v k v f, g v s v r v e v w, b v t v w v a v q v c, c v x v d v f v r v t v h v j, k v l v p v q v p v p v z v x v d, g v f v r v e v w v n, ~p], unsat).

