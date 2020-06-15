---
title:  lista 7 - "Systemy Rozproszone 2020"
author: Łukasz Klasiński
papersize: a4paper
lang: pl
documentclass: article
geometry: vmargin=1.5cm
---

### 1. Dostęp do obiektu dzielonego Javy można uszeregować, deklarując używane w nim metody jako synchronizowane. Czy to wystarcza do zagwarantowania uszeregowania, gdy taki obiekt zostanie zwielokrotniony?

Jeśli obiekt po zwielokrotnieniu będzie tylko wskaźnikiem na pamięć, na którą wskazuje to nie, ponieważ będzie wtedy kilka obiektów z czego każdy będzie miał własne kolejkowanie dostępu do danych, zatem może wystąpić jednoczesny dostęp przez więcej niż jeden proces. Z drugiej strony jeśli utworzymy kopię z własną pamięcią, to zagwarantujemy szeregowość, ale za to tracimy spójność danych między obiektami.

### 2. Wyjaśnij własnymi słowami główną przyczynę, która skłania do zajmowania się modelami spójności słabej.

Dlatego, że spójność słaba wymusza spójność grup operacji a nie pojedyńczych zapisów/odczytów, co pry dużych systemach oferuje dobry balans międzi spójnością danych a nakładem spowodowanym obsługą szeregowania.

### 4. Omawiając modele spójności, często odwoływaliśmy się do umowy między oprogramowaniem a pamięcią danych. Czemu służy taka umowa?

Umowa ta jest tak naprawdę odpowiednimi regułami, które jeśli będą przestrzegane przez procesy, to gwarantują one to, że będą one mogły czytać z pamięci dane które nie są popsute złym dostępem do nich przez procesy. Bez tego nie mamy pewności, że dany system kiedyś zawiedzie i będzie przechowywał nieprawdziwe/niezgodne dane.

### 5. Co należałoby zrobić z replikami na planszy 19 w materiałach do wykładu w celu sfinalizowania wartości w konicie, aby zarówno w kopii A, jak i B uwidocznił się ten sam wynik?

Należało by wykonać operacje, które nie były wykonane na drugiej kopii w odpowiedniej kolejności. Np na naszym obrazku należy wykonać następujące operacje:

  * Kopia A
  <10, B>

  * Kopia B
  <8, A>
  <12, A>
  <14, A>
  <10, B>

Można przyjąć, że operacja <10, B> jest wykonywana w takiej kolejności względem tego kiedy została wywołana (w moim przykładzie była wykona jako ostatnia ze wszystkich operacji).

### 6. Czy na planszy 29 w materiałach do wykładu wartość 001110 jest dozwolona dla pamięci spójnej sekwencyjnie? Wyjaśnij swoją odpowiedź.

Wartość taka jest możliwa przy następującym ciągu operacji:

print(y,z)
z = 1
x = 1
print(x, z)
print(x, y)
y = 1

Widać, że nie jest to dozwolone ponieważ proces P1 wykonuje operację print(y, z) przed operacją x = 1.

### 7. Często utrzymujemy, że modele spójności słabej dodatkowo obciążają osoby programujące. Do jakiego stopnia teza ta jest rzeczywiście prawdziwa?

W przypadku spójności słabej, mamy warunek, że dostęp do lokalnych danych (czytanie/pisanie) jest dozwolony dopiero kiedy zostaną wykonane wszystkie poprzednie dostępy do zmiennych synchronizujących. Wymagane zatem jest pisanie odpowiednich funkcji, które sprawdzają to i odpowiednio synchronizują wykonywanie programu z zakończeniem dostępu do wszystkich zmiennych synchronizujących. Zatem rzeczywiście występuje jakieś dodatkowe obciążenie, ale myślę że rozwiązania które to robią za nas są już dawno wymyślone (napisane) a ich użycie nie jest wielkim przedsięwzięciem.

### 9. Jaki rodzaj spójności zaproponujesz do realizacji giełdy elektronicznej? Uzasadnij swoją odpowiedź.

Zakładając, że giełda to tak naprawdę jakieś zmienne przechowujące pewne wartości, a dowolne operacje to zmniejszenie bądź ich zwiększenie (kupno/sprzedaż), oraz nie ma ich szczególnie dużo (w skali procesorowej), to wystarczającą metodą synchronizacji byłaby synchronizacja słaba. Synchronizujemy wtedy pewne bloki danych, co nam szczególnie nie przeszkadza, bo nie jest potrzebna natychmiastowa aktualizacja danych, natomiast kolejność operacji zwiększania/zmniejszania nie ma znaczenia, ponieważ odejmowanie i dodawanie są łączne.

### 10. Rozważ osobistą skrzynkę pocztową użytkownika ruchomego, zrealizowaną jako część rozległej, rozproszonej bazy danych. Jaki rodzaj spójności nastawionej na klienta byłby tu najodpowiedniejszy?

W tym przypadku wystarczy spójność ostateczna. Jako że skrzynka pocztowa nie wymaga bardzo szybkiej synchronizacji danych, to jest to dostateczne rozwiązanie, gwarantujące spójność oraz zadowolenie klienta.

### 14. Ogólnie biorąc, do działania aktywnego zwielokrotnienia jest niezbędne, aby wszystkie operacje były wykonywane na każdej kopii w tej samej kolejności. Czy to uporządkowanie jest zawsze konieczne?

Zależy od typu operacji, które wykonujemy, ale w znaczącej ilości przypadków, zawsze będzie istnieć jakaś kolejność operacji, która gdyby została zmieniona, to spowodowałaby ona niespójność danych między kopiami.

### 16. Plik jest zwielokrotniony na 10 serwerach. Wylicz kombinacje kworum czytania i kworum pisania, dozwolone w algorytmie głosowania.

  * Kworum pisania
  mamy (6 : 10) + (7 : 10) + (8 : 10) + (9 : 10) + (10 : 10) możliwości, gdzie (x : y) to symbol newtona

  * Kworum czytania
  Jeśli kworum pisania wybrało 6 elementów, to mamy (6 : 10) kombinacji, jeśli 7, to (7 : 10), 7 to (8 : 10), ... (9 : 10), (10 : 10).

### 22. Czy system Orca oferuje spójność sekwencyjną, czy spójność wejścia?

System ten oferuje spójność sekwencyjną, ponieważ nie gwarantuje on niezmienników wymaganych w przypadku spójności wejścia. Zatem metodą eliminacji (oraz faktów przeczytanych w internecie - niestety niewiele jest na temat tego jak działa ten język) pozostaje spójność sekwencyjna.