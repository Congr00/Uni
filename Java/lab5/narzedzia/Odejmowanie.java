package narzedzia;

/**
 * Klasa reprezentujaca funkcje odejmowania
 */
public class Odejmowanie extends DwuArny{
    @Override
    /**
     * Metoda wylicza wartosc funkcji
     */
    public Double oblicz() {
        return this.x - this.y;
    }
    /**
     * Konstruktor
     */
    public Odejmowanie(){
        super();
    }
}