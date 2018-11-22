package narzedzia;

/**
 * Abstrakcyjna klasa reprezentujaca arne funkcje
 */
public abstract class Arny extends Funkcja{
    protected Double x = null;
    @Override
    /**
     * Funkcja zwraca arnosc funkcji (w tym przypadku 1 argumentowa)
     */
    public int arnosc() {
        return 1;
    }
    /**
     * Funkcja zwracajaca ilosc brakujacych argumentow pozwalajacych na obliczenie wartosci
     */
    @Override
    public int brakujaceArg() {
        return (x == null) ? 1 : 0;
    }
    @Override
    /**
     * funkcja dodajaca argument dla funkcji
     * @param arg wartosc argumentu
     */
    public void dodajArgument(double arg) {
        this.x = arg;
    }
    /**
     * Konstruktor
     */
    public Arny(){
        super();
    }
}