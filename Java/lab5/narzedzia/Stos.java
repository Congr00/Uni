package narzedzia;

import java.util.ArrayDeque;
import narzedzia.ONP_PustyStos;

/**
 * Klasa reprezuntujaca strukture stosu
 */
public class Stos{
    private ArrayDeque<Double> stos;
    /**
     * Konstruktor inicjalizujacy stos
     */
    public Stos(){
        this.stos = new ArrayDeque<>();
    }
    /**
     * Funkcja dodaje element na koniec
     * @param s element do dodania
     */
    public void Push(Double s){
        this.stos.addLast(s);
    }
    /**
     * Funkcja sprawdzajaca czy stos jest pusty
     * @return wartosc boolowska, czy stos jest pusty
     */
    public Boolean isEmpty(){
        return this.stos.isEmpty();
    }
    /**
     * Funkcja zwraca i usuwa ostatni element ze stosu
     * @throws ONP_PustyStos jesli stos jest pusty
     * @return wartosc ostatniego elementu
     */
    public Double Pop() throws ONP_PustyStos{
        if(stos.isEmpty())
            throw new ONP_PustyStos();
        return stos.removeLast();
    }
}