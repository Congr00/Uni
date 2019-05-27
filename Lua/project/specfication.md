---
title: 'Specyfikacja projektu w Lua: addon do gry \newline
        `World of Warcraft`'
author:
    - Łukasz Klasiński
    - Marcin Witkowski
date: \today
lang: pl
geometry: vmargin=1.45cm
papersize: a4paper
---

\maketitle

# Opis projektu (cel)

Celem projektu jest napisane addona do gry, który będzie umożliwiać udostępnienie innym graczom informacji o posiadanych profesjach.
Wykorzystamy do tego API gry w wersji `204000` oraz Lua w wersji `5.1`. GUI zostanie zdefiniowane w osobnym pliku XML z drobnymi wstawkami w Lua korzystających z funkcjonalności zaimplementowanej w głównym module. Nie planujemy korzystać z dodatkowych bibliotek,
może z pominięciem biblioteki do wersjonowania skryptów w Lua. W domyśle addon ma działać niezależnie od innych plug-inów modyfikujących UIX związane z profesjami.

Addon będzie się komunikował z instancjami zainstalowanymi u innych graczy za pośrednictwem protokołu pluginów (niewidocznego dla użytkowników). W zależności od ilości informacji jaką będziemy musieli wysłać, rozważamy implementacje jakiegoś algorytmu kompresji danych w celu uniknięcia blokady anty-floodowej. 

Docelowy interfejs będzie napisany od zera ponieważ nie chcemy modyfikować bazowej funkcjonalności gry (tworzyć hooków na funkcje gry).

# Harmonogram

## 04.06.19

Podstawowa funkcjonalność, interfejs tekstowy, testowanie

## 11.06.19

Pierwsza wersja GUI.