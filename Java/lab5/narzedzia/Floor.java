package narzedzia;

/**
 * Klasa reprezentujaca funkcje floor
 */
public class Floor extends Arny{
    @Override
    /**
     * Funkcja wylicza wartosc funkcji
     */
    public Double oblicz(){
        return Math.floor(this.x);
    }
    /**
     * Konstruktor
     */
    public Floor(){
        super();
    }
}