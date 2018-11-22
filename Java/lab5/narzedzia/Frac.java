package narzedzia;

/**
 * Klasa reprezentujaca funkcje frac
 */
public class Frac extends Arny{
    @Override
    /**
     * Funkcja oblicza wartosc funkcji
     */
    public Double oblicz(){
        return this.x - (this.x % 1);
    }
    /**
     * Konstruktor
     */
    public Frac(){
        super();
    }
}