---
title:  lista 8 - "Systemy Rozproszone 2020"
author: Łukasz Klasiński
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
---

### 1. Od systemów spolegliwych często wymaga się zapewniania dużego stopnia bezpieczeństwa. Dlaczego?

Systemy te mają zastosowanie w większości w systemach, gdzie dane są wrażliwe (stąd wymagana spolegliwość systemu) i w szczególności nie powinny wpaść w niepowołane ręce. Z tego wynika, że spolegliwość często wiąże się z wzmożonym stopniem bezpieczeństwa. Poza tym bezpieczeństwo można w pewien sposób interpretować jako zawierające się w definicji słowa 'spolegliwy', bo nikt nie lubi polegać na kimś/czymś, co może łatwo zostać ukradzione/sabotowane.

### 2. Co sprawia, że realizacja modelu zatrzymania awaryjnego w przypadku załamań jest taka trudna?

Przez to, że serwer się załamał, to nie odpowiada na żadne komunikaty. W szczególności nie mamy nawet pewności, czy reset serwera zadziała (a restart może trwać długo). Powoduje to, że ciężko zrealizować zatrzymywanie awaryjne, ponieważ nie wiadomo co innego można robić poza próbą jego zrestartowania i czekania (być może złudnego) na odpowiedź zwrotną. Poza tym w większych systemach załamanie jednego serwera może powodować nieprawidłowe działąnie całego systemu, przez co awaryjne zatrzymanie może nie dość do skutku.

### 3. Rozważ przeglądarkę sieciową, która zwraca przeterminowaną stronę z pamięci podręcznej zamiast strony najnowszej, uaktualnionej w serwerze. Czy jest to awaria, a jeżeli tak, to jakiego rodzaju?

Mamy dwie możliwości - albo wystąpiła awaria przeglądarki, w tym przypadku bizantyjska - przeglądarka utrzymuje poprawne dane według niej dane - nie wykrywa awarii we własnym systemie. Drugi przypadek do awaria tego, że serwer nie odpowiada na zapytanie przeglądarki o najnowszą stronę, bądź wysyła jaj starszą. Mamy wtedy przypadek awarii błędu ominięcia, odliczania czasu bądź odpowiedzi.

### 4. Czy za pomocą modelu potrójnej redundancji modularnej można zaradzić wadom bizantyjskim?

Niekoniecznie, ponieważ o ile jeśli w jednym systemie wystąpi błąd bizantyjski, to wtedy rzeczywiście zostanie on wykryty, jednak jeśli taki sam(bądź podobny, powodujący takie same efekty) błąd nastąpi w 2 lub 3 procesorach, to ostaną one uznane jako poprawne, zatem nie zostaną wykryte.

### 6. Czy metodą TMR można uogólnić do pięciu elementów przypadających na grupę zamiast trzech? Jeśli tak, to jakie wykazywałaby ona właściwości?

Działałaby podobnie do zwykłej metody TMR, z tym że tolerowała by większe ilości uszkodzeń procesorów.

### 7. Jaka semantyka: co najmniej jednokrotna czy co najwyżej jednokrotna jest, Twoim zdaniem, najlepsza dla każdej z następujących aplikacji? Uzasadnij wybór.

  1. Czytanie i zapisywanie plików serwera.
  Semantyka co najmniej jednokrotna - gwarantuje ona że plik zostanie zapisany/odczytany (a nie chcielibyśmy utracić zapisanych danych), a nawet jeśli operacja wykona się kilka razy, to nic nie popsuje - plik zostanie identycznie zapisany kilkukrotnie albo pobrany z serwera do odczytu. 

  2. Kompilowanie programu
  Semantyka co najwyżej jednokrotna - nawet jeśli operacja się nie wykona, to zawsze można skompilować później

  3. Zdalna bankowość
  Semantyka co najwyżej jednokrotna - nie chcemy kilkukrotnie wykonać jakiejś operacji...

### 8. W asynchronicznych wywołaniach RPC klient jest blokowany do czasu przyjęcia jego zamówienia przez serwer. Do jakiego stopnia awarie naruszają semantykę asynchronicznych wywołań RPC?

Serwer może na przykład ulec awarii bizantyjskiej i zawsze od razu odblokowywać klienta pomimo tego iż nie skończył wykonywać zamówienia (klient czeka na odpowiedź po zamówieniu, więc od razu może nadać kolejne). Wtedy klient traci asynchroniczność, ponieważ będzie wysyłać zamówienia do serwera bez czekania aż skończy przetwarzać dane.

### 9. Podaj przykład, w którym komunikacja grupowa nie wymaga uporządkowania komunikatów.

Algorytm wykonywania spójnej migawki systemu rozproszonego(grupy) Lai-Yang'a. W tym algorytmie wiadomości(komunikaty) nie muszą być FIFO (Wiem z kursu: algorytmy rozproszone).

### 10. Czy w rozsyłaniu niezawodnym zawsze jest konieczne, żeby warstwa komunikacyjna utrzymywała kopię komunikatu na wypadek ponowienia transmisji?

Zakładając, że wysyłający nie utrzymuje własnego bufora, to tak. W przeciwnym wypadku nie mamy gwarancji, czy nie zaistnieje potrzeba ponownego wysłania komunikatu.

### 11. Do jakiego stopnia jest ważna skalowalność rozsyłania niepodzielnego?

Jest ważna, ponieważ systemy w których niepodzielność jest wymagana (jak np. systemy transakcji bankowych) jest bardzo ważna i stale wymagana jest ich rozbudowa w miarę rośnięcia ilości zapytań oraz procesów. Ciężko powiedzieć do jakiego stopnia, myślę że dużego.

