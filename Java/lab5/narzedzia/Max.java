package narzedzia;

/**
 * Klasa reprezentujaca funkcje max
 */
public class Max extends DwuArny{
    @Override
    /**
     * Metoda obliczajaca wartosc funkcji
     */
    public Double oblicz(){
        return Math.max(this.x, this.y);
    }
    /**
     * Konstruktor
     */
    public Max(){
        super();
    }
}