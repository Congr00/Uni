---
title: Specyfikacja wymagań
author:
- Łukasz Klasiński
- Marcin Witkowski
date: \today
lang: pl
---

\maketitle

# 1. Historyjki

## Dodawanie plików graficznych do biblioteki

1) Użytkownik uruchamia program, po czym klika ikonę plusa, bądź kieruje się do menu `Pliki -> Dodaj pliki graficzne`.
Następnie wybiera katalog z plikami, które chce dodać do biblioteki oraz opcjonalnie ustawia podstawowe tagi dla plików oraz co zrobić z dodanymi mediami (czy np. uruchomić na nich rozpoznawanie twarzy/obiektów lub stworzyć automatyczną podkategorie).

2) Użytkownik robi zdjęcia, które są automatycznie zapisywane oraz odpowiednio otagowane przez program. 
Przy następnym uruchomieniu wszystkie zdjęcia zostaną zsynchronizowane z jego urządzeniami.

3) Użytkownik chciałby zgrać zdjęcia na portal społecznościowy, więc kieruje się do menu `Pliki -> Eksportów pliki`
po czym loguje się na wybrany serwis i eksportuje wybrane zdjęcia. Jego konto zostało zapisane i w przyszłości nie będzie musiał się już logować.

4) (Marcin Witkowski)

## Dodawanie i wyszukiwanie ludzi po wizerunkach (twarzach)

Użytkownik uruchamia program, po czym klika na kategorie ludzie. W tym momencie ma dwie rzeczy do wyboru:

1) kliknąć podkategorie "Nierozpoznane", gdzie będzie mógł przypisać danej twarzy właściciela. Po kliknięciu na nierozpoznaną twarz pojawi się nowe okno, w którym użytkownik będzie mógł wybrać istniejącą już osobę lub stworzyć nową (wypełniając pola z personaliami)

2) wyszukać podkategorie wpisując imię i/lub nazwisko bądź ręcznie przejść przez listę osób, które są opisane przez imię i nazwisko oraz miniaturkę twarzy. Po kliknięciu na daną osobę, wyświetlą się wszystkie zdjęcia na której ona występuje oraz ewentualne zdjęcia na których możliwe że występuje ale wymagają potwierdzenia.

3) (Marcin Witkowski)

## Duplikaty

1) Użytkownik podczas korzystania z programu otrzymuje powiadomienie o wykrytych duplikatach, po czym przechodzi do okna na którym pokazane są propozycje zdjęć do usunięcia. Użytkownik wybiera które zdjęcia uważa za duplikaty, a które nie.

# 2a. Wymagania funkcjonalne

1) Przeglądanie zdjęć znajdujących się w galeriach. Po kliknięciu na miniaturkę danego zdjęcia, powinno się ono otworzyć na pełnym ekranie. Ponadto użytkownik może przejść do kolejnego zdjęcia na liście poprzez użycie przycisków
na ekranie/klawiaturze bądź za pomocą gestów(na smartelach).

2) Integracja z portalami społecznościowymi(Facebook, Instagram, Flickr, Google Photos, etc.) - użytkownik powinien móc w prosty sposób wgrywać zdjęcia na wybrany portal.

3) Integracja z popularnymi usługami takimi jak Google Drive, OneDrive, Dropbox itp. Poza automatycznym zgrywaniem plików należy zadbać o to, aby nie zgrywać jednego zdjęcia wielokrotnie, szczególnie jeśli użytkownik korzysta z synchronizacji zdjęć na jednej z tych usług.

4) Wieloplatformowość - aplikacja powinna mieć swoje odpowiedniki na wszystkie najważniejsze platformy, aby użytkownik miał możliwość dostępu do aplikacji ze wszystkich urządzeń.

5) Możliwość prostej edycji zdjęć takiej jak color grinding, skalowanie, konwersja do innych formatów, czyszczenia danych EXIF, filtry itp.

6) Automatyczne tagowanie zdjęć poprzez sieci neuronowe ze względu na osoby, przedmioty, miejsca itp.

7) Automatyczne wykrywanie duplikatów zarówno poprzez nazwy plików oraz ich datę EXIF jak i dzięki analizie zdjęć przez sieci neuronowe.

8) (Marcin Witkowski)

# 2b. Wymagania niefunkcjonalne

1) Intuicyjny, przejrzysty oraz stawiający na jak najłatwiejsze przeglądanie zdjęć interfejs. Użytkownik powinien być w stanie korzystać z większości możliwości programu od pierwszego użycia.

2) Dobrze wytrenowana sieć neuronowa, nie chcemy aby tagi zdjęć i duplikaty miały duży współczynnik błędów, co może być irytujące dla użytkownika.

3) Tłumaczenia na inne języki.

4) Działanie aplikacji w tle bez dużego zużycia zasobów systemu, szczególnie w przypadku urządzeń mobilnych.

5) (Marcin Witkowski)
