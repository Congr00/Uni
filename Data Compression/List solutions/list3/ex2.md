---
title:  Zadanie 2 z listy 3 - "Kompresja Danych"
author: Łukasz Klasiński
date: \today
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
---

## Zadanie 2
Ustal czy zwiększenie długości słowa kodowego kodu Tunstalla (przy ustalonym alfabecie i prawdopodobieństwach) może spowodowa¢ wzrost średniej długości kodu (bps)?

# Rozwiązanie

Tak może - podam przykład:

Weźmy następujące dane:

| $\Sigma$ |   $p$  |
|----------|:------:|
| $a$      | 0.25   |
| $b$      | 0.25   |
| $c$      | 0.25   |
| $d$      | 0.25   |

Wtedy dla $n = 3$ otrzymamy następujące kodowanie:

| $\Sigma$ |   $p$  |   kod   |
|----------|:------:|:-------:|
| $b$      | 0.25   |000      |
| $c$      | 0.25   |001      |
| $d$      | 0.25   |010      |
| $aa$     | 0.0625 |011      |
| $ab$     | 0.0625 |100      |
| $ac$     | 0.0625 |101      |
| $ad$     | 0.0625 |110      |

Dla tego $n$ średnia długość kodu wynosi $1.25$.

Weźmy teraz $n=4$. Otrzymamy:

| $\Sigma$ |   $p$  |   kod   |
|----------|:------:|:-------:|
| $aa$     | 0.0625 |0000     |
| $ab$     | 0.0625 |0001     |
| $ac$     | 0.0625 |0010     |
| $ad$     | 0.0625 |0011     |
| $ba$     | 0.0625 |0100     |
| $bb$     | 0.0625 |0101     |
| $bc$     | 0.0625 |0110     |
| $bd$     | 0.0625 |0111     |
| $ca$     | 0.0625 |1000     |
| $cb$     | 0.0625 |1001     |
| $cc$     | 0.0625 |1010     |
| $cd$     | 0.0625 |1011     |
| $da$     | 0.0625 |1100     |
| $db$     | 0.0625 |1101     |
| $dc$     | 0.0625 |1110     |
| $dd$     | 0.0625 |1111     |

Oraz średnią długość = $2.0$. Widać zatem, że dla danych ze zbliżonymi p-p śr długość niekoniecznie się zmniejsza.