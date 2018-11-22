package narzedzia;

/**
 * Klasa reprezentujaca stala Pi
 */
public class Pi extends Funkcja{
    @Override
    /**
     * Funkcja zwracajaca wartosc Pi
     */    
    public Double oblicz(){
        return Math.PI;
    }
    /**
     * Konstruktor
     */    
    public Pi(){
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