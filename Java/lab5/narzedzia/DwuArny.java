package narzedzia;

/**
 * Abstrakcyjna klasa reprezentujaca funkcje dwu-arne
 */
public abstract class DwuArny extends Funkcja{
    protected Double x = null, y = null;
    @Override
    /**
     * Funkcja zwracajaca arnosc, w tym przypadku zawsze 2
     */
    public int arnosc() {
        return 2;
    }
    @Override
    /**
     * Funkcja zwracajaca ilosc brakujacych argumentow
     */
    public int brakujaceArg() {
        if(y != null)
            return 0;
        return (x == null) ? 2 : 1;
    }
    @Override
    /**
     * Funkcja dodajaca argument dla funkcji
     * @param arg wartosc argumentu
     */
    public void dodajArgument(double arg) {
        if(x != null)
            y = arg;
        else
            x = arg;
    }
    public DwuArny(){
        super();
    }
}