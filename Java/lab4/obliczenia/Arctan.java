package obliczenia;

import java.lang.Math;

/**
 * Klasa reprezentujaca funkcje arctan
 */
public class Arctan extends op_jedno{
    /**
     * Publiczny kontruktor 
     * @param w1 Wyrazenie ktore jest agrumentem dla funckji arctan
     */
    public Arctan(Wyrazenie w1){
        super(w1);
    }
    @Override
    public double oblicz(){
        return new Przeciwnosc((new Tangens(this.w1))).oblicz();
    }
    @Override
    public String toString(){
        return "atan(" + this.w1.toString() + ")";
    }
}