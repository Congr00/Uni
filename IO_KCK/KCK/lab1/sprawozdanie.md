---
title: Analiza przykładów złych interfejsów
author:
- Łukasz Klasinski
- Marcin Witkowski
date: \today
lang: pl
---

\maketitle

# GIMP 2.10

- Interfejs

    Interfejs może z początku nie wydawać się aż taki zły, aczkolwiek przy dłużej pracy z programem niektóre sposoby reprezentacji
    danych bądź niedopatrzenia w UIX potrafią mocno odbić się na produktywności. Po pierwsze: dlaczego każdy z paneli jest w osobnym oknie?
    Praca z grafiką wymaga wtedy ciągłego przełączania się między oknami, które to można zgubić czy też przypadkową zamknąć. Po prawdzie można
    włączyć tryb w jednym oknie, ale dlaczego nie jest to ustawieniem domyślnym? Po drugie: ikonki. Najważniejszym panelem w oprogramowaniu
    do edycji grafiki rastorowej jest, zaraz za oknem z grafiką, panel z narzędziami (toolbox). Ten natomiast jest nieczytelny, przez co
    znalezienie odpowiedniego narzędzia zazwyczaj sprowadza się do przebrnięcia myszką przez wszystkie wpisy korzystając z tekstowego
    opisu każdego przycisku. Oczywiście, bardziej zaawansowani użytkownicy będą korzystali ze skrótów klawiszowych; nie zmienia to jednak
    faktu, że osoba która ma dopiero pierwszą styczność z tym programem będzie miała nie lada problem. Idąc dalej, program ma także
    inne problemy, jak np. niemożliwość zmiany rozmiaru niektórych okien, co w przypadku wyświetlania dużej ilości tekstu w mniejszym
    oknie zmusza użytkownika do używania scrollbara, oraz niektóre opcje konfigurujące program mają problem z kontrastem, przez co
    nie da się ich rozczytać.


- Jak poprawić?

    Po pierwsze, widok w jednym oknie powinien być ustawieniem domyślnym. Poza tym przydało by się stworzyć nowe ikonki dla narzędzi, które
    faktycznie będą reprezentowały funkcję którą opisują. Dodatkowo przydałoby się poprawić kolorystykę, co powinno naprawić problem z
    kontrastem w niektórych miejscach. Niektóre przyciski nie mają też swoich opisów, więc i to wymagałoby poprawy. Ostatecznie, powinniśmy
    pozwolić użytkownikowi na zmianę rozmiaru okna w każdym miejscu.

# Wallpaper Engine

- Interfejs

    Interfejs programu jest bardzo nieintuicyjny. Najważniejsza funkcja, czyli zmienianie tapety jest zabawą w zgadywanie.
    Nie ma zadnego przycisku, który bo jasno mówił ze zmieniamy tapetę.  Przez to przy pierwszym uzyciu uzytkownik musi
    poniekąd zgadywać, jak się to robi metodą prób i błędów. Dodatkowo jest dużo przestrzeni, którą można wykorzystać 
    dając lepsze ikony, na które nie trzeba najeżdżać, aby dowiedzieć się do czego służą. Poza tym opcja oceniania danej tapety 
    jest bardzo niejasna, wręcz nieintuicyjna. Mamy podane gwiadki, reprezentujące jak użytkownicy oceniają daną tapetę, ale
    po najechaniu zmienia się na dwa pojedyńcze przyciski 'lajka' i 'dislajka'. Poza tym ciężko stwierdzić, co tak naprawdę robią przyciski
    'OK' oraz 'Cancel'. Z jednej strony 'Cancel' anuluje wybory i wczytuje ustawienia sprzed uruchomienia aplikacji, a z drugiej
    zamkniecie okna aplikuje zmiany. Następną rzeczą jest przycisk wybierania monitora. Jest on bardzo słabo widoczny i dla kogoś 
    nieobeznanego jego znalazienie może stanowić nie lada wyzwanie.  Ostatnią rzeczą jest to, że funkcja usuwania tapety z biblioteki 
    bardzo cięzka do znalezienia, przez co przy posiadaniu dużej kolekcji, gdy chcemy usunąć jakie

- Jak poprawić?

    Przede wszystkim należało by stworzyc przycisk, który umożliwi nam ustawienie tapety oraz aby rzucał się on w oczy
    na tyle, abyśmy po pierwszym uruchomieniu wiedzieli jak zmienić tapetę. Na przykład przycisk o nazwie 'Apply Wallpaper'.
    Poza tym przycisk wybierania monitora nie jest wystarczająco dobrze widoczny.  Należało by go powiększyć oraz nadać wyróżniające tło.
    Kolejna sprawa, to naprawienie oceniania. Najlepiej jest usunąć wychodzące 'kciuki' i pozwolić uzytkownikowi oceniać poprzez
    wybranie odpowiedniej ilość gwiazdek, co jest z pewnością bardziej intuicyjne oraz mówi samo za siebie, co robimy.
