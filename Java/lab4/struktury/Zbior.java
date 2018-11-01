package struktury;

/**
 * Abstrakcyjna klasa zbior, po ktorej dzidzicza zaimplementowane zbiory
 */
public abstract class Zbior{    
    protected Para[] data;
    protected int    size;
    protected int    ptr = 0;

    /**
     * metoda zwraca wartosc pary przechowywanej w zbiorze
     * @param k klucz szukanej pary
     * @return znaleziona para
     * @throws Exception jesli dany klucz nie istnieje w zbiorze
     */    
    public abstract Para szukaj(String k) throws Exception;
    /**
     * metoda wstawia podana pare do bazy
     * @param p para do wstawienia
     * @throws Exception jesli zabraknie miejsca w zbiorze
     */    
    public abstract void wstaw (Para p)   throws Exception;
    /**
     * metoda zwraca wartosc pary przechowywanej w zbiorze
     * @param k klucz szukanej pary
     * @return wartosc znalezionej pary
     * @throws Exception jesli dana para nie istnieje
     */
    public abstract double czytaj(String k) throws Exception;
    /**
     * metoda zmienia wartosc pary w zbiorze na podana w argumencie lub dodaje, jesli taka nie istnieje
     * @param p para do dodania lub zaktualizowania
     * @throws Exception gdy skonczy sie miejsce w zbiorze
     */
    public abstract void ustaw (Para p)   throws Exception;
    /**
     * metoda usuwa wszystkie elementy ze zbioru
     */
    public abstract void czysc ();
    /**
     * metoda mowi ile aktualnie jest elementow w zbiorze
     * @return ilosc elementow w zbiorze
     */
    public abstract int ile();
}