package narzedzia;

/**
 * Klasa reprezentujaca funkcje cosinus
 */
public class Cos extends Arny{
    @Override
    /**
     * Funkcja obliczajaca wartosc funkcji
     */
    public Double oblicz(){
        return Math.cos(this.x);
    }
    /**
     * Konstruktor
     */
    public Cos(){
        super();
    }
}