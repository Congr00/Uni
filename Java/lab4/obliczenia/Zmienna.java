package obliczenia;

import struktury.*;

/**
 * Klasa reprezentujaca zmienna
 */
public class Zmienna extends Wyrazenie{
    private static final ZbiorNaTablicyDynamicznej vars = new ZbiorNaTablicyDynamicznej();
    private String name;    
    /**
     * Publiczny kontruktor
     * @param name Nazwa zmiennej, ktora ma reprezentowac dany obiekt
     */
    public Zmienna(String name){
        this.name = name;
    }
    /**
     * Metoda ustawia wartosc danej zmiennej
     * @param w1 wyrazenie, ktorego wynik zostanie podstawiony pod zmienna
     */
    public void Set(Wyrazenie w1){
        vars.ustaw(new Para(this.name, w1.oblicz()));
    }
    /**
     * Funkcja obliczajaca wyrazenie
     * @return wynik wyrazenia
     * @throws IllegalArgumentException jesli podana zmienna nie nalezy do dziedziny
     */
    @Override
    public double oblicz(){
        double res = 0.0;
        try{
            res = vars.czytaj(this.name);
        }
        catch(UnknownError err){
            throw new IllegalArgumentException("Podana zmienna" + this.name + "nie istnieje w dziedzinie");
        }   
        return res;
    }
    @Override
    public String toString(){
        return this.name;
    }
}