Napisany został normalizator, funkcja sprowadzająca termy do CBN oraz porównywarka beta termów. Wszystko opakowane w parser oraz lekser.

    Normalizator - jest implementacją maszyny Krivina, korzystającej z kontekstów oraz indeksów de Bruija'a. Wczytuje on cały term i normalizuje w tak zwanym trybie BIG STEP.
W pierwszej kolejności sparsowany input dostaje nowe, świeże zmienne do nowo utworzonych lambd, konwersja zmiennych na numerały Bruijna'a, po czym zostaje wykonana lambda-redukcja.
Otrzymany output jest ma nastepnie normalizowane oraz odtworzone oryginalne zmienne(jeśli takowe się zachowały wna wyjściu). Wyjście jest printowany za pomocą pretty printera i nadaje się do
powtórnej ewaluacji (wyjściowe wyrażenie lamba jest zgodne z używanym przez lekser językiem).

Beta Equality - został napisany uzywając Normalizatora - oba termy są redukowane i normalizowane, a następnie porównywane struktualnie ze sobą.

Lexer + Parser - został zbudowany za pomocą Menhira, korzystając z template'a z tapl'a. Poniżej dozwolone operacje:

x - zmienna x
n - int
lambda xy.(e) - lambda ze zmienną "xy"(nawasy wymagane)
e1 e2 - aplikacja
x1 +/*/-/= x2 - dodawanie/mnożenie/odejmowanie/porównywanie
true/false - stałe
if e then e else e - if
(fix e) - fix (nawiasy wymagane)
pair (e, e) - para
fst/snd (e, e) - operatory na parze
| - ogon listy
cons e - (1 : 2 : 3 : |) - lista [1,2,3]
isnil e - czy lista = |
tail/head e - operacje na liscie

lambda n. ((fix lambda f. (lambda n. (if n = 0 then 1 else n * (f (n - 1))))) n) 4   - przykładowy program liczący 4!
lambda x.(lambda y. (if x = y then x else y)) 2 2                                    - przykładowy if

W testach można znaleźć więcej przykładów użycia.

Wszystkie  wyżej wymienione operacje, są przed ewaluacją zamieniane w odpowiedniki lambdy, literały Church'a, a zmienne w indeksy de Bruijna.
Konwecja outputu jest taka, że wszystkie świerze zmienne są postaci _x1, _x2, ... Dzięki temu, że parser nie pozwala zmiennym mieć "_" w nazwie, to nie ma możliwości kolizji.

Np program uruchomiony na "lambda x.(lambda y.(x + y)))" zwrócił 
lambda x. (lambda y. (lambda _x0. (lambda _x1. (((x _x0) ((y _x0) _x1))))))
Po zamianie zmiennych na dozwolone otrzymamy:
lambda x. (lambda y. (lambda x0. (lambda x1. (((x x0) ((y x0) x1))))))

teraz uruchomiając
lambda x. (lambda y. (lambda x0. (lambda x1. (((x x0) ((y x0) x1)))))) 2 2
otrzymamy:
lambda x0. (lambda x1. ((x0 (x0 (x0 (x0 x1))))))
Co oczywiście oznacza 4 w konwensji lambda (możemy to sprwadzić uruchamiając ./f out.t in.t -int)

Uzywanie programu:

Kompilacja:  make
Czyszczenie: make clean

po kompliacji:
./f out in1 [in2] [-int] [-cbn] 

- in1 to wejściowy plik z kodem
- in2 to opcjonalny plik z 2 programem, po jego podaniu zostanie przeprowadzona automatycznie beta redukcja
- -int - po podaniu wyjście zostanie przetłumaczone jako liczba naturalna w literałach Churcha i zapisana jako int
- -cbn - dane wyrazenie zostanie sprowadzone do postaci CBN i zwrócone na output

Struktura kodu:

main.ml - obsługa argumentów i uruchamianie ewaluatorów
core.ml - normalizatory
parser.mly - parser menhir
lexer.mll - lekser do języka
support.ml funkcje pomocnicze dla lexera z tapl'a
syntax.ml - funkcje pomocnicze operujace na lambda termach oraz odcukrzające język.
/tests/ - podstawowe testy