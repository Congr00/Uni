package narzedzia;

/**
 * Klasa reprezentujaca wyjatek wystepujacy przy wykryciu dzielenia przez 0
 */
public class ONP_DzieleniePrzez0 extends WyjatekONP{ 
    private static final long serialVersionUID = 1024;
    /**
     * Konstruktor wyjatku
     * @param wyr opis wyrazenia ktory wywolal blad
     */        
    public ONP_DzieleniePrzez0(String wyr){
        super("Blad dzielenia przez 0 w: '" + wyr + "'!");
    }
}