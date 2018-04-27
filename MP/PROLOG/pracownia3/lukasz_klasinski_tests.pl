% Definiujemy moduł zawierający testy.
% Należy zmienić nazwę modułu na {imie}_{nazwisko}_tests gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez wielkich liter oraz znaków diakrytycznych
:- module(lukasz_klasinski_tests, [tests/3]).

% Zbiór faktów definiujących testy
% Należy zdefiniować swoje testy
tests(empty_program, input(""), program([])).
tests(invalid, input("def main()"), no).
tests(adder, file('adder.hdml'), yes).
tests(srcpos, input("def main(_) = 1"),
  program([def(main, wildcard(file(test, 1, 10, 9, 1)), num(no, 1))])).
tests(caller, file('caller.hdml'), yes).
tests(wrong_wyr, file('wrong_wyr.hdml'), no).
tests(semi_compl, file('semi_compl.hdml'), yes).
tests(with_tree, file('with_tree.hdml'), 
  program([def(test, wildcard(no), num(no, 10)), def(test2, var(no, 'A'), 
  pair(no, call(no, test2, num(no, 10)), call(no, test2, num(no, 20))))])).

tests(with_nums, input("def fuu (A) = 2 / 2 * 2"), 
program([
def(fuu, var(file(test, 1, 10, 9, 1),'A'),
		op(file(test, 1, 17, 16, 1), '*', op(
			file(test, 1, 21, 20, 1), '/', num(file(test, 1, 19, 18, 1), 2), num(file(test, 1, 23, 22, 1), 2)),
	num(file(test, 1, 15, 14, 1),2)))])).
tests(with_num2, file('with_num2.hdml'), 
program(
[
def(foo, var(file('with_num2.hdml', 1, 9, 8, 1), 'A'),
	op(file('with_num2.hdml', 2, 4, 15, 1), '=', var(file('with_num2.hdml', 2, 2, 13, 1), 'A'),
		op(file('with_num2.hdml', 2, 8, 19, 1), '-', var(file('with_num2.hdml', 2, 6, 17, 1), 'A'), 
			num(file('with_num2.hdml', 2, 10, 21, 2), 21)))	
),
def(goy, pair(file('with_num2.hdml', 3, 9, 31, 3),
		var(file('with_num2.hdml', 3, 9, 31, 1), 'N'), var(file('with_num2.hdml', 3, 11, 33, 1), 'M')),
		if(file('with_num2.hdml', 4, 2, 38, 31),
			op(file('with_num2.hdml', 4, 7, 43, 2), '<>', 
				var(file('with_num2.hdml', 4, 5, 41, 1), 'N'),
				var(file('with_num2.hdml', 4, 11, 46, 1), 'M')),
			op(file('with_num2.hdml', 4, 20, 55, 1), '=',
				var(file('with_num2.hdml', 4, 18, 53, 1), 'N'),
				var(file('with_num2.hdml', 4, 22, 57, 1), 'M')),
			op(file('with_num2.hdml', 6, 4, 66, 1), '=',
				var(file('with_num2.hdml', 6, 2, 64, 1), 'M'),
				var(file('with_num2.hdml', 6, 6, 68, 1), 'N'))

)
)
]
)).

