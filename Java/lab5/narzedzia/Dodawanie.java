package narzedzia;

/**
 * Klasa reprezentujaca funkcje dodawania
 */
public class Dodawanie extends DwuArny{
    @Override
    /**
     * Funkcja oblicza wartosc funkcji
     */
    public Double oblicz() {
        return this.x + this.y;
    }
    /**
     * Konstruktor
     */
    public Dodawanie(){
        super();
    }
}