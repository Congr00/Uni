package obliczenia;

public class Liczba extends Wyrazenie{
    private double value;
    public Liczba(double var){
        this.value = var;
    }
    @Override
    double oblicz(){
        return this.value;
    }
}