package narzedzia;

/**
 * Klasa reprezentujaca funkcje acotangens
 */
public class Acot extends Arny{
    @Override
    /**
     * Funkcja obliczajaca wartosc funkcji
     */
    public Double oblicz(){
        return Math.atan(1 / this.x);
    }
    /**
     * Konstruktor
     */
    public Acot(){
        super();
    }
}