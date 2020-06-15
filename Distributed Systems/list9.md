---
title:  lista 9 - "Systemy Rozproszone 2020"
author: Łukasz Klasiński
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
---

2. Czy w metodzie RISSC całe bezpieczeństwo można skoncentrować na bezpiecznych serwerach czy nie?

Tak, ponieważ w tej metodzie serwery są niezależne od systemu rozproszonego, a dostęp odbywa się tylko poprzez odpowiednie interfejsy, dzięki czemu nie ma do nich dostępu z zewnątrz.

3. Załóżmy, że poproszone Cię o opracowanie aplikacji rozproszonej, która umożliwi nauczycielom organizowanie egzaminów. Podaj co najmniej trzy wytyczne, które stałby się częścią polityki bezpieczeństwa w takiej aplikacji.

  1. Autoryzacja użytkowników.
  2. Odpowiednie zabezpieczenie danych (przed wyciekami).
  3. Zapewnienie bezawaryjności (głównie w trakcie egzaminu).

4. Czy w protokole uwierzytelniania, pokazanym na planszy 54, byłoby bezpieczne połączyć komunikaty 3 i 4 w komunikat K_A_B(R_B,R_A)?

Nie, ponieważ po przekazaniu R_A, użytkownik może przerwać połączenie i użyć ten klucz do wykonania ataku z odbicia, wyjaśnionym na planszy 56.

5. Dlaczego na planszy 58 nie jest konieczne, aby centrum rozprowadzania kluczy miało pewność, że rozmawia z Ają, kiedy otrzymuje ono zamówienie na klucz tajny, który Aja będzie użytkować wspólnie z Benkiem?

Dlatego, że Benek i tak wcześniej musiał nawiązać z Ają jakiś kontakt, więc jeśli ktoś się podszywa pod nią, to i tak nie uzyska z Benkiem połączenia, ponieważ będzie miał niekompatybilny klucz (oryginalna Aja oraz Benek dostaną inne od podszywacza).

7. W komunikacie 2 protokołu uwierzytelniania Needhama-Schroedera bilet jest zaszyfrowany za pomocą klucza tajnego, używanego wspólnie przez Aję i centralę KDC. Czy to szyfrowanie jest niezbędne?

Tak, ponieważ gdyby nie był zaszyfrowany, to ktoś inny np. nasłuchujący sieć może go użyć i podszyć się pod Aję.

10. Załóżmy, że Aja chce wysłać Benkowi komunikat m. Zamiast szyfrować m za pomocą Benkowego klucza publicznego, K+B, generuje ona klucz sesji K_A_B i wysyła komunikat [K_A_B(m), K+B(K_A_B)]. Dlaczego jest to schemat zazwyczaj lepszy?

Klucze symetryczne działają dużo szybciej niż klucze asymetryczne, zatem bardziej opłaca się zaszyfrować kluczem publicznym małą wiadomość (jaką jest klucz sesji), natomiast szyfrowaniem asymetrycznym większą (czyli naszą wiadomość).

12. Jak są realizowane listy kontroli dostępów w systemie plików UNIX?

Listy kontroli są tablicą, tworzoną oddzielnie dla każdego użytkownika systemu, gdzie zapisywane są pola które opisują pliki i operacje, które może na nich wykonywać. Oczywiście w tej tablicy nie ma wszystkich plików - tylko te, które mają inne uprawnienia niż domyślne. Aby działało to szybko, to każdy plik ma własny identyfikator, który umożliwia szybkie przeglądanie ów tablic.

16. Protokołu wymiany kluczy Diffiego-Hellmana możemy też użyć doustanowienia wspólnego klucza tajnego między trzema stronami. Wyjaśnij, jak to zrobić.

Postępujemy następująco:

    1. Uczestnicy uzgadniają parametry algorytmu - p oraz g
    2. Uczestnicy tworzą prywatne wartości, a, b, c
    3. Aja oblicza g^a i wysyła Benkowi
    4. Benek oblicza g^ab i wysyła Czarkowi
    5. Czarek oblicza g^bc i wysyła Aji
    6. Aja oblicza g^bca i używa jako tajnego klucza
    7. Czarek oblicza g^c i wysyła Aji.
    8. Aja oblicza g^ca i wysyła Benkowi.
    9. Benek oblicza g^cab i używa jako klucza tajnego.

Ostatecznie każdy ma dostęp do tajnego klucza równemu g^abc.

19. Czy ograniczanie żywotności klucza sesji ma sens? Jeśli tak, to podaj przykład, jak można to osiągnąć.

Tak ma sens, ponieważ jako iż klucze sesji są mniej bezpieczne niż klucze asymetryczne, im więcej zaszyfrowanego materiału zbierze oprawca, tym łatwiej mu go odgadnąć. Dlatego kluczom ustala się żywotność, aby zapobiegać takim atakom. Jak to osiągnąć? Po prostu mieć przypisany znacznik czasu do danego klucza sesji, dzięki czemu obie strony będą wiedzieć kiedy należy ustalić go na nowo.

20. Jaką rolę odgrywa znacznik czasu w komunikacie 6 na planszy 87 i dlaczego należy go szyfrować?

Zapewne jest to znacznik czasu ważności klucza sesji. Powinien być zaszyfrowany, bo inaczej haker miałby dodatkowe informacje pomagające hakerowi przeprowadzić atak.

25. Anonimowość sprzedającego w systemie płatniczym jest często zakazana. Dlaczego?

Pewnie po to żeby nie wymigać się od płacenia podatku od sprzedaży (VAT). Kupujący nie płaci żadnych dodatkowych opłat (no może przesyłka), więc nie ma do niego podobnych wymagań.