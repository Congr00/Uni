package narzedzia;

/**
 * Klasa reprezentujaca funkcje min
 */
public class Min extends DwuArny{
    @Override
    /**
     * Metoda oblicza wartosc funkcji
     */
    public Double oblicz(){
        return Math.min(this.x, this.y);
    }
    /**
     * Konstruktor
     */
    public Min(){
        super();
    }
}