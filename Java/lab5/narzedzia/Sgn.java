package narzedzia;

/**
 * Klasa reprezentujaca funkcje sign
 */
public class Sgn extends Arny{
    @Override
    /**
     * Metoda obliczajaca wartosc funkcji
     */    
    public Double oblicz(){
        return Math.signum(this.x);
    }
    /**
     * Konstruktor
     */    
    public Sgn(){
        super();
    }
}