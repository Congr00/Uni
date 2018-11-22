package narzedzia;

import narzedzia.Operand;

/**
 * Funkcja reprezentujaca zmienna
 */
public class Zmienna extends Operand{

    private Double val;
    private String name;
    /**
     * Konstruktor zmiennej
     * @param v wartosc zmiennej
     * @param n nazwa zmiennej
     */
    public Zmienna(Double v, String n){
        this.val = v;
        this.name = n;
    }
    @Override
    /**
     * Zwraca wartosc zmiennej
     * @return wartosc zmiennej
     */
    public Double oblicz(){
        return val;
    }
}