package obliczenia;

import java.lang.Math.*;

/**
 * Klasa reprezentujaca potegowanie podanych wyrazen
 */
public class Poteguj extends Wyrazenie{
    private Wyrazenie w1, w2;
    /**
     * Publiczny kontruktor budujacy wyrazenie
     * @param w1 pierwsze wyrazenie do wymnozenia
     * @param w2 drugie wyrazenie do wymnozenia
     */
    public Poteguj(Wyrazenie w1, Wyrazenie w2){
        this.w1 = w1;
        this.w2 = w2;
    }
    @Override    
    public double oblicz(){
        return  Math.pow(this.w1.oblicz(), this.w2.oblicz());
    }
    @Override
    public String toString(){
        return this.w1.toString() + "^" + this.w2.toString();
    }
}