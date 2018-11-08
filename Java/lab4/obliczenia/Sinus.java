package obliczenia;

import java.lang.Math;

/**
 * Klasa reprezentujaca funkcje sin
 */
public class Sinus extends op_jedno{
    /**
     * Publiczny konstruktor wyrazenia
     * @param w1 Wartosc przekazana funkcji sinus
     */
    public Sinus(Wyrazenie w1){
        super(w1);
    }
    @Override    
    public double oblicz(){
        return Math.sin(this.w1.oblicz());
    }
    @Override
    public String toString(){
        return "sin(" + this.w1.toString() + ")";
    }
}