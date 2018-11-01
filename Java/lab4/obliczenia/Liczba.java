package obliczenia;

/**
 * Klasa reprezentujaca liczbe rzeczywista
 */
public class Liczba extends Wyrazenie{
    private double value;
    /**
     * Publiczny kontruktor  
     * @param var klasa przyjmuje dana wartosc, czyli reprezentuje dana liczbe
     */
    public Liczba(double var){
        this.value = var;
    }
    @Override
    public double oblicz(){
        return this.value;
    }
    @Override
    public String toString(){
        return Double.toString(this.value);
    }
}