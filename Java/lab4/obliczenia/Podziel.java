package obliczenia;

/**
 * Klasa reprezentujaca wyrazenie dzielenia
 */
public class Podziel extends op_dwu{
    /**
     * Publiczny kontruktor wyrazenia
     * @param w1 Pierwsze wyrazenie
     * @param w2 Wyrazenie przez ktore nastepuje dzielenie
     */
    public Podziel(Wyrazenie w1, Wyrazenie w2){
        super(w1, w2);
    }
    /**
     * Metoda obliczenia dla dzielenia
     * @return zwrac wynik dzielenia
     * @throws IllegalArgumentException jesli nastapi dzielenie przez zero 
     */
    @Override
    public double  oblicz(){
        double check = this.w2.oblicz();
        if(check == 0)
            throw new IllegalArgumentException("Blad dzielenia przez zero!");
        return this.w1.oblicz() / check;
    }
    @Override
    public String toString(){
        return this.w1.toString() + " / " + this.w2.toString();
    }
}