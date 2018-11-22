package narzedzia;

import java.util.TreeMap;

/**
 * Klasa reprezentujaca zbior(dziedzine) zmiennych
 */
public class Zbior{
    private TreeMap<String, Double> map;
    /**
     * Konstruktor inicjalizujacy zbior
     */
    public Zbior(){
        this.map = new TreeMap<>(); 
    }
    /**
     * Funkcja pobiera wartosc podanej zmiennej
     * @param s nazwa zmiennej
     * @return wartosc zmiennej s
     * @throws ONP_NieznanySymbol jesli zmienna nie istnieje w dziedzinie
     */
    public Double Get(String s) throws ONP_NieznanySymbol{
        Double res = map.get(s);
        if(res == null)
            throw new ONP_NieznanySymbol(s);
        return res;
    }
    /**
     * Funkcja dodaje nowa zmienna wraz z przypisana wartoscia
     * @param s nazwa zmiennej
     * @param v wartosc zmiennej
     */
    public void Add(String s, Double v){
        this.map.put(s, v);
    }
    /**
     * Metoda usuwa zmienna ze zbioru
     * @param s nazwa zmiennej
     */
    public void Remove(String s){
        this.map.remove(s);
    }
    /**
     * Funkcja czysci dziedzine
     */
    public void Clear(){
        this.map.clear();
    }
}