package obliczenia;


/**
 * Klasa reprezentujaca operacje dodawania
 */
public class Dodaj extends op_dwu{
    /**
     * Publiczny kontruktor wyrazenia
     * @param w1 pierwsze wyrazenie do zsumowania
     * @param w2 drugie wyrazenie do zsumowania
     */
    public Dodaj(Wyrazenie w1, Wyrazenie w2){
        super(w1, w2);
    }
    @Override
    public double  oblicz(){
        return this.w1.oblicz() + this.w2.oblicz();
    }
    @Override
    public String toString(){
        return this.w1.toString() + " + " + this.w2.toString();
    }
}