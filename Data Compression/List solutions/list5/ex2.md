---
title:  Zadanie 1 z listy 5 - "Kompresja Danych"
author: Łukasz Klasiński
date: \today
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
---

## Zadanie 2
Dla alfabetu wejściowego o rozmiarze $a$ i liczby naturalnej $k$ skonstruuj jak najdłuższy tekst
wejściowy, dla którego algorytm LZ78/LZW z nieograniczonym rozmiarem słownika nie użyje
ani razu dopasowania dłuższego niż k-literowe.

# Rozwiązanie

Pomysł:
Chcemy budować tak słowo, aby na koniec w słowniku były wszystkie kombinacje liter ze słownika o wszystkich długościach $\leq k$.

Przykład:

  $\cdot$ $k = 1$
  
  $\cdot$ alfabet = $[a,b]$

Na początku mamy pusty słownik (LZ78), zatem układamy słowo tak jak robiłby to słownik:

 $\cdot$ słowo = $a$
 
 $\cdot$ słownik $\{a\}$

 $\cdot$ słowo = $a\oplus b$

 $\cdot$ słownik $\{a, b\}$

Teraz dla $k = 2$ robimy to samo co wcześniej tylko dodatkowo rozważamy kombinacje długości $2$:

  $\cdot$ słowo = $ab\oplus aa$

  $\cdot$ słownik $\{a, b, aa\}$
  
  $\cdot$ słowo = $abaa\oplus ab$
  
  $\cdot$ słownik = $\{a, b, aa, ab\}$

I tak dalej. Powyższy algorytm możemy bardzo łatwo zapisać w $MUJP$:
```python
s = ""
n = len(alphabet)

for k in range(1, n + 1):
    for combination in combinations_with_replacement(alphabet, k):
        s += ''.join(combination)
```

Taka konstrukcja wymusi zapisanie każdej możliwej wartości w słowniu, zatem nie da się zrobić dłuższego, bo po jego zapełnieniu kolejne $k$ elementów słowa na pewno już by w nim było, więc zostało by zmachowane z nim $+1$ elementem za nim występującym.
Ostatecznie otrzymamy słowo długości $|a|^k$.