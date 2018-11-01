package obliczenia;

import java.lang.Math;
 /**
  * Klasa reprezentujaca funkcje tangens
  */
public class Tangens extends Wyrazenie{
    private Wyrazenie w1;
    /**
     * Publiczny konstruktor
     * @param w1 argument przekazany do funkcji tangens
     */
    public Tangens(Wyrazenie w1){
        this.w1 = w1;
    }
    @Override
    public double oblicz(){
        return Math.tan(this.w1.oblicz());
    }
    @Override
    public String toString(){
        return "tan(" + this.w1.toString() + ")";
    }
}