package obliczenia;

import java.lang.Math.*;

/**
 * Klasa repreentujaca logarytm 
 */
public class Log extends Wyrazenie{
    private Wyrazenie w1, w2;
    /**
     * Publiczny kontruktor 
     * @param w1 Wyrazenie ktore jest podstawa logarytmu
     * @param w2 Wyrazenie ktore zostanie zlogarytmowane przy podanej bazie
     */
    public Log(Wyrazenie w1, Wyrazenie w2){
        this.w1 = w1;
        this.w2 = w2;
    }
    /**
     * Funkcja obliczajaca wyrazenie
     * @return wynik wyrazenia
     * @throws IllegalArgumentException jesli podstawa logarytmu jest niedodatnia, lub argument logarytmu jest ujemny
     */
    @Override    
    public double oblicz(){
        double w1 = this.w1.oblicz();
        double w2 = this.w2.oblicz();
        // sprawdz warunki na LOG (nieujemne itp)
        if(w1 < 1)
            throw new IllegalArgumentException("Podstawa logarytmu nie moze byc ujemna");
        if(w2 < 0)
            throw new IllegalArgumentException("Argument logarytmu nie moze byc ujemny");
        return new Podziel(new Liczba(Math.log(w2)), new Liczba(Math.log(w1))).oblicz();
    }
    @Override
    public String toString(){
        return "log_" + this.w1.toString() + "("+ this.w2.toString() + ")";
    }
}