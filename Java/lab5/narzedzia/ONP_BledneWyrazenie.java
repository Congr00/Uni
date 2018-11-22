package narzedzia;

/**
 * Klasa reprezentujaca wyjatek wystepujacy przy wykryciu blednego wyrazenia
 */
public class ONP_BledneWyrazenie extends WyjatekONP{
    private static final long serialVersionUID = 1024;
    /**
     * Konstruktor wyjatku
     * @param wyr opis wyrazenia ktory wywolal blad
     */
    public ONP_BledneWyrazenie(String wyr){
        super("Bledne wyrazenie: '" + wyr + "'!");
    }
}