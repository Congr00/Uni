package obliczenia;

import java.lang.Math.*;

/**
 * Klasa reprezentujaca najwazniejsze matematyczne stale
 */
public class Stala extends Wyrazenie{
      
    private static final double e  = Math.E;  
    private static final double fi = 1.62;   
    private static final double pi = Math.PI;

    private Liczba val;

    /** Enum zawierajacy dostepne stale 
     *  E  stala Eulera
     *  FI stala zlotego podzialu
     *  PI stala liczba pi
     */      
    public enum Typ{
        E,FI,PI;
    }
    /**
     * Publiczny kontruktor stalej
     * @param t Zmienna enum ktora odpowiada danej stalej
     */
    public Stala(Typ t){
        switch(t){
            case E:
                this.val = new Liczba(e);
            break;
            case FI:
                this.val = new Liczba(fi);
            break;
            case PI:
                this.val = new Liczba(pi);
        }
    }
    public double oblicz(){
        return this.val.oblicz();
    }
    @Override
    public String toString(){
        return "s";
    }

}