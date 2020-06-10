---
title:  lista 4 - "Systemy Rozproszone 2020"
author: Łukasz Klasiński
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
---

### 1. W wielu protokołach warstwowych każda warstwa ma własny nagłówek. Z pewnością bardziej efektywne od używania wszystkich tych osobnych nagłówków byłoby poprzedzenie komunikatu jednym nagłówkiem, zawierającym całość informacji sterującej. Dlaczego się tego nie robi?

Protokoły były ustalane w różnych czasach oraz rozbudowywane. Przez co aby zachować kompatybilność ze starymi wersjami często trzeba było dodawać nowe nagłówki. Dodatkowo często korzysta się z innych rozwiązań które wymagają odpowiednich oznaczeń. Poza tym niektóre protokoły muszą być kompatybilne z innymi aby być w stanie się porozumiewać, więc nie można ich za bardzo zmieniać.

### 2. Dlaczego usługi komunikacyjne warstwy transportu są często nieodpowiednie do budowania aplikacji rozproszonych?

Tracimy wtedy możliwość używania warstw prezentacji, sesji oraz pośredniej więc o ile taka aplikacja nie jest bardzo prosta, to musielibyśmy emulować ich działanie w celu przeprowadzania np. synchronizacji, zapisywania rekordów itp.

### 3. Usługa niezawodnego rozsyłania umożliwia nadawcy niezawodne przekazywanie komunikatów w grupie odbiorców. Czy taka usługa powinna należeć do oprogramowania warstwy pośredniej, czy też powinna być częścią niższej warstwy?

Nie powinna być w niższej warstwie, ponieważ w niektórych zastosowaniach niezawodność komunikacji nie jest niezbędna i wręcz spowalnia działanie. Przykłądem może być strumieniowanie filmów albo komunikacja głosowa, gdzie jeśli część informacji nie dojdzie do jakiegoś odbiorcy to nie stanowi to dużego problemu.

### 4. Rozważ procedurę `zwiększ` z dwoma liczbami całkowitymi jako parametrami. Procedura dodaje liczbę 1 do każdego parametru. Załóżmy teraz, że wywołano ją z tą samą zmienną w obu parametrach, np. `zwiększ[i, i]`. Przyjmując, że zmienna $i$ ma na początku wartość 0, określ ile wyniesie jej wartość, jeśli zastosuje się przekazywanie przez odniesienie? A co się stanie, gdy parametry będą przekazywane przez kopiowanie-odtwarzanie?

  * przekazywanie przez odniesienie (zakładając że odnosimy się do zmiennej na serwerze - inaczej byłby śmieci)
  Wtedy przekazujemy zmienną $i$ jako miejsce w pamięci, zatem najpierw zwiększy się o 1 a następnie nastąpi odwołanie do tego samego miejsca w pamięci które ostatecznie nada jej wartość 2.

  * przekazywanie prze kopiowanie
  W tym przypadku oba argumenty będą miały oddzielne miejsca w pamięci zatem $i$ zostanie zwiększone tylko raz.


### 5. Język C ma konstrukcję zwaną unią, w której pole rekordu może wyrażać jedną z kilku możliwości. Podczas wykonywania programu nie ma gwarantowanego sposobu określenia, którą z nich takie pole zawiera. Czy ta cecha języka C ma jakiś wpływ na zdalne wywoływanie procedur? Wyjaśnij swoją odpowiedź.

Ma, ponieważ dodatkowo poza operacją którą chcemy na danej uni wykonać należy zamieścić informację o tym na których dokładnie polach w unii chcemy ją wykonać. Np możemy mieć unię, która ma 16 bitów i możemy wykonywać na niej operacje na liczbach 8 albo 16 bitowych. Jeśli chcemy wywołać na takiej strukturze `zwiększ` to musimy dodatkowo powiedzieć o type który chcemy zwiększyć bo inaczej unia zawsze byłaby traktowana jako zmienna 16 bitowa.

### 6. Jeden ze sposobów konwersji parametrów w systemach RPC polega na wysyłaniu przez każdą z maszyn parametrów w naturalnej dla niej reprezentacji i dokonywaniu ich tłumaczenie po drugiej stronie, jeśli zajdzie taka potrzeba. Rodzaj źródłowego systemu można by zakodować w pierwszym bajcie. Ponieważ jednak zlokalizowanie pierwszego bajta w pierwszym słowie jest samo w sobie problemem, czy jest możliwie aby to zadziałało?

Nie, ponieważ może się okazać że dane wejściowe w pierwszym słowie początkowe (bądź końcowe) bity danych mogą być tak ustawione, że maszyna błędnie stwierdzi z która wersją ma do czynienia bo nie jest w stanie określić czy to jest początek danych czy to jest bajt kontrolny. Naprawienie mogło by być umieszczanie takiego bajta na początku i końcu wiadomości - wtedy nie będzie takich pomyłek.

### 9. Czy warto dokonać jeszcze podziału wywołań RPC na statyczne i dynamiczne?

Nie ma większego sensu, ponieważ ta czy siak w obu przypadkach zapytanie musi zostać wysłane oraz przetworzone przez serwer więc wyglądałoby to identycznie.

### 11. Wyjaśnij różnicę między elementarnymi operacjami $MPI_bsend$ i $MPI_osend$ w MPI.

  * $MPI_bsend$ - operacja inicjuje wysyłanie danych oraz umieszcza je w dostarczonym wskaźniku. Dopiero po otrzymaniu odpowiedzi można go zwolnić.
  
  * $MPI_isend$ - operacja inicjuje wysyłanie danych i natychmiast się kończą, nie czekając na zakończenie operacji. Sami musimy weryfikować kiedy dana operacja się zakończy i kiedy możemy zwolnić zasoby.

### 17. W komunikacji trwałej odbiorca zazwyczaj ma włąsny bufor, w którym można przechowywać komunikaty wówczas, gdy odbiorca nie działa. Do utworzenia takiego bufora może być potrzebny jest rozmiar. Podaj argument uzasadniający, że jest to wskazane oraz taki, który przemawia przeciw określaniu rozmiaru.

  * Za - jeśli będziemy mieli nieokreślony rozmiar, to może dojść do przepełnienia pamięci oraz ciężej byłoby określić zużycie zasobów.
  * Przeciw - Nigdy nie mamy pewności, że dany rozmiar będzie wystarczający we wszystkich sytuacjach które mogą zajść, więc brak rozmiaru eliminuje ten problem.

### 20. Załóżmy, że w sieci sensorowej mierzone temperatury nie są opatrywane znacznikami czasu przez czujnik, lecz natychmiast posyłane do operatora. Czy wystarczyłoby tu tylko zagwarantować maksymalne opóźnienie między punktami końcowymi?

Nie, ponieważ nawet jeśli jest jakieś maksymalne opóźnienie, to brakuje gwarancji tego, że wiadomości będą przychodzić w dobrej kolejności. Przez to nie jest możliwe ustalenie zmian temperatury w czasie.

### 21. W jaki sposób zagwarantujesz minimalne opóźnienie między punktami końcowymi, gdy zbiór komputerów jest zorganizowany w pierścień (logiczny lub fizyczny)?

Możemy przyjąć, że wiadomość zawsze jest wysyłana w obu kierunkach na cyklu. Wtedy mamy gwarancję (o ile nie utworzy się graf niespójny), że wiadomość dojdzie po przejściu po $n$ węzłach na pierścieniu. Wtedy możemy policzyć ile wynosi średni czas dotarcia wiadomości pomiędzy sąsiadującymi węzłami, po czym mnożymy to przez ilość komputerów na cyklu.