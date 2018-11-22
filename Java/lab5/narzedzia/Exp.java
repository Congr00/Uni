package narzedzia;

/**
 * Klasa reprezentujaca funkcje exp
 */
public class Exp extends Arny{
    @Override
    /**
     * Funkcja wylicza wartosc funkcji
     */
    public Double oblicz(){
        return Math.exp(this.x);
    }
    /**
     * Konstruktor
     */
    public Exp(){
        super();
    }
}