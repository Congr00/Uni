---
title:  Zadanie 1 z listy 5 - "Kompresja Danych"
author: Łukasz Klasiński
date: \today
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
---

## Zadanie 1
Przyjmijmy, że w algorytmie LZ77 rozmiar bufora słownikowego jest równy $s$, rozmiar bufora
kodowania to $t$, a rozmiar alfabetu jest równy $a$.
Dla danej liczby $k>0$ podaj warunki, przy których możliwe jest skonstruowanie dowolnie długiego
ciągu danych, w którym wszystkie dopasowania w LZ77 są krótsze niż $k$

# Rozwiązanie

Warunki:
$|t| <= (k-1)*|a|*2$

Wtedy konstrukcja wygląda w taki sposób, że dodajemy do naszego ciągu danych po kolei wszystkie słowa z alfabetu $(k-1)$ razy,
następnie powtarzamy tą operację od końca.

Przykład:

  $\cdot$ alfabet : $[a,b,c]$

  $\cdot t = 3$

  $\cdot k = 2$

  $\cdot$ ciąg danych: $abc-cba-abc-cba\ldots$

Przykład:

  $\cdot$ alfabet : $[a,b,c]$

  $\cdot t = 6$

  $\cdot k = 3$

  $\cdot$ ciąg danych: $aabbcc-ccbbaa-aabbcc\ldots$

Dlaczego działa? Dzięki takiej konstrukcji, w oknie nie znajdziemy porównania $>= k$ ponieważ kiedy będziemy chcieli znaleźć maksymalny prefix danego ciągu, to dany znak w bufforze po sobie będzie mieć albo własne kopie, albo znak który jest następny/poprzedni w alfabecie (przeciwnie od szukanego). Zatem najlepsze dopasowanie będzie tylko dla $(k-1)$ `sklonowanych` znaków.

Widać zatem, że przy takich założeniach możemy budować dowolnie długie ciągi spełniające $k$.
