package narzedzia;

/**
 * Klasa reprezentujaca wyjatek wystepujacy przy wykryciu pustego stosu
 */
public class ONP_PustyStos extends WyjatekONP{ 
    private static final long serialVersionUID = 1024;    
    /**
     * Konstruktor wyjatku
     */    
    public ONP_PustyStos(){
        super("Brak wartosci do obliczenia: pusty stos!");
    }
}