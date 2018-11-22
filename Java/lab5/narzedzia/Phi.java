package narzedzia;

/**
 * Klasa reprezentujaca stala Phi
 */
public class Phi extends Funkcja{
    private static final double PHI = 1.61803398875; 
    /**
     * Funkcja zwracajaca wartosc Phi
     */
    @Override
    public Double oblicz(){
        return PHI;
    }
    /**
     * Konstruktor
     */
    public Phi(){
        super();
    }
    @Override
    /**
     * Arnosc funkcji, w tym przypadku 0
     */    
    public int arnosc() {
        return 0;
    }
    @Override
    /**
     * Funkcja zwraca ilosc brakujacych argumentow, tutaj zawsze 0
     */    
    public int brakujaceArg() {
        return 0;
    }
    @Override
    /**
     * Funkcja dodajaca argumenty dla funkcji
     * @param arg argument do dodania
     */    
    public void dodajArgument(double arg) {}
}