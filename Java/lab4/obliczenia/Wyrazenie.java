package obliczenia;

/**
 * Abstrakcyjna metoda reprezentujaca wyrazenie
 */
public abstract class Wyrazenie implements Obliczalny{
    /**
     * Metoda zwraca sume dowolnie podanych wyrazen
     * @param wyr ciag wyrazen do zsumowania
     * @return wynik sumowania ciagu wyrazen
     */
    public static double suma(Wyrazenie... wyr){
        double res = 0.0;
        for (Wyrazenie var : wyr) {
            res += var.oblicz();
        }
        return res;
    }
    /**
     * Metoda zwraca iloczyn dowolnie podanych wyrazen
     * @param wyr ciag wyrazen do przemnozenia
     * @return wynik mnozenia ciagu wyrazen
     */    
    public static double iloczyn(Wyrazenie... wyr){
        double res = 1.0;
        for (Wyrazenie var : wyr) {
            res *= var.oblicz();
        }
        return res;
    }  
    public Boolean equals(Wyrazenie wyr){
        return this.oblicz() == wyr.oblicz();
    }
    public String toString(Wyrazenie wyr){
        return wyr.toString();
    }
    /**
     * Metoda obliczajaca dana operacje przy podanych argumentach
     * @return zwraca wynik operacji na danych argumentach o typie double
     */    
    public abstract double oblicz();
}