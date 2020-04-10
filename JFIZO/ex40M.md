---
title: Zadanie 40 z "Około dwustu łatwych zadań z języków formalnych i złożoności obliczeniowej (i jedno czy dwa trudne) 2020 edition"
author: Łukasz Klasiński
date: \today
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
header-includes: 
    - \usepackage{tikz}
---

## Zadanie 40M.
Udowodnij, że dla każdego (dostatecznie dużego) $n$ istnieje PDFA $\mathcal{A} = \langle \Sigma, Q, q_0, F, \delta \rangle$, taki że
$|Q| = n$ i że istnieje trzyelementowy $S \subseteq Q$ taki że zbiór $csync(S)$ jest niepusty ale nie zawiera słowa krótszego niż
$n^3 / 10000$.

# Rozwiązanie

Skonstruujemy taką maszynę, aby najkrótsze możliwe słowo synchronizujące musiało być odpowiednio długie.

Maszyna składa się z $3$ cykli, wielkości kolejno $\frac{n}{3}$, $\frac{n}{3}-1$, $\frac{n}{3}-2$ oraz pojedyńczym wyjściem
z cykli, które sprowadza się do wspólnego stanu. W cyklach przechodzimy do kolejnego stanu poprzez wczytanie litery $0$, natomiast wychodzimy z cyklu po wczytaniu litery $1$ (i znajdując się w odpowiednim stanie). Maszyna taka akceptuje tylko takie słowa, które składają się wpierw z $k$ zer, gdzie $k$ jest równe wielokrotności $\frac{n}{3}, \frac{n}{3}-1$ lub $\frac{n}{3}-2$,
a następnie trzech jedynek. Poniżej wizualizacja - pogrubione wierzchołki w cyklach będą trzema wybranymi stanami $S \subseteq Q$.

\usetikzlibrary{automata, positioning, arrows}

\begin{tikzpicture}[->,auto,node distance=2.1cm,line width=0.4mm]
    \node[state, accepting] (1) {$0$};
    \node[state, left of=1] (2) {$1$};
    \node[state, left of=2] (3) {$2$};
    \node[state, right of=1] (4) {$\frac{n}{3}-1$};
    \node[state, below left of=1] (5) {Sync};
    \node[state, below left of=5] (6) {$0$};
    \node[state, accepting, left of=6] (7) {$1$};
    \node[state, left of=7] (8) {$2$};
    \node[state, below right of=5] (9) {$\frac{n}{3}-2$};
    \node[state, right of=5] (13) {$\frac{n}{3}-3$};
    \node[state, right of=13] (10) {$0$};
    \node[state, right of=10] (11) {$1$};
    \node[state, accepting, right of=11] (12) {$2$};
    \node[state, left of=5] (14) {};
    \node[state, accepting, left of=14] (15) {$F$};
    \draw 
    (1) edge[above] node{$0$} (2)
    (2) edge[above] node{$0$} (3)
    (3) edge[above, bend left] node{$\ldots$} (4)
    (4) edge[above] node{$0$} (1)
    (1) edge[below] node{$1$} (5)
    (6) edge[above] node{$0$} (7)
    (7) edge[above] node{$0$} (8)
    (8) edge[below, bend right] node{$\ldots$} (9)
    (9) edge[above] node{$0$} (6)
    (6) edge[below] node{$1$} (5)
    (10) edge[above] node{$0$} (11)
    (11) edge[above] node{$0$} (12)
    (13) edge[above] node{$0$} (10)
    (12) edge[below, bend right] node{$\ldots$} (13)
    (10) edge[below, bend left] node{$1$} (5)
    (5) edge[below] node{$1$} (14)
    (14) edge[below] node{$1$} (15);
\end{tikzpicture}

Widać, że taki automat, dla odpowiednio dużego $n$, będzie miał dokładnie $n$ stanów gdy $n$ jest podzielne przez $3$, a jeśli nie jest to możemy
bardzo łatwo uzupełnić go o brakujące stany zwiększając bądź zmniejszając liczbę jedynek potrzebnych na dojście do stanu akceptującego $F$.

Popatrzymy teraz jak musi wyglądać najkrótsze słowo $s \in csync(S)$. Z konstrukcji widać, że aby wybrane stany mogły się zsynchronizować, muszą dojść do stanu $Sync$. Muszą to także zrobić jednocześnie, ponieważ jeśli zsynchronizujemy dwa, to po wyjściu z cyklu trzeci nie będzie miał już możliwości 
synchronizacji. Oznaczmy przez $c_1, c_2, c_3$ cykle od długości $\frac{n}{3}, \frac{n}{3}-1, \frac{n}{3}-2$. Wtedy ilość zer potrzebnych do 
zsynchronizowania się w punkcie $0$ każdego cyklu jest równa ich NWW.

Jako, że $c_1, c_2$ oraz $c_3$ są kolejnymi liczbami naturalnymi, to ich NWW wynosi:
$$
  \begin{cases}
    \frac{1}{2} * c_1 * c_2 * c_3 = \frac{n^3 -9x^2 + 18n}{57} & \quad  c_1 \text{ parzyste}\\
    c_1 * c_2 * c_3 = \frac{n^3 -9x^2 + 18n}{27} & \quad  wpp
  \end{cases}
$$
Zauważmy, że dla odpowiednio dużego $n$ licznik zbiega do $n^3$ zatem w gorszym przypadku (kiedy $c_i$ jest parzyste) otrzymamy
$\frac{n^3}{54} > \frac{n^3}{10000}$, więc nasza maszyna dla odpowiedniego $n$ spełnia założenia.
