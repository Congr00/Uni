package obliczenia;

import static java.lang.Math.*;

/**
 * Klasa reprezentujaca funkcje cos
 */
public class Cosinus extends op_jedno{
    /**
     * Publiczny konstruktor wyrazenia
     * @param w1 argument dla funkcji cosinus
     */
    public Cosinus(Wyrazenie w1){
        super(w1);
    }
    @Override
    public double oblicz(){
        return Math.cos(this.w1.oblicz());
    }
    @Override
    public String toString(){
        return "cos(" + this.w1.toString() + ")";
    }
}