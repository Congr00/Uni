package struktury;

/**Klasa, ktora przechowuje wartosc klucza oraz przypisana do niego wartosc */
public class Para{
    /**Zmienna przechowujaca wartosc klucza */
    public final String klucz;
    private double wartosc;
    /**
     * Konstruktor przyjmujacy klucz oraz wartosc
     * @param k odpowiada kluczowi
     * @param w odpowiada sparowanej wartosci
     */
    public Para(String k, double w){
        if(k == null || k == "")
            throw new IllegalArgumentException("Wartosc klucza nie moze byc pusta");
        this.klucz = k;
        this.wartosc = w;
    }
    /**
     * Publiczny getter przypisanej wartosci
     * @return wartosc pola wartosc
     */
    public double getValue(){
        return this.wartosc;
    }
    /**
     * aktualizuje wartosc danej pary
     * @param w wartosc do zaktualizowania
     */
    public void setValue(double w){
        this.wartosc = w;
    }    
    /** Metoda zwracajaca dane Pare w postaci Stringa */
    @Override public String toString(){
        return this.klucz + " " + String.valueOf(wartosc);
    }
    /** Metoda sprawdzajaca czy podana para ma ten sam klucz
     *  @param p para do sprawdzenia
     *  @return zwraca wartosc logiczna, true gdy pary sa rowne, false w przeciwnym wypadku
     */    
    public boolean equals(Para p){
        return this.klucz == p.klucz;
    }    
}