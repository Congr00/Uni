package narzedzia;

import java.lang.Math.*;

/**
 * Klasa reprezentujaca funkcje loga_b
 */
public class Log extends DwuArny{
    @Override
    /**
     * Funkcja wylicza wartosc log_a(b)
     * @throws ONP_ZlyLog jesli nie sa spelnione warunki logarytmu (x < 0 lub y == 1 lub y < 0)
     */
    public Double oblicz() throws ONP_ZlyLog{
        if(this.x < 0 || this.y == 1)
            throw new ONP_ZlyLog("log_" + Double.toString(this.x) + "(" + Double.toString(this.y) + ")");
        if(this.y < 0)
            throw new ONP_ZlyLog("log_" + Double.toString(this.x) + "(" + Double.toString(this.y) + ")");
        return Math.log(x) / Math.log(y);
    }
    /**
     * Konstruktor
     */
    public Log(){
        super();
    }
}