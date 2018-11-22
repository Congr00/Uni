package narzedzia;

/**
 * Klasa reprezentujaca funkcje arctangens
 */
public class Atan extends Arny{
    @Override
    /**
     * Funkcja obliczajaca wartosc funkcji
     */
    public Double oblicz(){
        return Math.atan(this.x);
    }
    /**
     * Konstruktor
     */
    public Atan(){
        super();
    }
}