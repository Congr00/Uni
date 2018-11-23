package narzedzia;

/**
 * Klasa reprezentujaca wyjatek wystepujacy przy wykryciu zlych argumentow dla logarytmu
 *
 */
public class ONP_ZlyLog extends WyjatekONP{ 
    private static final long serialVersionUID = 1024;    
    /**
     * Konstruktor wyjatku
     * @param msg opis wyrazenia ktory wywolal blad
     */    
    public ONP_ZlyLog(String msg){
        super("Zle argumenty dla logarytmu: '" + msg + "'!");
    }
}