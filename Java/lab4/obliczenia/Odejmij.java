package obliczenia;

/**
 * Klasa reprezentujaca operacje odejmowania
 */
public class Odejmij extends Wyrazenie{
    private Wyrazenie w1, w2;
    /**
     * Publiczny konstruktor wyrazenia
     * @param w1 pierwsze wyrazenie
     * @param w2 wyrazenie ktore odejmujemy od parametru w1
     */
    public Odejmij(Wyrazenie w1, Wyrazenie w2){
        this.w1 = w1;
        this.w2 = w2;
    }
    @Override
    public double  oblicz(){
        return this.w1.oblicz() - this.w2.oblicz();
    }
    @Override
    public String toString(){
        return this.w1.toString() + " - " + this.w2.toString();
    }
}