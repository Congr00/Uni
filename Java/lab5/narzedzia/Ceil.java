package narzedzia;

/**
 * Klasa reprezentujaca funkcje ceil
 */
public class Ceil extends Arny{
    @Override
    /**
     * Funkcja oblicza wartosc funkcji
     */
    public Double oblicz(){
        return Math.ceil(this.x);
    }
    /**
     * Konstruktor
     */
    public Ceil(){
        super();
    }
}