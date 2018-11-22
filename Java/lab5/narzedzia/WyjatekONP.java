package narzedzia;

/**
 * Klasa reprezentujaca kustomowy wyjatek 
 */
public class WyjatekONP extends Exception{
    private static final long serialVersionUID = 1024;
    /**
     * Konstruktor wyjatku
     * @param msg opis wyrazenia ktory wywolal blad
     */    
    public WyjatekONP(String msg){
        super(msg);
    }
}