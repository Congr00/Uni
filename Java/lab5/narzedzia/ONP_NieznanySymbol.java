package narzedzia;

/**
 * Klasa reprezentujaca wyjatek wystepujacy przy wykryciu nieznanego symbolu
 */
public class ONP_NieznanySymbol extends WyjatekONP{
    private static final long serialVersionUID = 1024;  
    /**
     * Konstruktor wyjatku
     * @param symbol opisy wyrazenia ktory wywolal blad
     */      
    public ONP_NieznanySymbol(String symbol){
        super("Wykryto nieznany symbol: '" + symbol + "'!");
    }
}