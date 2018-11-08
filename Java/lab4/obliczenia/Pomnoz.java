package obliczenia;


/**
 * Publiczna klasa operacji mnozenia
 */
public class Pomnoz extends op_dwu{
    /**
     * Publiczny kontruktor wyrazenia
     * @param w1 pierwsze wyrazenie
     * @param w2 wyrazenie przez ktore wykonywane jest mnozenie
     */
    public Pomnoz(Wyrazenie w1, Wyrazenie w2){
        super(w1, w2);
    }
    @Override
    public double oblicz(){
        return this.w1.oblicz() * this.w2.oblicz();
    }
    @Override
    public String toString(){
        return this.w1.toString() + " * " + this.w2.toString();
    }
}