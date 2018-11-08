package obliczenia;

/**
 * Publiczna klasa operatora dwuargumentowego
 */
public abstract class op_dwu extends op_jedno{
    protected Wyrazenie w2;
    /**
     * Publiczny konstruktor wyrazenia
     * @param w1 argument dla funkcji
     * @param w2 argument 2 dla funkcji
     */
    public op_dwu(Wyrazenie w1, Wyrazenie w2){
        super(w1);
        this.w2 = w2;
    }
    /**
     * Metoda obliczajaca dana operacje przy podanych argumentach
     * @return zwraca wynik operacji na danych argumentach o typie double
     */    
    public abstract double oblicz();    
}