---
title:  lista 5 - "Systemy Rozproszone 2020"
author: Łukasz Klasiński
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
---

### 1. Podaj przykład, w którym dostęp do jednostki $E$ wymaga dalszego tłumaczenia jej adresu na inny adres.

Przykładem może być mapowanie dns. Zwykle odnosimy się do stron za pomocą lokalizatora URL, ale tak naprawdę adres ten jest przekazywany do odpowiedniego serwera DNS a następnie tłumaczony na adres IP. Często, jeśli mamy do czynienia z większą ilością serwerów które przechowują daną domenę, to takie tłumaczenie zachodzą kilkukrotnie (aby wybrać najbliższy serwer).

### 2. Czy uważasz, że lokalizator URK w rodzaju `http://acme.org/index.html` jest niezależny od położenia? Co powiesz o lokalizatorze `http://www.acme.nl/index.html`?

Teoretycznie adres URL nie ma żadnego związku z lokalizacją - może być dowolny. Ale zwykle umieszcza się serwery obsługujące dane strony umieszczane są w pobliżu kraju do którego odnosi się końcówka (np. .nl odnosi się do Holandii) ponieważ zazwyczaj największa ilość zapytań z niego pochodzi, więc klient szybciej uzyskuje dane.

### 3. Podaj kilka przykładów prawdziwych identyfikatorów.

  * pesel
  * adres portfeli kryptograficznych
  * numery rachunku SWIFT
  * number konta bankowego
  * EMEI - numer identyfikacyjny danego `sprytel`'a

### 4. Czy w identyfikatorze można umieszczać informacje o jednostce, do której się odnosi.

Mogą - dzięki temu mamy bardziej oryginalny identyfikator, który odnosi się tylko do danej jednostki. Np. numer pesel ma zawarte informacje o dacie urodzin. W numerach SWIFT mamy informacje z jakiego kraju pochodzi dany rachunek bankowy itp.

### 13. Wyjaśnij różnicę między dowiązaniem twardym i miękkim w systemach uniksowych.

  * Dowiązanie twarde - jest to wskaźnik bezpośrednio wskazujący na dany plik istniejący na dysku. Możemy tworzyć wiele dowiązań twardych do danego pliku. Dopóki istnieje więcej niż jedno dowiązanie, to plik nie może być usunięty.

  * Dowiązanie miękkie - jest to wskaźnik na dowolny plik bądź folder w systemie plików i jest traktowany przez programy jak zwykły plik. Usunięcie pliku na który wskazywały powoduje, że przestają działać, natomiast usunięcie dowiązania nie usuwa pliku na który wskazywało. Dodatkowo pozwala na wskazywania plików umieszczonych na różnych partycjach.

### 14. Rozważmy system CHord i załóżmy, że węzeł 7 właśnie dołączył do sieci. Jak wyglądałaby jego tablica wskazówek (`finger table`)? Czy w innych tablicach wskazówek wystąpiłyby jakieś zmiany?

Tablica wskazówek dla 7:

  | i | succ |
  | 1 |  9   |
  | 2 |  9   |
  | 3 |  11  |
  | 4 |  18  |
  | 5 |  28  |

Dodatkowo zmieniły by się tablice dla węzłów $1$ oraz $4$ - zamiast $9$ byłaby w nich $7$.

### 16. Czy podczas wstawiania węzła do systemu Chord wszystkie tablice wskazówek musimy uaktualniać natychmiast?

Tak, ponieważ nowy węzeł przejmuje odpowiedzialność za komunikację z przydzielonymi mu kluczami, zatem jeśli jakiś węzeł nie zaktualizuje swojej tablicy wskazówek, to przy próbie dostania się do zasobu może wysłać zapytanie do węzła, który już za niego nie odpowiada, więc nigdy nie otrzyma odpowiedzi (jeśli nie wprowadzimy zmian do protokołu).

### 17. Co stanowi poważną wadę w poszukiwaniu rekurencyjnym podczas rozwiązywania klucza w systemie opartym na DHT?

Klient musi przechowywać lokalnie klucze oraz musi wykonywać dodatkowe operacje na lokalnym komputerze, co może obciążać system orazy wymaga odpowiedniej ilości pamięci dyskowej.

### 20. Jak odbywa się poszukiwanie punktu montowanego w większości systemów uniksowych?

Mamy plik `fstab`, który definiuje jakie masz zamontowane punkty oraz jak można je zamontować. Przy dodawaniu nowej partycji, należy ją odpowiednio do niego dopisać.

### 21. Rozważmy rozproszony system plików, w którym używa się przestrzeni nazw dla każdego użytkownika oddzielnie. Mówię inaczej, każdy użytkownik ma własną, prywatną przestrzeń nazw. Czy nazwy z takiej przestrzeni nazw mogą być używane do dzielenia zasobów przez dwóch różnych użytkowników?

Tak jak najbardziej - przykładem mogą być na przykład przestrzenie nazw w językach programowania (np. C). Każda ma własną unikalną nazwę oraz można odnieść się do zasobów innej za pomocą ich nazwy.

### 24. Czy przy przekazywaniu zdalnego odniesienia od procesu $P_1$ do $P_2$ w rozproszonym zliczaniu odniesień, mogłoby pomóc pozwolenie na zwiększanie licznika procesowi $P_1$, a nie $P_2$?

Niekoniecznie, ponieważ wiadomość o przekazaniu odniesienia do $P_2$ mogłoby nie dojść (zakładając podejście a) z planszy nr 64), przez co w obiekcie $O$ mielibyśmy nieprawdziwą informację o ilości odniesień. Przy rozważaniu podejścia b), nie ma takiego problemy bo mamy ACK.

### 25. Wyjaśnij, dlaczego ważone zliczanie odniesień jest efektywniejsze od prostego zliczania odniesień. Załóż, że komunikacja jest niezawodna.

Podczas tworzenia nowego odniesienia nie trzeba aktualizować licznika odniesień, ponieważ pozostaje taka sama. Ponadto dzięki temu, że waga może tylko maleć (nie licząc kiedy mamy wagę równą 1 i chcemy dodać odniesienie), to eliminujemy problemy zwykłego zliczania, gdzie mogliśmy zbyt szybko usunąć obiekt ze względu na to iż wiadomości o zwiększaniu oraz zmniejszaniu licznika nie przychodzą w dobrej kolejności.

### 28. Jeśli przy zliczaniu odniesień nie otrzyma się odpowiedzi na komunikat `ping` wysłany do procesu $P$, to proces jest usuwany ze spisu odniesień obiektu. Czy takie usunięcie procesu jest zawsze poprawne?

Nie, w szczególności gdy jest to jedyny proces który ma odniesienia, przy usunięciu go jednocześnie zwolnimy zasób (np. `ping` wcale nie dotarł do $P$). Wtedy przy próbie dostępu przez ten proces nastąpi błąd.