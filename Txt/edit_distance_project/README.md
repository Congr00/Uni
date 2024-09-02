Pracownia została napisana w języku rust.

W plikach źródłowych można znaleźć trzy implementacje algorytmów wyliczających edit distance na 2 stringach.
/src/algorithms/edit_distance_basic.rs - podstawowy algorytm działający w $O(n^{n})$
/src/algorithms/edit_distance_improved.rs - algorytm działający w $O(n \cdot d)$
/src/algorithms/edit_distance_adv.rs - algorytm działający w $O(n + d\ cdot d)

Projekt można zbudować poleceniem `cargo build`, odpalamy testy za pomocą `cargo test`.algorytmów
Ponadto można uruchomić benchmarki za pomocą `cargo bench`.

Zaimplementowane algorytmy zostały przetestowane w 3 kategoriach:
  * Długość czasu względem wielkości losowego tekstu wielkości $n$
  Wyniki można podglądnąć w folderze /target/criterion/benchmark_lcs_lipsum_(basic|improved|adv)
    Wyniki były zgodne z oczekiwaniami - kiedy mamy losowy tekst, jego editing distance też jest dosyć wysoki, przez co
    algorytmy które mają złożoność związaną z wielkością $d$, radzą sobie gorzej od bazowego algorytmu przez dodatkową stałą która się
    za nimi kryje. Wersja adv poradziła sobie najgorzej ze względu na to, że zapytania rmq są zaimplementowane w czasie $O(logn)$, przez co
    radzi sobie dosyć na teksty które mają wysokie wartości $d$.

  * Długość czasu względem tekstu, który ma edit distance wielkości $~(w / 40)$
  Wyniki w folderze /target/criterion/benchmark_lcs_similar_(basic|improved|adv)
    Dzięki zmniejszeniu wielkości $d$, wersja adv była w stanie przegonić bazowy algorytm, natomiast improved o wiele bardziej się zbliżyła.


  * Prędkość algorytmów względem wielkości edycyjnej tekstu
  Wyniki w folderze /target/criterion/benchmark_lcs_sim_diff_(improved|adv) (im większy numer liczby przy teście, tym mniejsza wartość $d$)
    W tym teście bardzo dobrze widać zależności algorytmów od wielkości $d$. W przypadku wersji adv, przy takiej tej samej wielkości tekstu, zmniejszenie $d$ o połowę, algorytm działa wykładniczo szybciej. W szczególności dla bardzo małych $d$, zbliża się do złożoności liniowej.
    Jeśli chodzi o wersję improved, to widać zauważalny wzrost prędkości, ale w sposób liniowy, co ma sens biorąc pod uwagę złożoność $O(n \cdot d)$.

Poniżej fragment z raportu z wykresami z eksperymentu w którym zostaje pomniejszana wartość $d$ względem tekstu wejściowego (więcej w poszczególnych folderach z wynikami)

![](https://i.imgur.com/e8hwiqc.png)
![](https://i.imgur.com/nBZFZWR.png)
