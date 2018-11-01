package obliczenia;

import static java.lang.Math.*;

/**
 * Klasa reprezentujaca funcje bezwzglednosci
 */
public class Abs extends Wyrazenie{
    private Wyrazenie w1;
    /**
     * Publiczny konstruktor wyrazenia
     * @param w1 Wyrazenie ktorego wartosc absolutna jest zwracana
     */
    public Abs(Wyrazenie w1){
        this.w1 = w1;
    }
    @Override
    public double oblicz(){
        return Math.abs(this.w1.oblicz());
    }
    @Override
    public String toString(){
        return "|" + this.w1.toString() + "|";
    }
}