package obliczenia;

/**
 * Klasa reprezentujaca wyrazenie przeciwnosci
 */
public class Przeciwnosc extends op_jedno{
    /**
     * Publiczny konstruktor wyrazenia
     * @param w1 wyrazenie ktorego przeciwnosc jest zwracana
     */
    public Przeciwnosc(Wyrazenie w1){
        super(w1);
    }
    @Override
    public double oblicz(){
        return -this.w1.oblicz();
    }
    @Override
    public String toString(){
        return "-" + this.w1.toString();
    }
}