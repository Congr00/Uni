package narzedzia;

/**
 * Klasa reprezentujaca funkcje max
 */
public class Sin extends Arny{
    @Override
    /**
     * Metoda obliczajaca wartosc funkcji
     */    
    public Double oblicz(){
        return Math.sin(this.x);
    }
    /**
     * Konstruktor
     */    
    public Sin(){
        super();
    }
}