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

Wtedy dla $n = 4$ otrzymamy następujące kodowanie:

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

Oraz średnią długość = $4 / 2.0 = 2.0$

Zwiększmy $n$ o 1. Dostajemy następujące prawdopodobieństwa:

| $\Sigma$ |   $p$    |
|----------|:--------:|
| $bb$     | 0.0625   |
| $bc$     | 0.0625   |
| $bd$     | 0.0625   |
| $ca$     | 0.0625   |
| $cb$     | 0.0625   |
| $cc$     | 0.0625   |
| $cd$     | 0.0625   |
| $da$     | 0.0625   |
| $db$     | 0.0625   |
| $dc$     | 0.0625   |
| $dd$     | 0.0625   |
|$aaa$     | 0.015625 |
|$aab$     | 0.015625 | 
|$aac$     | 0.015625 | 
|$aad$     | 0.015625 |
|$aba$     | 0.015625 |
|$abb$     | 0.015625 | 
|$abc$     | 0.015625 |
|$abd$     | 0.015625 |
|$aca$     | 0.015625 |
|$acb$     | 0.015625 |
|$acc$     | 0.015625 |
|$acd$     | 0.015625 |
|$ada$     | 0.015625 |
|$adb$     | 0.015625 |
|$adc$     | 0.015625 |
|$add$     | 0.015625 |
|$baa$     | 0.015625 |
|$bab$     | 0.015625 |
|$bac$     | 0.015625 |
|$bad$     | 0.015625 |


Oraz średnią długość = $5 / 2.3125 = 2.(162)$. Widać zatem, że dla danych ze zbliżonymi p-p śr długość niekoniecznie się zmniejsza.