package narzedzia;

/**
 * Klasa reprezentujaca funkcje mnozenia
 */
public class Mnozenie extends DwuArny{
    @Override
    /**
     * Funkcja wylicza wartosc funkcji
     */
    public Double oblicz() {
        return this.x * this.y;
    }
    /**
     * Konstruktor
     */
    public Mnozenie(){
        super();
    }
}