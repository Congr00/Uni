package narzedzia;

/**
 * Interfejs implemetujacy funkcje
 */
public interface Funkcyjny extends Obliczalny{
    int arnosc ();
    int brakujaceArg ();
    void dodajArgument(double arg);
}