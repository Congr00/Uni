package narzedzia;
/**
 * Klasa reprezentujaca funkcje dzielenia
 */
public class Dzielenie extends DwuArny{
    @Override
    /**
     * funkcja oblicza wartosc funkcji
     * @throws ONP_dzieleniePrzez0 blad dzielenia przez zero
     */
    public Double oblicz() throws ONP_DzieleniePrzez0{
        if(this.y == 0)
            throw new ONP_DzieleniePrzez0(Double.toString(this.x) + " / 0");
        return this.x / this.y;
    }
    /**
     * Konstruktor
     */
    public Dzielenie(){
        super();
    }
}