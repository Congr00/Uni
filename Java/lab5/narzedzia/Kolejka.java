package narzedzia;

import java.util.ArrayDeque;

/**
 * Klasa reprezentujaca strukture kolejki
 */
public class Kolejka{
    private ArrayDeque<Symbol> kolejka;
    /**
     * Konstruktor inicjalizuje kolejke
     */
    public Kolejka(){
        this.kolejka = new ArrayDeque<>();
    }
    /**
     * Funkcja dodaje elemenet na poczatek kolejki
     * @param s element do dodania
     */
    public void Push(Symbol s){
        this.kolejka.addFirst(s);
    }
    /**
     * Funkcja zwraca oraz usuwa pierwszy element kolejki
     * @return pierwszy element kolejki
     * @throws ONP_PustyStos jesli stos jest pusty
     */
    public Symbol Pop() throws ONP_PustyStos{
        if(kolejka.isEmpty())
            throw new ONP_PustyStos();
        return kolejka.removeFirst();
    }
    /**
     * Metoda zwraca pierwszy element kolejki
     * @return pierwszy element kolejki
     * @throws ONP_PustyStos gdy stos jest pusty
     */
    public Symbol get() throws ONP_PustyStos{
        if(kolejka.isEmpty())
            throw new ONP_PustyStos();
        return kolejka.getFirst();                
    }
    /**
     * Metoda zwracajaca dlugosc kolejki
     * @return dlugosc kolejki
     */
    public int Len(){
        return kolejka.size();
    }
}