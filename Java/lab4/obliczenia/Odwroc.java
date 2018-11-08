package obliczenia;


/**
 * Klasa reprezentujaca Odwrotnosci podanego wyrazenia
 */
public class Odwroc extends op_jedno{
    /**
     * Publiczny konstruktor wyrazenia
     * @param w1 wyrazenie ktorego odwrotnosc jest wynikiem
     */
    public Odwroc(Wyrazenie w1){
        super(w1);
    }
    @Override
    public double oblicz(){
        double check = this.w1.oblicz();
        if(check == 0.0)
            return 0.0;
        return 1 / check;
    }
    @Override
    public String toString(){
        return  this.w1.toString() + "^-1";
    }
}