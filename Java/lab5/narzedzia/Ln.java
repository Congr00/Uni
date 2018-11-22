package narzedzia;

/**
 * Klasa reprezentujaca funkcje ln
 */
public class Ln extends Arny{
    @Override
    /**
     * Metoda wylicza wartosc funkcji
     */
    public Double oblicz(){
        return Math.log(this.x);
    }
    /**
     * Konstruktor
     */
    public Ln(){
        super();
    }
}