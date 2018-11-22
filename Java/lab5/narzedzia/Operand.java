package narzedzia;

import narzedzia.Obliczalny;

/**
 * Abstrakcyjna klasa reprezentujaca operand
 */
public abstract class Operand extends Symbol implements Obliczalny{
    @Override
    /**
     * Zwraca typ klasy - operand
     */
    public Typ getType() {
        return Typ.Operand;
    }
}