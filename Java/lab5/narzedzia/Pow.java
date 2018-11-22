package narzedzia;

import java.lang.Math.*;

/**
 * Klasa reprezentujaca funkcje power
 */
public class Pow extends DwuArny{
    @Override
    /**
     * Metoda obliczajaca wartosc funkcji
     */    
    public Double oblicz(){
        return Math.pow(this.x, this.y);
    }
    /**
     * Konstruktor
     */    
    public Pow(){
        super();
    }
}