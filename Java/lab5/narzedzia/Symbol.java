package narzedzia;

import narzedzia.Obliczalny;

/**
 * Abstrakcyjna klasa reprezentujaca symbol
 */
public abstract class Symbol{
    /**
     * Mozliwe typy symboli w onp
     */
    public enum Typ{
        Operand, Funkcja;
    }
    /**
     * Abstrancyjna funkcja zwracajaca typ symbolu
     * @return typ sumbolu
     */
    public abstract Typ getType(); 
}