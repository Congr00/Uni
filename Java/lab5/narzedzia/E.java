package narzedzia;

/**
 * Klasa reprezentujaca stala E
 */
public class E extends Funkcja{
    @Override
    /**
     * Funkcja zwracajaca wartosc E
     */
    public Double oblicz(){
        return Math.E;
    }
    /**
     * Konstruktor
     */
    public E(){
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