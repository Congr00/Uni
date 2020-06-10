---
title:  lista 6 - "Systemy Rozproszone 2020"
author: Łukasz Klasiński
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
---

### 1. Wymień co najmniej trzy źródła opóźnień, które mogą się pojawić na drodze między nadającą sygnały czasu radiostacją WWV a procesorami w systemie rozproszonym, nastawiającymi swoje wewnętrzne zegary.

  1. Opóźnienia wynikające z przesyłania danych
  2. Opóźnienia związane z przetwarzaniem sygnału
  3. Opóźnienia wynikające z zakłóceń transmisji

### 2. Rozważ zachowanie dwu maszyn w systemie rozproszonym. Obie mają zegary, o których założono, że tykają 1000 razy w ciągu 1 ms. Jeden z nich rzeczywiście tak chodzi, natomiast drugi tyka tylko 990 razy na 1 ms. Ile wyniesie maksymalne odchylenie czasu tych zegarów, jeśli sygnał aktualizujący UTC dochodzi raz na minutę?

Jedna minuta to $60 \cdot 100 = 6000ms$. W takim razie po $6000ms$, niedokładny zegar będzie w tyle za dobrym zegarem o 60000 tików. Zatem odchylenie wynosi $60000 / 1000 = 60ms$

### 3. Jednym ze współczesnych urządzeń, które (po cichu) wkradły się do systemów rozproszonych są odbiorniki GPS. Podaj przykłady aplikacji rozproszonych, które mogą robić użytek z informacji GPS.

  * Stacje pomiarowe, które synchronizują się za pomocą sygnału GPS.
  * Rozproszone przechowywanie danych, które są tagowane lokalizacją GPS np. zdjęcia
  * System komunikacji miejskiej, który używa lokalizacji GPS pojazdów w celu aktualizowania opóźnień oraz sterowania sygnalizacją.
  * Podobnie system zarządzania pociągami na podstawie ich położenia GPS

### 4. Kiedy węzeł synchronizuje zegar z zegarem w innym węźle, dobrze jest wziąć pod uwagę również poprzednie pomiary. Dlaczego? Podaj przykład wykorzystania takich poprzednich odczytów.

Można użyć tego do weryfikowania, czy opóźnienie, które zaszło w poprzednim cyklu było równe temu, które jest teraz. Można w ten sposób wykrywać uszkodzenia/zmiany w zegarach węzłów. Poza tym mamy też jakieś odniesienie do tego jak zwykle wygląda różnica czasowa, więc jeśli nastąpiłoby zniekształcenie danych w czasie synchronizacji bylibyśmy w stanie, w jakimś zakresie to wykrywać.

### 5. Na rysunku 5.7 dodaj nowy komunikat, który będzie współbieżny z komunikatem A, tj. nie będzie ani poprzedzał A, ani po nim występował.

Dodamy nowy komunikat $A'$, który będzie wychodził z maszyny 1 do maszyny 2 kiedy jego zegar wynosi 0, a dochodził w czasie 16 dla 2 maszyny.

### 7. Rozważmy warstwę komunikacyjną, w której komunikaty są dostarczane wyłącznie w kolejności ich wysyłania. Podaj przykład w którym nawet to uporządkowanie jest niepotrzebnie zbyt ograniczające.

Przykładem może być algorytm Lai-Yanga do wykonywania rozproszonej spójnej migawki systemu rozproszonego. Nie wymaga on tego, aby komunikaty były FIFO, co znacznie uproszcza budowę systemu na którym może działać.

### 8. W wielu algorytmach rozproszonych jest potrzebny proces koordynujący. Do jakiego stopnia takie algorytmy możemy uważać za rozproszone?

Nawet jeśli potrzebny jest proces koordynujący, to dalej mamy założenia typowe dla systemów rozproszonych, czyli fakt, że wiadomości dochodzą w różnych czasach oraz nie ma bezpośredniej komunikacji między procesem koordynującym i pozostałymi. Potrzeba takiego procesu wynika z tego, że do rozstrzygnięcia wielu problemów potrzebny jest lider (swoją drogą sam wybór leadera w sieci rozproszonej nie jest wcale taki oczywisty), co nie czyni takich algorytmów mniej rozproszonymi od taki co go nie wymagają. Ponad to dużo algorytmów rozproszonych wymaga jednego procesu startowego, co czyni go naturalnie procesem koordynującym (np. algorytm Lai-Yanga tworzy niejako migawkę całego systemu, ale w trakcie uruchomienia go na danym procesie - liderze).

### 11. Problemem w algorytmie Ricarta i Agrawali jest to, że w przypadku uszkodzenia procesu brak odpowiedzi na zamówienie od innego procesu, chcącego wejść do sekcji krytycznej, uważamy za odmowę pozwolenia. Zaproponowaliśmy, aby dla ułatwienia wykrywania uszkodzonych procesów odpowiedzi na wszystkie zamówienia były udzielane natychmiast. Czy istnieją okoliczności, w których nawet ta metoda jest niewystarczająca?

Jest, jeśli przyjmiemy jakiś stały czas oczekiwania na odpowiedź. Jeśli po danym czasie takowej nie dostaniemy, to możemy założyć, że proces jest uszkodzony. Gdybyśmy nie mieli takiego czasu oczekiwania, to mógłby nastąpić podobny problem co wcześniej - uszkodzony proces nie wysłałby odpowiedzi na zamówienie, przez co czekalibyśmy na nią w nieskończoność.

### 15. W systemie przedstawionym na planszy 31 krążą jednocześnie dwa komunikaty ELEKCJA. Choć obecność ich obu nie przysparza kłopotu, byłoby bardziej elegancko, gdyby pozbyto się jednego z nich. Opracuj algorytm, który będzie to wykonywał bez wpływania na działanie podstawowego algorytmu elekcji.

Kiedy do jednego z procesów, który zaczął elekcję dojdzie wiadomość ELEKCJA, która nei należy do niego, to może on zobaczyć, czy proces, z którego pochodzi ta wiadomość ma mniejsze id. Jeśli tak, to może on odrzucić tą wiadomość i nie przekazywać jej dalej. W przeciwnym przypadku dopisuje się do niej i przekazuje w przód. W ten sposób dodatkowe ELEKCJE wysłane przez procesy, które nie mają szans na zostanie nowym liderem zostaną zatrzymane zanim wykonają pełny cykl.

### 16. Na planszy 49 przedstawiono sposób niepodzielnej aktualizacji zapasów magazynowych z użyciem taśmy magnetycznej. Skoro taśmę magnetyczną można łatwo zasymulować na dysku, dlaczego, Twoim zdaniem, nie używa się tej metody obecnie?

Różnica jest taka, że taśmy były fizycznie, więc wtedy rzeczywiście jeśli coś poszło nie tak, można było ją po prostu przewinąć od początku. Z dysku odzyskiwanie danych nie jest już takie proste (o ile możliwe). Jedyną możliwością byłoby dodatkowe przekopiowanie stanu początkowego w inne miejsce, ale to już byłby zwykły backup danych, więc i tak nie korzystalibyśmy z dobrodziejstw taśmy.

### 17. Na planszy 68 pokazano trzy plany - dwa dopuszczalne i jeden niedozwolony. Dla tych samych transakcji, podaj pełną listę wartości, które może przyjmować na końcu zmienna $x$ i określ, które z nich są dopuszczalne, a które niedopuszczalne.


  1. $[0, 1, 2, 3]$
  2. $[0, 1, 3]$
  3. $[0, 1, 2, 5]$

Niedopuszczalne wartości: $[5]$
Dopuszczalne wartości: $[0, 1, 2, 3]$