package narzedzia;

/**
 * Abstrakcyjna klasa reprezentujaca typ funkcyjny
 */
public abstract class Funkcja extends Symbol implements Funkcyjny{
    @Override
    /**
     * Zwraca jeden z mozliwych typow, w tym przypadku funkcja
     */
    public Typ getType() {
        return Typ.Funkcja;
    }
    /**
     * Konstruktor
     */
    public Funkcja(){}
}