package narzedzia;

/**
 * Klasa reprezentujaca funkcje abs
 */
public class Abs extends Arny{
    @Override
    /**
     * Metoda oblicza funkcje 
     */
    public Double oblicz(){
        return Math.abs(this.x);
    }
    /**
     * Konstruktor
     */
    public Abs(){
        super();
    }
}