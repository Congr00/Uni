package obliczenia;

/**
 * Publiczna klasa operatora jednoargumentowego
 */
public abstract class op_jedno extends Wyrazenie{
    protected Wyrazenie w1;
    /**
     * Publiczny konstruktor wyrazenia
     * @param w1 argument dla funkcji
     */
    public op_jedno(Wyrazenie w1){
        this.w1 = w1;
    }
    /**
     * Metoda obliczajaca dana operacje przy podanych argumentach
     * @return zwraca wynik operacji na danych argumentach o typie double
     */    
    public abstract double oblicz();    
}