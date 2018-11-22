package narzedzia;

/**
 * Klasa reprezentujaca liczbe
 */
public class Liczba extends Operand{
    private Double val;
    /**
     * Konstruktor
     * @param v wartosc ktora przyjmuje liczba
     */
    public Liczba(Double v){
        this.val = v;
    }
    @Override
    /**
     * Wartosc liczby
     * @return wartosc liczby
     */
    public Double oblicz(){
        return val;
    }
}